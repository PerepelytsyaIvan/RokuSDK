sub init()
    m.rowList = m.top.findNode("rowList")
    m.rowList.observeField("rowItemSelected", "didSelectItem")
    m.top.observeField("focusedChild", "onFocusedChild")
    configureRowList()
end sub

sub configureRowList()
    contentNode = CreateObject("roSGNode", "ContentNode")
    rowContent = contentNode.createChild("ContentNode")
    elementContent = rowContent.createChild("ContentNode")
    elementContent.addField("image", "string", false)
    elementContent.addField("isStartRefresh", "boolean", false)
    elementContent.title = m.global.localization.refreshLeaderboard
    elementContent.image = "pkg:/images/refreshIcon.png"
    m.rowList.itemSize = [getSize(430), getSize(60)]
    m.rowList.rowItemSize = [[getSize(430), getSize(60)]]
    m.rowList.content = contentNode
end sub

sub didSelectItem()
    m.top.isRefresh = true
    m.rowList.content.getChild(0).getChild(0).isStartRefresh = true
    m.top.startRefresh = true
end sub

sub stopRefresh()
    m.rowList.content.getChild(0).getChild(0).isStartRefresh = false
end sub

sub onFocusedChild()
    if m.top.hasFocus()
        m.rowList.setFocus(true)
    end if
end sub