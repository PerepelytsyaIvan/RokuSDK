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
    m.showSection = false
end sub

sub configureDataSource()
    m.menuItems.translation = [getSize(90), getSize(800)]
    infoItems = getItemsForMenu()
    contentNode = CreateObject("roSGNode", "ContentNode")
    rowContent = contentNode.createChild("ContentNode")
    count = 0
    for each item in infoItems
        itemContent = rowContent.createChild("ContentNode")
        itemContent.addField("image", "string", false)
        itemContent.image = "pkg:/images/" + item.imageNames + ".png"
        itemContent.title = item.title
        itemContent.addField("subType", "string", false)
        itemContent.addField("iconWidth", "integer", false)
        itemContent.addField("iconHeight", "integer", false)
        itemContent.iconWidth = item.iconWidth
        itemContent.iconHeight = item.iconHeight

        itemContent.subType = item.subTypes
        count++
    end for

    m.menuItems.itemSize = [getSize(80), getSize(740)]
    m.menuItems.rowItemSize = [[getSize(80), getSize(130)]]
    m.menuItems.rowItemSpacing = [[getSize(50), 0]]
    m.menuItems.content = contentNode
    m.isFullHideMenu = true
    showingMenu(false)
end sub

sub getItemsForMenu() as object
    arrayMenuKey = ["account_menu", "leaderboard_menu", "predictions_menu", "shop_menu", "chat_menu"]
    titles = [m.global.localization.sideMenuAccount, m.global.localization.sideMenuLeaderboard, m.global.localization.sideMenuPredictions, m.global.localization.sideMenuShop, m.global.localization.sideMenuChat]

    dictMenu = {
        "account_menu": { "subTypes": "account", "imageNames": "account", "title": m.global.localization.generalOverlayMenu, "iconWidth": 30, "iconHeight": 30 }
        "leaderboard_menu": { "subTypes": "leaderboard", "imageNames": "leaderboard", "title": m.global.localization.sideMenuLeaderboard, "iconWidth": 24, "iconHeight": 29 }
        "predictions_menu": { "subTypes": "prediction", "imageNames": "prediction", "title": m.global.localization.sideMenuPredictions, "iconWidth": 26, "iconHeight": 37 }
        "shop_menu": { "subTypes": "shop", "imageNames": "shop", "title": m.global.localization.sideMenuShop, "iconWidth": 25, "iconHeight": 33 }
        "chat_menu": { "subTypes": "chat", "imageNames": "chat", "title": m.global.localization.sideMenuChat, "iconWidth": 35, "iconHeight": 26 } }

    menuItem = []

    for each item in arrayMenuKey
        if m.global.infoApp.modules[item]
            menuItem.push(dictMenu[item])
        end if
    end for

    return menuItem
end sub

sub onItemSelected(event)
    indexPath = event.getData()
    item = m.menuItems.content.getChild(indexPath[0]).getChild(indexPath[1])
    m.isFullHideMenu = true

    if item.subType = "account"
        showingMenu(false)
        createAccountMenu()
        m.top.isActiveMenu = true
    else if item.subType = "leaderboard"
        createLeaderboard()
        showingMenu(false)
        m.top.isActiveMenu = true
    else if item.subType = "prediction"
        showingMenu(false)
        createPrediction()
        m.top.isActiveMenu = true
    else if item.subType = "shop"
        showingMenu(false)
        m.top.isActiveMenu = true
        param = m.top.accountRoute
        param.categoryId = "5f96f69f0fd54f71755c8c2e"
        m.networkLayerManager.callFunc("getProducts", getProductUrl(), param)
    else if item.subType = "chat"
        createChatView()
        showingMenu(false)
        m.top.isActiveMenu = true
    end if
end sub

sub showingMenu(open)
    m.isOpenMenu = open
    m.isFullOpenMenu = isValid(m.interpolatorMenu.keyValue[1]) and m.interpolatorMenu.keyValue[1][0] = 80

    if open
        m.top.isActiveMenu = true
        showMenu()
    else
        hideMenu()
    end if
end sub

sub openMenu(event)
    isOpen = event.getData()

    if not isOpen then return

    if not m.isOpenMenu
        if isValid(m.interpolatorMenu.keyValue[1]) then m.interpolatorMenu.keyValue[1][0] = 80
        m.isFullOpenMenu = true
        showingMenu(true)
        m.top.focusKey = 0
    else
        m.top.focusKey = 0
    end if
end sub

sub showMenu()
    m.interpolatorMenu.keyValue = [[m.menuItems.itemSize[0], 110], [750, 130]]
    m.menuItems.isOpenMenu = true
    m.animationMenu.control = "start"
end sub

sub hideMenu()
    m.menuItems.isOpenMenu = false
    m.top.focusedActivity = true
    m.menuItems.jumpToRowItem = [0, 0]
    m.interpolatorMenu.keyValue = [[m.menuItems.itemSize[0], 110], [0, 130]]
    m.top.isActiveMenu = false
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
    m.interpolatorSection.keyValue = [m.shopMenu.translation, [0, 0]]
    m.sectionAnimation.control = "start"
    m.sectionAnimation.isShow = true
    m.top.focusKey = 4
    m.shopMenu.observeField("selectedItem", "onSelectedItemShop")
    m.shopMenu.observeField("setParentFocus", "setMenuFocus")
end sub

sub onSelectedItemShop(event)
    m.top.shopItem = event.getData()
end sub

sub handleMenuWithActivity(event)
    isShow = event.getData()
    if isValid(m.chatView) then m.chatView.isShowActivity = isShow
end sub

sub createAccountMenu()
    if isValid(m.accountMenu) then m.top.removeChild(m.accountMenu)
    m.interpolatorSection.fieldToInterp = ""
    m.accountMenu = m.top.createChild("AccountMenu")
    m.accountMenu.id = "accountMenu"
    m.accountMenu.accountRoute = m.top.accountRoute
    m.accountMenu.translation = [m.accountMenu.boundingRect().width + m.accountMenu.boundingRect().x, 0]
    m.interpolatorSection.fieldToInterp = m.accountMenu.id + ".translation"
    m.interpolatorSection.keyValue = [m.accountMenu.translation, [0, 0]]
    m.sectionAnimation.control = "start"
    m.sectionAnimation.isShow = true
    m.top.focusKey = 3
    m.accountMenu.observeField("setParentFocus", "setMenuFocus")
end sub

sub createChatView()
    if isValid(m.chatView) then m.top.removeChild(m.chatView)
    m.interpolatorSection.fieldToInterp = ""
    m.chatView = m.top.createChild("ChatView")
    m.chatView.id = "chatView"
    m.chatView.accountRoute = m.top.accountRoute
    m.chatView.translation = [m.chatView.boundingRect().width + m.chatView.boundingRect().x, 0]
    m.interpolatorSection.fieldToInterp = m.chatView.id + ".translation"
    m.interpolatorSection.keyValue = [m.chatView.translation, [0, 0]]
    m.sectionAnimation.control = "start"
    m.sectionAnimation.isShow = true
    m.top.focusKey = 5
    m.chatView.isShowActivity = m.top.isShowActivity
    m.chatView.observeField("setParentFocus", "setMenuFocus")
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
    m.interpolatorSection.keyValue = [m.leaderBoard.translation, [0, 0]]
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
    m.interpolatorSection.keyValue = [m.predictionView.translation, [0, 0]]
    m.sectionAnimation.control = "start"
    m.sectionAnimation.isShow = true
    m.top.focusKey = 1
    m.predictionView.observeField("setParentFocus", "setMenuFocus")
end sub

sub hideAndRemoveSection()
    m.top.isActiveMenu = false
    m.interpolatorSection.keyValue = [m.interpolatorSection.keyValue[1],]
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
        if isValid(m.interpolatorMenu.keyValue[1]) and m.interpolatorMenu.keyValue[1][0] = 0
            if not m.top.isActiveMenu
                m.menuItems.jumpToRowItem = [0, 0]
            end if
            m.isFullOpenMenu = true
            showingMenu(true)
        end if
        m.menuItems.setFocus(true)
    else if key = 1
        m.predictionView.setFocus(true)
    else if key = 2
        m.leaderBoard.setFocus(true)
    else if key = 3
        m.accountMenu.setFocus(true)
    else if key = 4
        m.shopMenu.setFocus(true)
    else if key = 5
        m.chatView.setFocus(true)
    end if
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    result = false
    if not press then return result

    if key = "OK"
        result = true
    else if key = "back"
        if IsValid(m.isOpenMenu) and m.isOpenMenu
            m.top.isActiveMenu = false
            m.top.focusedActivity = true
            m.isFullHideMenu = true
            showingMenu(false)
        else
            m.top.isActiveMenu = false
            m.sectionAnimation.isShow = false
            m.interpolatorSection.keyValue = [m.interpolatorSection.keyValue[1], m.interpolatorSection.keyValue[0]]
            m.sectionAnimation.control = "start"
            m.top.focusedActivity = true
        end if
        result = true
    else if key = "down"
        if m.top.isShowActivity then return false
        if IsValid(m.isOpenMenu) and m.isOpenMenu or not m.sectionAnimation.isShow 
            m.isFullHideMenu = true
            showingMenu(false)
            result = true
        else if m.menuItems.getChildCount() = 0 and m.top.isShowActivity
            m.isFullHideMenu = true
            showingMenu(false)
            result = true
        end if
    end if

    return result
end function