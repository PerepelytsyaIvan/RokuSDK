sub init()
    initView()
    configureObservers()
    configureDesign()
    m.networkLayerManager = CreateObject("roSGNode", "NetworkLayerManager")

    m.hidingTimer = configureTimer(1, true)
    m.showActivityTimer = configureTimer(0.5, false)

    m.showActivityTimer.observeField("fire", "showActifityAfterTimer")
    m.hidingTimer.observeField("fire", "changeTime")
    m.translationInterpolator.addField("isShow", "boolean", false)
    m.timeForHideView = 0
end sub

sub configureDataSource()
    if m.translationInterpolator.isShow 
        hideActivity()
        m.showActivityTimer.control = "start"
        return
    end if
    m.questionLabel.text = m.top.dataSource.question
    m.discountLabel.text = ""
    if IsValid(m.top.dataSource.discount) and m.top.dataSource.discount > 0
        m.discountLabel.text = m.global.localization.personalAreaPriceDiscount.replace("{{ percent }}", m.top.dataSource.discount.toStr()) + "%"
    end if
    m.priceLabel.text = m.top.dataSource.price + m.top.dataSource.currency
    m.productImage.uri = getImageWithName(m.top.dataSource.image)
    m.collectionView.dataSource = [m.top.dataSource]

    dataSourceLeftButton = [{ "title": "Menu", "itemComponent": "TextItemComponent" }, { "title": m.global.localization.personalAreaClosePersonalArea, "itemComponent": "TextItemComponent" }]
    m.collectionViewLeftButton.dataSource = dataSourceLeftButton
    m.timeForHideView = m.top.dataSource.timeForHiding
    configureLabel(m.timeForHideView)
    m.top.focusKey = 0
    m.previusFocusedNode = m.collectionView
    layoutViews()
    showActivity()
end sub

sub showActivity()
    if m.translationInterpolator.isShow
        hideActivity()
        m.showActivityTimer.control = "start"
        return
    end if
    m.hidingTimer.control = "start"
    m.translationInterpolator.keyValue = [m.activityContainerGroup.translation, [m.activityContainerGroup.translation[0], m.activityContainerGroup.translation[1] - m.backgroundActivity.height]]
    m.translationInterpolator.isShow = true
    m.translationAnimation.control = "start"
    m.top.isShowActivity = true
end sub

sub hideActivity()
    m.translationInterpolator.keyValue = [m.activityContainerGroup.translation, [m.activityContainerGroup.translation[0], m.activityContainerGroup.translation[1] + m.backgroundActivity.height]]
    m.translationInterpolator.isShow = false
    m.translationAnimation.control = "start"
    m.top.isShowActivity = false
    m.top.didDisselectedFocus = true
end sub

sub showActifityAfterTimer()
    m.translationInterpolator.isShow = false
    m.showActivityTimer.control = "stop"
    configureDataSource()
end sub

sub changeTime()
    if m.timeForHideView > 0
        m.timeForHideView -= 1
        configureLabel(m.timeForHideView)
    else
        m.hidingTimer.control = "stop"
        hideActivity()
    end if
end sub

sub didSelectButtonLeft(event)
    item = event.getData()

    if item.title = m.global.localization.personalAreaClosePersonalArea
        hideActivity()
    else if item.title = "Menu"
        m.top.isOpenMenu = true
    end if
end sub

sub didSelectButton()
    ' number = RegRead("number")
    number = ""
    numberPhone = number

    if isValid(number) and number <> ""
        m.networkLayerManager.callFunc("buyProduct", buyItemUrl(), {"productId": m.top.dataSource.idEvent, "userPhoneNum": numberPhone, "broadcasterName": m.top.accountRoute.broadcasterName})
        m.networkLayerManager.observeField("buyItem", "responceSendSMS")
        m.collectionWithLabelGroup.itemSpacings = [5]
        m.numberLabel.font = getRegularFont(15)
        m.numberLabel.text = m.global.localization.personalAreaWillSendSms.Replace("{{ number }}", right(number, 3))
    else
        createPersonalArea(m.top.dataSource)
    end if
end sub

sub responceSendSMS(event)
    data = event.getData()
end sub

sub didSelectBackButton()
    hidingPersonalArea()
    m.top.videoPlayer.setFocus(true)
    m.previusFocusedNode = m.top.videoPlayer
end sub

sub onChangeFocusedChild(event)
    if m.top.hasFocus()
        if IsValid(m.previusFocusedNode) then m.previusFocusedNode.setFocus(true)
    end if
end sub

sub updateFocus()
    if m.top.focusKey = 0
        m.collectionView.setFocus(true)
    else if m.top.focusKey = 1
        m.collectionViewLeftButton.setFocus(true)
    end if
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    result = false

    if not press then return result

    if key = "left" and m.collectionViewLeftButton.hasFocus()
        m.top.focusKey = 0
        result = true
    else if key = "right" and m.collectionView.hasFocus()
        m.top.focusKey = 1
        result = true
    end if
    return result
end function