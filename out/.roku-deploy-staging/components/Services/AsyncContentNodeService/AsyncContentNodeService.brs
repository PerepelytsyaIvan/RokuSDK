sub init()
    m.top.functionName = "configureContentNode"
end sub

function configureContentNode()
    rowContent = m.top.content.createChild("ContentNode")

    for each item in m.top.item.answers
        itemNode = rowContent.createChild("ContentNode")
        itemNode.title = item.answer
        itemNode.addFields({percent: getPercent(item.percent)})
        itemNode.addFields({answerSending: item.answerSending})
        itemNode.addFields({itemComponentName: "AnswerItemComponent"})
    end for
end function