sub init()
    m.background = m.top.findNode("background")
    m.focusCell = m.top.findNode("focusCell")
    m.layoutGroup = m.top.findNode("layoutGroup")

    m.titleLabel = m.top.findNode("titleLabel")
    m.separator = m.top.findNode("separator")
    m.answerLabel = m.top.findNode("answerLabel")
    m.correctedPoster = m.top.findNode("correctedPoster")
    m.correctedLabel = m.top.findNode("correctedLabel")
    m.leftLabelsContainer = m.top.findNode("leftLabelsContainer")
    m.pointsLabel = m.top.findNode("pointsLabel")
    m.avaliablePointsLabel = m.top.findNode("avaliablePointsLabel")
    m.leftLabelsContainer = m.top.findNode("leftLabelsContainer")
end sub

sub configureDataSource()
    itemContent = m.top.itemContent
    configureDisign(itemContent.itemResults.status)

    m.titleLabel.text = itemContent.item.question
    m.answerLabel.text = itemContent.itemResults.answer
    m.correctedLabel.text = itemContent.itemResults.status

    if IsValid(itemContent.itemResults.wager)
        m.pointsLabel.text = itemContent.itemResults.wager.toStr()
    end if

    for each item in itemContent.item.answers
        if item.answer = itemContent.itemResults.answer
            m.avaliablePointsLabel.text = item.points
        end if
    end for

    layoutSubviews()
end sub

sub configureDisign(correctedText)
    m.titleLabel.font = getBoldFont(20)
    m.answerLabel.font = getRegularFont(20)
    m.correctedLabel.font = getRegularFont(10)
    m.pointsLabel.font = getRegularFont(20)
    m.avaliablePointsLabel.font = getRegularFont(20)
    m.separator.color = m.global.design.buttonBackgroundColor
    if correctedText = "Pending"
        m.correctedPoster.blendColor = m.global.design.buttonBackgroundColor
        m.avaliablePointsLabel.color = m.global.design.buttonBackgroundColor        
    else if correctedText = "finished" or correctedText = "Won"
        m.correctedPoster.blendColor = m.global.design.rightAnswerTextColor
        m.avaliablePointsLabel.color = m.global.design.rightAnswerTextColor
    else
        m.correctedPoster.blendColor = m.global.design.wrongAnswerTextColor
        m.avaliablePointsLabel.color = m.global.design.wrongAnswerTextColor
    end if
end sub

sub itemFocused()
    m.background.opacity = 1 - m.top.rowFocusPercent
    if not m.top.rowListHasFocus then m.background.opacity = 1
end sub

sub layoutSubviews()
    m.layoutGroup.translation = [10, 10]
    m.separator.width = m.top.width - 20
    m.separator.height = 1
    m.correctedPoster.width = 50
    m.correctedPoster.height = 15
    m.correctedLabel.width = m.correctedPoster.width 
    m.correctedLabel.height = m.correctedPoster.height 
    m.background.width = m.top.width
    m.background.height = m.top.height
    m.titleLabel.width = m.top.width
    m.pointsLabel.width = 100
    m.avaliablePointsLabel.width = 100
    m.leftLabelsContainer.translation = [m.top.width - m.leftLabelsContainer.boundingRect().width - 10, m.top.height - m.leftLabelsContainer.boundingRect().height - 5]
end sub