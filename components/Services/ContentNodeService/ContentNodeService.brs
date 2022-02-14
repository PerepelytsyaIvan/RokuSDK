
function getAnswersContentWith(item, list, boundingLabel)
    if IsValid(item) and isValid(list)
        contentNode = CreateObject("roSGNode", "ContentNode")
        list.content = contentNode
        asyncContentNodeService = CreateObject("roSGNode", "AsyncContentNodeService")
        asyncContentNodeService.item = item
        asyncContentNodeService.content = list.content
        asyncContentNodeService.control = "run"

        maxWidthPercent = 0
        maxWidthTitle = 0
        
        for each answ in item.answers
            width = getWidthForText(answ.answer, getBoldFont(25))
            percentWidth = getWidthForText(getPercent(answ.percent), getBoldFont(25))
            if width > maxWidthTitle
                maxWidthTitle = width
            end if

            if percentWidth > maxWidthPercent
                maxWidthPercent = percentWidth
            end if
        end for
    
        if maxWidthPercent > maxWidthTitle
            list.rowItemSize = [maxWidthPercent + 15, 70]
        else
            list.rowItemSize = [maxWidthTitle + 15, 70]
        end if
        
        congigureSizesList(list, boundingLabel, item.answers.count())
    end if
end function

function getConfigurationForLeftButton(button, list)
    contentNode = CreateObject("roSGNode", "ContentNode")
    rowNode = contentNode.createChild("ContentNode")
    count = 0
    widthLabels = []

    for each item in button
        itemNode = rowNode.createChild("ContentNode")
        itemNode.addFields({ isSelected: count = 0 })
        itemNode.title = item
        widthLabels.push(getWidthForText(item, getRegularFont(20)) + 10)
        count += 1
    end for
    widthLabels.sort("r")
    list.rowItemSize = [[widthLabels[0], 20]]
    list.itemSize = [(widthLabels[0] + 20) * 2, 20]
    list.content = contentNode
end function

function getConfigurationForButtons(items, list, boundingLabel)
    if items.answers.count() <> 0
        contentNode = CreateObject("roSGNode", "ContentNode")
        rowNode = contentNode.createChild("ContentNode")

        widthLabels = []

        for each item in items.answers
            itemNode = rowNode.createChild("ContentNode")
            itemNode.addFields({ itemComponentName: "ButtonItemComponents" })
            itemNode.title = item.answer
            if item.image <> ""
                itemNode.addFields({ iconUri: getImageWithName(item.image)})
                widthLabels.push(getWidthForText(item.answer, getBoldFont(25)) + 65)
            else
                widthLabels.push(getWidthForText(item.answer, getBoldFont(25)) + 10)
            end if
        end for

        widthLabels.sort("r")
       
        list.rowItemSize = [[widthLabels[0], 35]]
        congigureSizesList(list, boundingLabel, items.answers.count())
        list.focusBitmapUri="pkg:/images/focusButton.9.png" 
        list.content = contentNode
    end if
end function

function getConfigurationPrediction(items, list, boundingLabel)
    if items.answers.count() <> 0
        contentNode = CreateObject("roSGNode", "ContentNode")
        rowNode = contentNode.createChild("ContentNode")

        widthLabels = []

        for each item in items.answers
            itemNode = rowNode.createChild("ContentNode")
            itemNode.addFields({ itemComponentName: "PredictionItemComponent" })
            itemNode.title = item.answer
            if item.image <> ""
                widthLabels.push(getWidthForText(item.answer, getBoldFont(25)) + 70)
            else
                widthLabels.push(getWidthForText(item.answer, getBoldFont(25)) + 70)
            end if

            itemNode.addFields({ reward: item.reward})
            itemNode.addFields({ iconUri: "pkg:/images/predictionIcon.png"})
        end for

        widthLabels.sort("r")
        list.rowItemSize = [[widthLabels[0], 60]]
        congigureSizesList(list, boundingLabel, items.answers.count())
        list.focusBitmapUri="nil" 
        list.content = contentNode
    end if
end function

function getConfigurationRatingsContent(items, layoutGroup, translationCordinate)
    layoutGroup.removeChildrenIndex(layoutGroup.getChildCount(), 0)
    array = ["5", "4", "3", "2", "1"]

    for each item in array
        element = layoutGroup.createChild("RatingItemComponents")
        element.focusable = true
        element.title = item

        if item.toInt() = 0
            element.width = 20 + 20
        else
            element.width = (item.toInt() * 20) + 20
        end if
        element.height = 30
    end for
    layoutGroup.itemSpacings = [50]
    layoutGroup.translation = [700, 65]
end function

function getConfigurationRatingsAnswer(items, layoutGroup, boundingLabel)
    layoutGroup.removeChildrenIndex(layoutGroup.getChildCount(), 0)
    array = ["5", "4", "3", "2", "1"]
    isSetEpmtyStar = false
    count = 0
    element = layoutGroup.createChild("RatingAnswerItemComponents")
    element.title = "AVG"
    element.image = "nil"
    element.width = 30
    element.height = 30

    for each item in array
        element = layoutGroup.createChild("RatingAnswerItemComponents")

        if count = 4
            element.title = items.averageRate.toStr()
        end if

        if items.averageRate <= count 
            if isSetEpmtyStar
                element.image = getImageWithName(items.emptyIcon)
            else if type(items.averageRate) = "roFloat"
                element.image = getImageWithName(items.halfIcon)
                isSetEpmtyStar = true
            else
                isSetEpmtyStar = true
                element.image = getImageWithName(items.emptyIcon)
            end if
        else
            element.image = getImageWithName(items.icon)
        end if

        element.width = 30
        element.height = 30
        count ++
    end for
    congigureSizeLayoutGroup(layoutGroup, boundingLabel)
end function

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
