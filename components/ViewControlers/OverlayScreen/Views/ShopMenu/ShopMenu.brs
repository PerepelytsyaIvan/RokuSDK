sub init()
    m.background = m.top.findNode("background")
    m.productGroup = m.top.findNode("productGroup")
    m.subTitle = m.top.findNode("subTitle")
    m.title = m.top.findNode("title")
    m.productList = m.top.findNode("productList")
    m.separator = m.top.findNode("separator")
    configureDesign()
    
    m.productList.observeField("itemSelected", "onItemSelected")
    m.top.observeField("focusedChild", "onFocusedChild")
end sub

sub configureDataSource()
    dataSource = m.top.dataSource
    m.subTitle.text = m.global.localization.sideMenuMy
    m.title.text = m.global.localization.sideMenuShop

    contentNode = CreateObject("roSGNode", "ContentNode")
    for each item in dataSource
        rowContent = contentNode.createChild("ContentNode")
        itemContent = rowContent.createChild("ContentNode")
        itemContent.addField("item", "assocarray", false)
        itemContent.item = item
    end for

    m.productList.content = contentNode
    m.productList.setFocus(true)
    layoutSubviews()
end sub

sub onItemSelected(event)
    index = event.getData()
    item = m.top.dataSource[index]
    m.top.selectedItem = item
end sub

sub configureDesign()
    m.subTitle.font = getMediumFont(getSize(30))
    m.title.font = getMediumFont(getSize(30))
    m.title.color = m.global.design.questionTextColor
    m.subTitle.color = m.global.design.buttonBackgroundColor
    m.background.color = "#000000"
end sub

sub onFocusedChild()
    if m.top.hasFocus()
        m.productList.setFocus(true)
    end if
end sub

sub layoutSubviews()
    m.productList.itemSize = [getSize(340), getSize(100)]
    m.productList.rowItemSize = [[getSize(340), getSize(100)]]
    m.productList.itemSpacing = [getSize(0),getSize(10)]
    m.productList.rowItemSpacing = [[0, getSize(10)]]
    m.background.width = getSize(405)
    m.background.height = getSize(1080)
    m.background.translation = [(getSize(1920) - getSize(400)), 0]
    m.productGroup.translation = [(getSize(1920) - getSize(400)) + (getSize(400) / 2), 0]
    m.separator.width = getSize(340)
    m.separator.height = getSize(1)
    m.productList.translation = [(getSize(1920) - getSize(400)) + getSize(30), 110]
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    result = false
    if not press then return result
    return result
end function