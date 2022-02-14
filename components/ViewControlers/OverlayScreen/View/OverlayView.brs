sub init()
    m.contentNodeService = CreateObject("roSGNode", "ContentNodeService")
    dependencyConnectionViews()
    configureObservers()
end sub

sub dependencyConnectionViews()
    m.questionLabel = m.top.findNode("questionLabel")
    m.timeLabel = m.top.findNode("timeLabel")
    m.secondsLabel = m.top.findNode("secondsLabel")

    m.logo = m.top.findNode("logo")
    m.backgroundOverlay = m.top.findNode("backgroundOverlay")
    m.gradient = m.top.findNode("gradient")
    m.separator = m.top.findNode("separator")

    m.panelGroup = m.top.findNode("panel")
    m.rowListGroup = m.top.findNode("rowListGroup")

    m.rowList = m.top.findNode("rowList")
    m.rowListLeftButton = m.top.findNode("rowListLeftButton")
    m.layoutGroup = m.top.findNode("layoutGroup")
    m.quizGruop = m.top.findNode("quizGruop")

    m.rowListAnimation = m.top.findNode("rowListAnimation")
    m.translationAnimation = m.top.findNode("translationAnimation")
    m.translationGradientAnimation = m.top.findNode("translationGradientAnimation")
    m.panelInterpolator = m.top.findNode("panelInterpolator")
    m.videoInterpolator = m.top.findNode("videoInterpolator")
    m.gradientInterpolator = m.top.findNode("gradientInterpolator")
    m.rowListInterpolator = m.top.findNode("rowListInterpolator")
    m.listsInterpolator = m.top.findNode("listsInterpolator")
    m.focusable = false
    m.asShowPanel = false
    m.focusKey = 0
end sub

sub configureObservers()
    m.rowList.observeField("itemSelected", "onItemSelected")
    m.rowListLeftButton.observeField("itemSelected", "onItemSelectedLeftButton")
end sub

sub onItemSelected(event)
    index = m.rowList.rowItemSelected[1]    
    m.top.selectedAnswer = m.top.eventInfo.answers[index] 
end sub

sub onItemSelectedLeftButton(event)
    index = m.rowListLeftButton.rowItemSelected[1]    
    title = m.rowListLeftButton.content.GetChild(0).GetChild(index)
    if title = "Close"
        m.top.videoPlayer.setFocus(true)
        showPanel(false)
    end if
end sub

sub configureDesign(event)
    designModel = event.getData()
    m.questionLabel.color = designModel.questionTextColor
    m.timeLabel.color = designModel.questionTextColor
    m.secondsLabel.color = designModel.questionTextColor

    m.logo.uri = designModel.logoImage
    m.backgroundOverlay.uri = designModel.backgrounImage
    m.rowList.focusBitmapBlendColor = designModel.buttonBackgroundColor
    m.rowListLeftButton.focusBitmapBlendColor = designModel.buttonBackgroundColor
    m.separator.blendColor = designModel.buttonBackgroundColor

    m.questionLabel.font = getBoldFont(30)
    m.timeLabel.font = getBoldFont(40)
    m.secondsLabel.font = getMediumFont(30)
    m.questionLabel.translation = [(m.logo.translation[0] + m.logo.width) + 20, m.backgroundOverlay.translation[1] + (m.backgroundOverlay.height - 70) / 2]
    m.questionLabel.height = 80

    m.contentNodeService.callFunc("getConfigurationForLeftButton", ["Account", "Close"], m.rowListLeftButton)
end sub

function showPanel(asShow, model = invalid)
    if asShow = m.asShowPanel
        m.asShowPanel = asShow
        m.playerAnimation.observeField("state", "onChnageStateAnimation")
        showPanel(false)
    else
        configureAnimationFor(asShow)
        m.translationGradientAnimation.control = "start"
        m.translationAnimation.control = "start"
        m.playerAnimation.control = "start"
        m.asShowPanel = asShow
    end if
end function

sub configureAnimationFor(showView)
    if isInvalid(m.playerAnimation)
        configurePlayerAnimation()
    end if

    if showView
        m.panelInterpolator.keyValue = [m.panelGroup.translation, [m.panelGroup.translation[0], m.panelGroup.translation[1] - m.backgroundOverlay.height]]
        m.gradientInterpolator.keyValue = [[0, 200], [m.panelGroup.translation[0], -200]]
        m.listsInterpolator.keyValue = [[0, 1080], [0, 930]]
        m.playerInterpolatorHeight.keyValue = [m.top.videoPlayer.height, m.top.videoPlayer.height - m.backgroundOverlay.height]
    else
        m.playerInterpolatorHeight.keyValue = [m.top.videoPlayer.height, m.top.videoPlayer.height + m.backgroundOverlay.height]
        m.listsInterpolator.keyValue = [[0, 930], [0, 1080]]
        m.panelInterpolator.keyValue = [m.panelGroup.translation, [m.panelGroup.translation[0], (m.panelGroup.translation[1] + m.backgroundOverlay.height)]]
        m.gradientInterpolator.keyValue = [[0, -200], [m.panelGroup.translation[0], 200]]
    end if
end sub

function showAnswers(eventModel)
    if eventModel.questionType = "injectRating"
        m.contentNodeService.callFunc("getConfigurationRatingsAnswer", eventModel, m.quizGruop, m.questionLabel.boundingRect())
    else if eventModel.questionType = "injectQuiz"
        m.contentNodeService.callFunc("getConfigurationQuizeAnswer", eventModel, m.layoutGroup, m.questionLabel.boundingRect())
        m.rowList.visible = false
        m.layoutGroup.visible = true
    else
        m.contentNodeService.callFunc("getAnswersContentWith", eventModel, m.rowList, m.questionLabel.boundingRect())
        m.rowListInterpolator.keyValue = [[0, m.rowList.itemSize[1]], [m.rowList.itemSize[0], 35 + 25]]
        m.rowListAnimation.control = "start"
        m.focusable = m.rowList.itemSize[0] < (m.rowList.rowItemSize[0][0] * eventModel.answers.Count() + (m.rowList.rowItemSpacing[0][0] * (eventModel.answers.Count() - 1)))
    end if
    m.contentNodeService.callFunc("getConfigurationForLeftButton", ["Close"], m.rowListLeftButton)
    m.rowListLeftButton.translation = [1745, 107]
    m.rowListLeftButton.setFocus(true)
end function

sub onChnageStateAnimation(event)
    state = event.getData()
    if state = "stopped"
        m.playerAnimation.unobserveField("state")
        showPanel(true)
    end if
end sub

sub configureRowList(model)
    if isInvalid(model) then return

    if model.questionType = "poll" or model.questionType = "injectPoll" or model.questionType = "injectQuiz" 
        m.contentNodeService.callFunc("getConfigurationForButtons", model, m.rowList, m.questionLabel.boundingRect())
        m.rowList.visible = true
        m.rowList.setFocus(true)
        m.layoutGroup.visible = false
    else if model.questionType = "injectRating"
        m.rowList.visible = false
        m.contentNodeService.callFunc("getConfigurationRatingsContent", model, m.layoutGroup, { translation: m.logo.translation, height: m.logo.height})
        m.layoutGroup.setFocus(true)
        m.layoutGroup.visible = true
        updateFocus(0)
    else if model.questionType = "prediction"
        m.contentNodeService.callFunc("getConfigurationPrediction", model, m.rowList, m.questionLabel.boundingRect())
        m.rowList.visible = true
        m.rowList.setFocus(true)
        m.layoutGroup.visible = false
    end if
    m.contentNodeService.callFunc("getConfigurationForLeftButton", ["Account", "Close"], m.rowListLeftButton)
    m.rowListLeftButton.translation = [1695, 107]
    m.focusable = true
end sub

sub configureUI()    
    eventInfo = m.top.eventInfo

    m.secondsLabel.text = "sec"
    m.questionLabel.text = eventInfo.question

    localBoundingRect = m.questionLabel.localBoundingRect()
    if localBoundingRect.width > 700
        m.questionLabel.width = localBoundingRect.width / 2
    else
        m.questionLabel.width = localBoundingRect.width
    end if

    m.separator.translation = [m.questionLabel.boundingRect().width + m.questionLabel.boundingRect().x + 30, m.logo.translation[1] + 10]

    if eventInfo.showAnswerview
        showAnswers(eventInfo)
    else
        configureRowList(eventInfo)
    end if

    showPanel(true, m.top.eventInfo)
end sub

sub configureSecondsLabel(seconds)
    m.timeLabel.text = seconds.toStr() 
    boundingRect = m.timeLabel.boundingRect()
    m.secondsLabel.height = boundingRect.height
    m.secondsLabel.translation = [boundingRect.x + boundingRect.width + 5, boundingRect.y - 3]
end sub

sub configurePlayerAnimation()
    parent = m.top.videoPlayer.getParent()
    m.playerAnimation = parent.createChild("Animation")
    m.playerAnimation.duration = 0.4
    m.playerAnimation.easeFunction = "linear"
    m.playerInterpolatorHeight = m.playerAnimation.createChild("FloatFieldInterpolator")
    m.playerInterpolatorHeight.fieldToInterp = m.top.videoPlayer.id + ".height"
    m.playerInterpolatorHeight.key= [0.0, 1.0]
end sub

sub unfocusAll()
    for i = 0 to m.layoutGroup.getChildCount()
        focusButton(m.layoutGroup.getChild(i), false)
    end for
end sub

sub updateFocus(key)
    unfocusAll()
    if key < m.layoutGroup.GetChildCount()
        focusButton(m.layoutGroup.GetChild(key), true)
    else
        m.rowListLeftButton.setFocus(true)
    end if
end sub

sub focusButton(button, focused)
    if button = invalid then return
    button.focused = focused
end sub


function onKeyEvent(key as string, press as boolean) as boolean
    result = false

    if not press then return result

    if key = "left"
        if m.rowList.visible and m.rowListLeftButton.hasFocus() and m.focusable
            m.rowList.setFocus(true)
            result = true
        else if m.layoutGroup.visible and m.rowListLeftButton.hasFocus() and m.focusable
            m.layoutGroup.setFocus(true)
            updateFocus(m.focusKey)
            result = true
        else
            m.focusKey = max(m.focusKey - 1, 0) 
            updateFocus(m.focusKey)
            result = true
        end if
    else if key = "right"
        if m.rowList.hasFocus()
            m.rowListLeftButton.setFocus(true)
            result = true
        else if m.layoutGroup.hasFocus() and m.focusKey < m.layoutGroup.GetChildCount() - 1
            m.focusKey = min(m.focusKey + 1, m.layoutGroup.GetChildCount() - 1)
            updateFocus(m.focusKey)
            result = true
        else
            m.rowListLeftButton.setFocus(true)
        end if
    else if key = "OK" and m.layoutGroup.hasFocus()
        item = m.layoutGroup.GetChild(m.focusKey)
        m.top.selectedAnswer = {"answer": item.title}
    end if

    return result
end function