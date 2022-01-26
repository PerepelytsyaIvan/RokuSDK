
function getAnswersContentWith(item, list)
    if IsValid(item) and isValid(list)
        contentNode = CreateObject("roSGNode", "ContentNode")
        list.content = contentNode
        asyncContentNodeService = CreateObject("roSGNode", "AsyncContentNodeService")
        asyncContentNodeService.item = item
        asyncContentNodeService.content = list.content
        asyncContentNodeService.control = "run"

        list.setFocus(false)
        maxWidthPercent = getWidthForText(getPercent(item.answers[0].percent), getBoldFont(25))
        maxWidthTitle = getWidthForText(item.answers[0].answer, getBoldFont(25))
    
        if maxWidthPercent > maxWidthTitle
            list.rowItemSize = [50, maxWidthPercent]
        else
            list.rowItemSize = [50, maxWidthTitle]
        end if
        
        count = 700 / (list.rowItemSize[0][0]) 
        if item.answers.count() < count
            count = item.answers.count()
        end if
        list.rowItemSize = [[list.rowItemSize[0][1], list.rowItemSize[0][0]]]
        list.itemSpacing = [0, 0]
        list.rowItemSpacing = [[0, 0]]
        list.translation = [(1920 - ((list.rowItemSize[0][0]) * count)) / 2, list.translation[1] - 10]
    end if
end function

function getConfigurationForLeftButton(button, list)
    contentNode = CreateObject("roSGNode", "ContentNode")
    rowNode = contentNode.createChild("ContentNode")
    count = 0

    for each item in button
        itemNode = rowNode.createChild("ContentNode")
        itemNode.addFields({ isSelected: count = 0 })
        itemNode.title = item
        count += 1
    end for

    list.rowItemSize = [[getWidthForText(item, getRegularFont(20)) + 10, 20]]
    list.itemSize = [(getWidthForText(item, getRegularFont(20)) + 20) * 2, 20]
    list.content = contentNode
end function

function getConfigurationForButtons(buttonsTitle, list, translationCordinate)
    if buttonsTitle.count() <> 0
        contentNode = CreateObject("roSGNode", "ContentNode")
        rowNode = contentNode.createChild("ContentNode")

        widthLabels = []

        for each item in buttonsTitle
            itemNode = rowNode.createChild("ContentNode")
            widthLabels.push(getWidthForText(item, getBoldFont(25)))
            itemNode.addFields({ itemComponentName: "ButtonItemComponents" })
            itemNode.title = item
        end for

        widthLabels.sort("r")
        count = 700 / (widthLabels[0])

        if buttonsTitle.count() < count
            count = buttonsTitle.count()
        end if
        
        list.rowItemSize = [[widthLabels[0] + 30, 35]]
        list.translation = [(1920 - ((list.rowItemSize[0][0]) * count)) / 2, translationCordinate.translation[1] + (translationCordinate.height - 35) / 2]
        list.content = contentNode
        list.setFocus(true)
    end if
end function