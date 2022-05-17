sub init()
    m.questionLabel = m.top.findNode("questionLabel")
    m.background = m.top.findNode("background")
    m.containerContent = m.top.findNode("containerContent")
    m.separator = m.top.findNode("separator")
    m.infoLabel = m.top.findNode("infoLabel")
    m.progress = m.top.findNode("progress")
    m.infoLabel = m.top.findNode("infoLabel")
    m.layoutGroupWrongAnswer = m.top.findNode("layoutGroupWrongAnswer")
    m.layoutGroupRightAnswer = m.top.findNode("layoutGroupRightAnswer")
    m.imageCellRightAnswer = m.top.findNode("imageCellRightAnswer")
    m.imageCellWrongAnswer = m.top.findNode("imageCellWrongAnswer")
    m.rightAnswerLabel = m.top.findNode("rightAnswerLabel")
    m.wrongAnswerLabel = m.top.findNode("wrongAnswerLabel")
    m.isRightAnswer = false
    m.translationAnimation = m.top.findNode("translationAnimation")
    m.iterpolator = m.top.findNode("iterpolator")
    m.wikiLayout = m.top.findNode("wikiLayout")
    configureDesign()
end sub

sub configureDesign()
    m.questionLabel.font = getRegularFont(getSize(25))
    m.infoLabel.font = getRegularFont(getSize(25))
    m.wrongAnswerLabel.font = getBoldFont(getSize(25))
    m.rightAnswerLabel.font = getBoldFont(getSize(25))
    m.separator.blendColor = m.global.design.buttonBackgroundColor
    m.wrongAnswerLabel.color = m.global.design.wrongAnswerTextColor
    m.rightAnswerLabel.color = m.global.design.rightAnswerTextColor
end sub

sub configureDataSource()
    item = m.top.dataSource.poll
    m.isRightAnswer = false
    rightAnswer = {}
    wrongAnswer = {}
    storageData = RegRead(m.top.dataSource.poll._id["$id"], "Activity")
    if IsInvalid(storageData) then return
    storageItem = ParseJson(storageData)
    count = 0
    for each answer in item.answers
        answerStorage = storageItem.answers[count]
        count++
        if answerStorage.answer = m.top.dataSource.answer and answerStorage.answerSending
            m.isRightAnswer = true
            rightAnswer = answer
        else if answerStorage.answer = m.top.dataSource.answer and not answerStorage.answerSending
            rightAnswer = answer
        else if answer.answer <> m.top.dataSource.answer and answerStorage.answerSending
            m.isRightAnswer = false
            wrongAnswer = answer
        end if
    end for

    m.infoLabel.text = "Total Number of Goals at Full Time"
    m.imageCellRightAnswer.uri = getImageWithName(m.global.design.rightAnswerLogo)

    if m.isRightAnswer
        m.questionLabel.text = (m.global.localization.triviaRightAnswerNoteOne + "\n" + m.global.localization.triviaRightAnswerNoteTwo.Replace("{{ point }}", m.top.dataSource.winAmount)).Replace("\n", chr(10))
        m.rightAnswerLabel.text = rightAnswer.answer
    else
        m.imageCellWrongAnswer.uri =  getImageWithName(m.global.design.wrongAnswerLogo)
        m.questionLabel.text = (m.global.localization.triviaWrongAnswerNoteOne + "\n" + m.global.localization.triviaWrongAnswerNoteTwo).Replace("\n", chr(10))
        m.rightAnswerLabel.text = rightAnswer.answer
        m.wrongAnswerLabel.text = wrongAnswer.answer
    end if

    m.seconds = 30

    m.timer = configureTimer(0.1, true)
    m.timer.observeField("fire", "changeTimer")
    m.timer.control = "start"
    layoutSabviews()
    showNotification(true)
end sub

sub showNotification(asShow)
    if asShow
        m.iterpolator.keyValue = [[getScreenWidth(), getSize(50)], [(getScreenWidth() - (m.background.width + getSize(90))), getSize(50)]]
    else
        m.iterpolator.keyValue = [m.iterpolator.keyValue[1], [getScreenWidth(), getSize(50)]]
    end if
    m.translationAnimation.control = "start"
end sub

sub changeTimer()
    m.seconds -= 0.1
    if m.seconds <= 0
        m.timer.control = "stop"
        m.translationAnimation.observeField("state", "changeStateAnimation")
        showNotification(false)
        return
    end if
    progressPercent = (m.seconds / getSize(30)) * 100
    width = (progressPercent * (m.background.width - getSize(25))) / 100
    m.progress.width = width - getSize(25)
    if m.questionLabel.height = getSize(50)
        m.progress.translation = [m.background.width - width + getSize(12.5), m.background.height - getSize(2)]
    else
        m.progress.translation = [m.background.width - width + getSize(12.5), m.background.height - getSize(2)]
    end if
end sub

sub changeStateAnimation(event)
    state = event.getData()

    if state = "stopped"
        m.translationAnimation.unobserveField("state")
        m.top.removeWikiView = m.top
    end if
end sub

sub layoutSabviews()
    m.imageCellRightAnswer.width = getSize(25)
    m.imageCellRightAnswer.height = getSize(25)

    if not m.isRightAnswer
        m.wrongAnswerLabel.height = getSize(25)
        m.imageCellWrongAnswer.height = getSize(25)
        m.imageCellWrongAnswer.width = getSize(25)
    else
        m.containerContent.itemSpacings = [getSize(10), getSize(10), getSize(-10), getSize(-10)]
    end if

    m.infoLabel.width = m.background.width - (40)
    m.questionLabel.width = m.background.width - getSize(40)
    m.separator.height = getSize(1)
    m.separator.width = m.background.width - getSize(40)
    m.background.height = m.containerContent.boundingrect().height + getSize(40)
    m.wikiLayout.translation = [m.background.width - getSize(2), 0]
    m.wikiLayout.itemSpacings = [(m.background.height * getSize(20)) / getSize(100)]
end sub