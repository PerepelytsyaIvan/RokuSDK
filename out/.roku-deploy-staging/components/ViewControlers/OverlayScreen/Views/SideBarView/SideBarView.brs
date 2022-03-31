sub init()
    m.networkLayerManager = CreateObject("roSGNode", "NetworkLayerManager")
    m.menuItems = m.top.findNode("menuItems")
    m.animationMenu = m.top.findNode("animationMenu")
    m.interpolatorMenu = m.top.findNode("interpolatorMenu")
    m.sectionAnimation = m.top.findNode("sectionAnimation")
    m.interpolatorSection = m.top.findNode("interpolatorSection")
    m.menuItems.observeField("rowItemSelected", "onItemSelected")
    m.networkLayerManager.observeField("productsResponce", "onResponceProducts")
    m.sectionAnimation.addField("isShow", "bool", false)
    m.isOpenMenu = false
    m.showSection = false
    m.timer = configureTimer(3, false)
    m.timer.observeField("fire", "showingMenu")
end sub

sub configureDataSource()
    m.menuItems.translation = [getSize(-30), getSize(800)]
    infoItems = getItemsForMenu()
    titles = ["", m.global.localization.sideMenuAccount, m.global.localization.sideMenuLeaderboard, m.global.localization.sideMenuPredictions, m.global.localization.sideMenuShop]
    subTypes = ["openAndClose", "account", "leaderboard", "prediction", "shop"]
    contentNode = CreateObject("roSGNode", "ContentNode")
    rowContent = contentNode.createChild("ContentNode")
    count = 0
    for each image in infoItems.images
        itemContent = rowContent.createChild("ContentNode")
        itemContent.addField("image", "string", false)
        itemContent.image = "pkg:/images/" + image + ".png"
        itemContent.title = titles[count]
        itemContent.addField("subType", "string", false)
        itemContent.subType = infoItems.subTypes[count]
        count++
    end for
    m.menuItems.isOpenMenu = false
    m.menuItems.content = contentNode
end sub

sub getItemsForMenu() as object
    arrayMenuKey = ["account_menu", "leaderboard_menu", "predictions_menu", "shop_menu"]
    imageNames = ["dotsSideBar", "account", "leaderboard", "prediction", "shop"]
    subTypes = ["openAndClose", "account", "leaderboard", "prediction", "shop"]

    count = 0
    for each key in arrayMenuKey
        count ++
        if not m.global.infoApp.modules[key]
            imageNames.Delete(count)
            subTypes.Delete(count)
        end if
    end for

    return { "images": imageNames, "subTypes": subTypes }
end sub

sub onItemSelected(event)
    indexPath = event.getData()
    item = m.menuItems.content.getChild(indexPath[0]).getChild(indexPath[1])

    if item.subType = "openAndClose"
        showingMenu()
    else if item.subType = "account"
        showingMenu()
        createAccountMenu()
        m.top.isActiveMenu = true
    else if item.subType = "leaderboard"
        showingMenu()
        createLeaderboard()
        m.top.isActiveMenu = true
    else if item.subType = "prediction"
        showingMenu()
        createPrediction()
        m.top.isActiveMenu = true
    else if item.subType = "shop"
        showingMenu()
        m.top.isActiveMenu = true
        param = m.top.accountRoute
        param.categoryId = "5f96f69f0fd54f71755c8c2e"
        m.networkLayerManager.callFunc("getProducts", getProductUrl(), param)
    end if
end sub

sub showingMenu()
    m.isOpenMenu = not m.isOpenMenu
    m.menuItems.isOpenMenu = m.isOpenMenu
    if m.isOpenMenu
        m.menuItems.content.getChild(0).getChild(0).image = "pkg:/images/closeSideBar.png"
        showMenu()
    else
        m.menuItems.content.getChild(0).getChild(0).image = "pkg:/images/dotsSideBar.png"
        hideMenu()
    end if
end sub

sub openMenu(event)
    isOpen = event.getData()

    if not isOpen then return

    if not m.isOpenMenu 
        showingMenu()
        m.top.focusKey = 0
    else
        m.top.focusKey = 0
    end if
end sub

sub showMenu()
    m.interpolatorMenu.keyValue = [[80, 110], [380, 110]]
    m.animationMenu.control = "start"
end sub

sub hideMenu()
    m.menuItems.jumpToRowItem = [0,0]
    m.interpolatorMenu.keyValue = [[380, 110], [80, 110]]
    m.animationMenu.control = "start"
end sub

sub onResponceProducts(event)
    products = event.getData()
    if isValid(m.shopMenu) then m.top.removeChild(m.shopMenu)
    m.interpolatorSection.fieldToInterp = ""
    m.shopMenu = m.top.createChild("ShopMenu")
    m.shopMenu.id = "shopMenu"
    m.shopMenu.dataSource = products
    m.shopMenu.translation = [m.shopMenu.boundingRect().width + m.shopMenu.boundingRect().x, 0]
    m.interpolatorSection.fieldToInterp = m.shopMenu.id + ".translation"
    m.interpolatorSection.keyValue = [m.shopMenu.translation, [0,0]]
    m.sectionAnimation.control = "start"
    m.sectionAnimation.isShow = true
    m.top.focusKey = 4
    m.shopMenu.observeField("selectedItem", "onSelectedItemShop")
    m.shopMenu.observeField("setParentFocus", "setMenuFocus")
end sub

sub onSelectedItemShop(event)
    m.top.shopItem = event.getData()
end sub

sub createAccountMenu()
    if isValid(m.accountMenu) then m.top.removeChild(m.accountMenu)
    m.interpolatorSection.fieldToInterp = ""
    m.accountMenu = m.top.createChild("AccountMenu")
    m.accountMenu.id = "accountMenu"
    m.accountMenu.accountRoute = m.top.accountRoute
    m.accountMenu.translation = [m.accountMenu.boundingRect().width + m.accountMenu.boundingRect().x, 0]
    m.interpolatorSection.fieldToInterp = m.accountMenu.id + ".translation"
    m.interpolatorSection.keyValue = [m.accountMenu.translation, [0,0]]
    m.sectionAnimation.control = "start"
    m.sectionAnimation.isShow = true
    m.top.focusKey = 3
    m.accountMenu.observeField("setParentFocus", "setMenuFocus")
end sub

sub createLeaderboard()
    if isValid(m.leaderBoard) then m.top.removeChild(m.leaderBoard)
    m.interpolatorSection.fieldToInterp = ""
    m.leaderBoard = m.top.createChild("LeaderBoard")
    m.leaderBoard.id = "LeaderBoard"
    m.leaderBoard.accountRoute = m.top.accountRoute
    m.leaderBoard.translation = [m.leaderBoard.boundingRect().width + m.leaderBoard.boundingRect().x, 0]
    m.leaderBoard.observeField("setParentFocus", "setMenuFocus")
    m.interpolatorSection.fieldToInterp = m.leaderBoard.id + ".translation"
    m.interpolatorSection.keyValue = [m.leaderBoard.translation, [0,0]]
    m.sectionAnimation.control = "start"
    m.sectionAnimation.isShow = true
    m.top.focusKey = 2
end sub

sub createPrediction()
    if isValid(m.predictionView) then m.top.removeChild(m.predictionView)
    m.interpolatorSection.fieldToInterp = ""
    m.predictionView = m.top.createChild("PredictionView")
    m.predictionView.id = "PredictionView"
    m.predictionView.accountRoute = m.top.accountRoute
    m.predictionView.dataSource = m.global.userData
    m.predictionView.translation = [m.predictionView.boundingRect().width + m.predictionView.boundingRect().x, 0]
    m.interpolatorSection.fieldToInterp = m.predictionView.id + ".translation"
    m.interpolatorSection.keyValue = [m.predictionView.translation, [0,0]]
    m.sectionAnimation.control = "start"
    m.sectionAnimation.isShow = true
    m.top.focusKey = 1
    m.predictionView.observeField("setParentFocus", "setMenuFocus")
end sub

sub hideAndRemoveSection()
    m.top.isActiveMenu = false
    m.interpolatorSection.keyValue = [m.interpolatorSection.keyValue[1], ]
    m.sectionAnimation.control = "start"
    m.showSection = true
    m.sectionAnimation.isShow = false
end sub

sub setMenuFocus()
    m.top.focusedActivity = true
end sub

sub updateFocus(event)
    key = event.getData()

    if key = 0
        m.menuItems.setFocus(true)
    else if key = 1
        m.predictionView.setFocus(true)
    else if key = 2
        m.leaderBoard.setFocus(true)
    else if key = 3
        m.accountMenu.setFocus(true)
    else if key = 4
        m.shopMenu.setFocus(true)
    end if
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    result = false
    if not press then return result

    if key = "OK"
        result = true
    else if key = "back"
        m.sectionAnimation.isShow = false
        m.interpolatorSection.keyValue = [m.interpolatorSection.keyValue[1], m.interpolatorSection.keyValue[0]]
        m.sectionAnimation.control = "start"
        m.top.focusedActivity = true
        result = true
    end if
    
    return result
end function