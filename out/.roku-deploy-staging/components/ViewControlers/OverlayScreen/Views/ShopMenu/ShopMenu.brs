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
    m.subTitle.font = getMediumFont(30)
    m.title.font = getMediumFont(30)
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
    m.background.width = getSize(400)
    m.background.height = getSize(1080)
    m.background.translation = [(getSize(1920) - getSize(400)), 0]
    m.productGroup.translation = [(getSize(1920) - getSize(400)) + (400 / 2), 0]
    m.separator.width = 340
    m.separator.height = 1
    m.productList.translation = [(getSize(1920) - getSize(400)) + 30, 110]
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    result = false

    if not press then return result

    return result
end function