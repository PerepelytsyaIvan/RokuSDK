
function getConfigurationQuizeAnswer(items, group, boundingLabel)
    group.removeChildrenIndex(group.getChildCount(), 0)
    quizeAnswerView = group.createChild("QuizeAnswerView")
    quizeAnswerView.translation = [0, 20]
    quizeAnswerView.dataSource = items.answers
    label = group.createChild("Label")
    label.height = 80
    if items.isCorrectAnswer
        label.text = "AWESOME! You won 0 pts for the correct answer".Replace("0", items.expointsGiven)
        boundingRect = label.localBoundingRect()
        label.width = boundingRect.width
        label.vertAlign = "center"
    else
        label.text = "Wrong answer \nBetter luck next time".Replace("\n", chr(10))
        boundingRect = label.localBoundingRect()
        label.width = boundingRect.width / 2
        label.wrap = true
    end if

    if boundingRect.width > 500
        label.width = boundingRect.width / 2
        label.wrap = true
    end if
    label.translation = [200, boundingLabel.x]
    label.height = boundingLabel.height
    label.font = getRegularFont(32)
    label.lineSpacing = 0
    local = group.localBoundingRect()
    congigureSizeLayoutGroup(group, boundingLabel)
end function

sub congigureSizeLayoutGroup(layoutGroup, boundingLabel)
    boundingRect = layoutGroup.localBoundingRect()
    widthList = boundingRect.width

    maxWidth = 1920 - (boundingLabel.x + boundingLabel.width + 460)

    if widthList > maxWidth then widthList = maxWidth

    translationX = (((maxWidth - widthList)) / 2) + (boundingLabel.x + boundingLabel.width + 60)

    layoutGroup.translation = [translationX, 40 + (80 - boundingRect.height) / 2]
end sub

sub congigureSizesList(list, boundingLabel, countItems)
    widthList = (list.rowItemSize[0][0] * countItems) + (list.rowItemSpacing[0][0] * (countItems - 1))
    maxWidth = 1920 - (boundingLabel.x + boundingLabel.width + 460)

    if widthList > maxWidth then widthList = maxWidth

    translationX = (((maxWidth - widthList)) / 2) + (boundingLabel.x + boundingLabel.width + 60)

    list.itemSize = [widthList, list.rowItemSize[0][1]]
    list.translation = [translationX, 40 + (80 - list.rowItemSize[0][1]) / 2]
end sub

function configureContentNodeForTypePoll(markupGrid)
    
    
end function