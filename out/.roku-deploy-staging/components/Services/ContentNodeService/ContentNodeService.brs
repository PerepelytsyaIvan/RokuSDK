
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

function configureContentNodeForPoll(eventModel, markupGrid)
    contentNode = CreateObject("roSGNode", "ContentNode")
    rowHeights = []
    columnWidths = []
    columnSpacings = []
    For Each answer in eventModel.answers
        element = contentNode.createChild("ContentActivityModel")
        element.componentDataSource = answer
        size = getWidthElement(answer.itemcomponent, element)
        itemComponent = answer.itemcomponent
        rowHeights = size[1]
        columnWidths.push(size[0])
        columnSpacings.push(getSize(40))
    end for

    markupGrid.itemComponentName = itemComponent
    markupGrid.itemSize = [getSize(1200), rowHeights]
    markupGrid.rowHeights = rowHeights
    markupGrid.numColumns = eventModel.answers.count()
    markupGrid.columnWidths = columnWidths
    markupGrid.drawFocusFeedbackOnTop = false
    markupGrid.columnSpacings = columnSpacings
    markupGrid.focusBitmapUri = getFocusForEventType(eventModel.questionType)
    markupGrid.content = contentNode
    markupGrid.setFocus(true)
end function

sub getWidthElement(componentName, itemContent) as object
    componentName = CreateObject("roSGNode", componentName)
    componentName.itemContent = itemContent
    return [componentName.widthElement, componentName.heightElement]
end sub

sub getFocusForEventType(eventType) as object
    if eventType = "injectRating"
        return "pkg:/nil"
    else
        return "pkg:/images/gradienFocusButton.9.png"
    end if
end sub