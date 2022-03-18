sub init()
    m.networkLayerManager = CreateObject("roSGNode", "NetworkLayerManager")

    m.menuItems = m.top.findNode("menuItems")
    m.animationMenu = m.top.findNode("animationMenu")
    m.interpolatorMenu = m.top.findNode("interpolatorMenu")
    m.sectionAnimation = m.top.findNode("sectionAnimation")
    m.interpolatorSection = m.top.findNode("interpolatorSection")
    m.menuItems.observeField("rowItemSelected", "onItemSelected")
    m.sectionAnimation.observeField("state", "changeStateAnimation")
    m.top.observeField("focusedChild", "onFocusedChild")
    m.networkLayerManager.observeField("leadersResponce", "onResponceLeaders")
    m.networkLayerManager.observeField("productsResponce", "onResponceProducts")
    m.sectionAnimation.addField("isShow", "bool", false)
    configureDataSource()
    m.isOpenMenu = false
end sub

sub configureDataSource()
    m.menuItems.translation = [getSize(-30), getSize(800)]
    imageNames = ["dotsSideBar", "account", "leaderboard", "prediction", "shop"]
    contentNode = CreateObject("roSGNode", "ContentNode")
    rowContent = contentNode.createChild("ContentNode")

    for each image in imageNames
        itemContent = rowContent.createChild("ContentNode")
        itemContent.addField("image", "string", false)
        itemContent.image = "pkg:/images/" + image + ".png"
    end for
    m.menuItems.isOpenMenu = false
    m.menuItems.content = contentNode
end sub

sub onItemSelected(event)
    indexPath = event.getData()

    if indexPath[1] = 0
        m.isOpenMenu = not m.isOpenMenu
        m.menuItems.isOpenMenu = m.isOpenMenu
        if m.isOpenMenu
            m.menuItems.content.getChild(0).getChild(0).image = "pkg:/images/closeSideBar.png"
            showMenu()
        else
            m.menuItems.content.getChild(0).getChild(0).image = "pkg:/images/dotsSideBar.png"
            hideMenu()
        end if
    else if indexPath[1] = 1
        createAccountMenu()
    else if indexPath[1] = 2
        m.networkLayerManager.callFunc("getLeaders", getLeadersUrl(), m.top.accountRoute)
    else if indexPath[1] = 3

    else if indexPath[1] = 4
        param = m.top.accountRoute
        param.categoryId = "5f96f69f0fd54f71755c8c2e"
        m.networkLayerManager.callFunc("getProducts", getProductUrl(), param)
    end if
end sub

sub showMenu()
    m.interpolatorMenu.keyValue = [[80, 60], [380, 60]]
    m.animationMenu.control = "start"
end sub

sub hideMenu()
    m.interpolatorMenu.keyValue = [[380, 60], [80, 60]]
    m.animationMenu.control = "start"
end sub

sub onResponceLeaders(event)
    data = event.getData()
    ? data
end sub

sub onResponceProducts(event)
    products = event.getData()
    m.shopMenu = m.top.createChild("ShopMenu")
    m.shopMenu.id = "shopMenu"
    m.shopMenu.dataSource = products
    m.shopMenu.translation = [m.shopMenu.boundingRect().width + m.shopMenu.boundingRect().x, 0]
    m.interpolatorSection.fieldToInterp = m.shopMenu.id + ".translation"
    m.interpolatorSection.keyValue = [m.shopMenu.translation, [0,0]]
    m.sectionAnimation.control = "start"
    m.sectionAnimation.isShow = true
    m.shopMenu.setFocus(true)
end sub

sub createAccountMenu()
    m.accountMenu = m.top.createChild("AccountMenu")
    m.accountMenu.id = "accountMenu"
    m.accountMenu.accountRoute = m.top.accountRoute
    m.accountMenu.translation = [m.accountMenu.boundingRect().width + m.accountMenu.boundingRect().x, 0]
    m.interpolatorSection.fieldToInterp = m.accountMenu.id + ".translation"
    m.interpolatorSection.keyValue = [m.accountMenu.translation, [0,0]]
    m.sectionAnimation.control = "start"
    m.sectionAnimation.isShow = true
    m.accountMenu.setFocus(true)
end sub

sub changeStateAnimation(event)
    state = event.getData()

    if not  m.sectionAnimation.isShow and state = "stopped"
        child = m.top.getChild(m.top.getChildCount() - 1)
        m.top.removeChild(child)
    end if
end sub

sub onFocusedChild()
    if m.top.hasFocus()
        m.menuItems.setFocus(true)
    end if
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    result = false
    ? "onKeyEvent("key" as string, "press" as boolean)"
    if not press then return result

    if key = "OK"
        result = true
    else if key = "back"
        m.sectionAnimation.isShow = false
        m.interpolatorSection.keyValue = [m.interpolatorSection.keyValue[1], m.interpolatorSection.keyValue[0]]
        m.sectionAnimation.control = "start"
        m.menuItems.setFocus(true)
        result = true
    end if
    return result
end function