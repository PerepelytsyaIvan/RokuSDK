sub init()
    m.networkLayerManager = CreateObject("roSGNode", "NetworkLayerManager")
    initView()
    configureDesign()
end sub

sub setupAnimation()
    if m.interpolator.keyValue[0][0] = 320 then return
    m.interpolator.keyValue = [[320, 40], [320, 60]]
    m.hidingInterpolator.keyValue = [1, 0]
    m.interpolatorGroup.keyValue = [m.buttonsGroup.translation, [m.buttonsGroup.translation[0], m.buttonsGroup.translation[1] + 30]]
    m.animation.control = "start"
end sub

sub configureDataSource()
    m.collectionView.dataSource = getDataForKeyboard()
    m.collectionView.SetFocus(true)
    getContentNodeForNumberList()
    configureContentNode(false)
    m.infoReciveSms.text = m.global.localization.personalAreaEnterNumberToGetSms
    m.discountLabel.text = m.global.localization.personalAreaPriceDiscount.replace("{{ percent }}", "")
    m.switch.title = m.global.localization.personalAreaSaveNumberDevice

    m.QRCodePoster.uri = getImageWithName(m.top.dataSource.qrcodeimage)
    m.productPoster.uri = getImageWithName(m.top.dataSource.image)
    m.productNameLabel.text = m.top.dataSource.name
    m.productDescriptionLabel.text = m.top.dataSource.description
    m.discountPercentLabel.text = m.top.dataSource.discount.toStr() + "%"
    m.totalPriceLabel.text = m.top.dataSource.price + " " + m.top.dataSource.currency
    m.aboutPurchaseLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore"
    m.noSearchResultLabel.text = "No search results"
    layoutSubview() 
    m.top.focusKey = 1
end sub

sub didSelectOnKeyboard(event)
    item = event.getData()

    if isInvalid(m.codeButtonList.content.getChild(0).getChild(0).item.selected)
        itemCode = m.codeButtonList.content.getChild(0).getChild(0).item
        itemCode.selected = false
        m.codeButtonList.content.getChild(0).getChild(0).item = itemCode
    end if

    if m.codeButtonList.content.getChild(0).getChild(0).item.selected
        editingCountryCode(item.title)
    else
        editingNumber(item.title)
    end if
end sub

sub didSelectButton(event)
    itemSelected = event.getData()

    if m.rowList.content.getChildCount() = 1 
        sendSms()
    else
        if itemSelected = 0
            sendSms()
        else
            if m.errorLabel.text = ""
                number = m.codeButtonList.content.getChild(0).getChild(0).item.code + m.numberView.content.getChild(0).getChild(0).item.code
                RegWrite("number", number)
                RegWrite("isOn", m.switch.isOn.toStr())
            end if
            m.top.pressBackButton = true
        end if
    end if
end sub

sub didSelectNumberCode()
    activateNumberBox(false)
    m.isShowMenuCode = not m.isShowMenuCode
    item = m.codeButtonList.content.getChild(0).getChild(0).item
    if m.isShowMenuCode
        showNumberList()
        item.selected = true
    else
        item.selected = false
        hideNumberList()
    end if
    m.codeButtonList.content.getChild(0).getChild(0).item = item
end sub

sub didSelectRow(event)
    index = event.getData()

    if index[0] = 0
        sendSms()
    else
        m.top.pressBackButton = true
    end if
end sub

sub didSelectNumberView()
    activateCodeBox(false)
    hideNumberList()
    m.top.focusKey = 0
    item = m.numberView.content.getChild(0).getChild(0).item
    item.selected = true
    m.numberView.content.getChild(0).getChild(0).item = item
end sub

sub didSelectNumberList(event)
    indexPath = event.getData()
    newCode = m.numberList.content.getChild(indexPath[0]).getChild(indexPath[1]).item.code
    m.codeButtonList.content.getChild(0).getChild(0).item = {"country": "", "code": "+" + newCode}
    m.isShowMenuCode = false
    m.top.focusKey = 1
    hideNumberList()
end sub

sub changeFocusedNumberList(event)
    index = event.getData()
    if m.numberList.content.getChildCount() = 0 then return
    countItems = m.numberList.content.getChildCount() - 1
    if countItems = 0 then return
    percent = (index / countItems)
    m.indicatorView.percent = percent
end sub

sub sendSms()
    showLoadingIndicator(true)
    if m.isShowMenuCode then hideNumberList()
    m.isShowMenuCode = false
    number = m.codeButtonList.content.getChild(0).getChild(0).item.code + m.numberView.content.getChild(0).getChild(0).item.code
    m.networkLayerManager.callFunc("buyProduct", buyItemUrl(), {"productId": m.top.dataSource.idEvent, "userPhoneNum": number, "broadcasterName": m.top.accountRoute.broadcasterName})
    m.networkLayerManager.observeField("buyItem", "responceSendSMS")
end sub

sub responceSendSMS(event)
    data = event.getData()

    showLoadingIndicator(false)
    if data.status = "success"
        m.errorLabel.text = ""
        m.infoLabel.text = m.global.localization.personalAreaSmsNotReceived
        configureContentNode(true)
        showAnimationButton()
        m.top.focusKey = 4
        if m.switch.isOn
            number = m.codeButtonList.content.getChild(0).getChild(0).item.code + m.numberView.content.getChild(0).getChild(0).item.code
            RegWrite("number", number)
            RegWrite("isOn", m.switch.isOn.toStr())
        end if
    else
        m.top.focusKey = 4
        error = ParseJson(data.error)
        m.errorLabel.text = error.message
        m.switch.isOn = false
        RegDelete("SMS")
        RegDelete("isOn")
    end if
end sub

sub updateFocus(key)
    m.switch.focus = false
    item = m.numberView.content.getChild(0).getChild(0).item
    item.selected = false
    m.numberView.content.getChild(0).getChild(0).item = item
    if m.top.focusKey = 0
        m.collectionView.setFocus(true)
    else if m.top.focusKey = 1
        m.codeButtonList.setFocus(true)
    else if m.top.focusKey = 2
        m.numberList.setFocus(true)
    else if m.top.focusKey = 3
        m.switch.focus = true
        m.switch.setFocus(true)
    else if m.top.focusKey = 4
        m.rowList.setFocus(true)
    else if m.top.focusKey = 5
        m.numberView.setFocus(true)
    end if
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    result = true
    if not press then return true

    if key = "right" and m.top.focusKey = 0
        m.top.focusKey = 1
        result = true
    else if key = "right" and m.top.focusKey = 1
        m.top.focusKey = 5
        result = true
    else if key = "left" and m.top.focusKey = 1 or key = "left" and m.top.focusKey = 2
        m.top.focusKey = 0
        result = true
    else if key = "left" and m.top.focusKey = 5
        m.top.focusKey = 1
        result = true
    else if key = "down" and m.top.focusKey = 1
        if m.isShowMenuCode then m.top.focusKey = 2
        if m.numberList.content.getChildCount() = 0 then m.top.focusKey = 3
        if not m.isShowMenuCode then m.top.focusKey = 3
        result = true
    else if key = "down" and m.top.focusKey = 2
        m.top.focusKey = 3
        result = true
    else if key = "down" and m.top.focusKey = 3
        m.top.focusKey = 4
        result = true
    else if key = "down" and m.top.focusKey = 5
        if m.isShowMenuCode then m.top.focusKey = 2
        if m.numberList.content.getChildCount() = 0 then m.top.focusKey = 3
        if not m.isShowMenuCode then m.top.focusKey = 3
        result = true
    else if key = "up" and m.top.focusKey = 2
        m.top.focusKey = 1
        result = true
    else if key = "up" and m.top.focusKey = 3
        if m.isShowMenuCode then m.top.focusKey = 2
        if m.numberList.content.getChildCount() = 0 then m.top.focusKey = 1
        if not m.isShowMenuCode then m.top.focusKey = 1
        result = true
    else if key = "up" and m.top.focusKey = 4
        m.top.focusKey = 3
    else if key = "back"
        m.top.pressBackButton = true
        result = true
    end if
    return result
end function

sub layoutSubview()
    m.keyboardLayout.translation = [60 + m.keyboardLayout.boundingRect().width / 2, 45]
    m.containerView.translation = [(getScreenWidth() - m.background.width) / 2, (getScreenHeight() - m.background.height) / 2]
    m.separatorPoster.translation = [m.QRCodePoster.width + m.QRCodePoster.translation[0] + m.keyboardLayout.translation[0] + 60, (m.background.height - m.separatorPoster.height) / 2]
    m.centralViewsContainer.translation = [m.separatorPoster.translation[0] + 40, 200]
    m.rightBackground.width = 315
    m.rightBackground.height = m.background.height
    m.rightViewsGroup.translation = [m.background.width - m.rightBackground.width, 0]
    m.descriptionProductLayout.translation = [m.rightBackground.width / 2, 20]
    m.rightViewsLayout.translation = [m.rightBackground.width / 2, m.rightBackground.height - m.rightViewsLayout.boundingRect().height - 30]
    m.codeButtonList.translation = [m.infoReciveSms.translation[0], m.infoReciveSms.translation[1] + m.infoReciveSms.height + 10] 
    m.numberList.translation = [m.infoReciveSms.translation[0], (m.codeButtonList.translation[1] + m.codeButtonList.itemSize[1] + 10) - m.numberList.boundingRect().height] 
    m.maskNumberList.translation = m.numberList.translation
    m.maskNumberList.height = m.numberList.boundingRect().height
    m.maskNumberList.width = m.numberList.boundingRect().width
    m.bottomGroup.translation = [m.numberList.translation[0], m.numberList.translation[1] + m.maskNumberList.height + 20]
    m.numberView.translation = [m.codeButtonList.translation[0] + m.codeButtonList.boundingRect().width - 30, m.codeButtonList.translation[1]]
    m.rowList.translation = [0, m.switch.translation[1] + m.switch.height + 90]
    m.indicatorView.height = m.numberList.boundingRect().height - 45
    m.indicatorView.translation = [m.numberList.boundingRect().width - 30, m.numberList.translation[1]]
    m.maskButton.translation = [m.rowList.translation[0], m.rowList.translation[1] + m.rowList.boundingRect().height / 2 + 5]
    m.errorLabel.translation = [m.numberList.translation[0], m.codeButtonList.translation[1] + m.codeButtonList.boundingRect().height - 30]
    m.infoLabel.translation = [m.switch.translation[0], m.rowList.translation[1] - 35]
    m.noSearchResultLabel.translation = [m.codeButtonList.translation[0], m.codeButtonList.translation[1] + 50]
end sub

function showLoadingIndicator(show)
    m.loadingIndicator.visible = show
    m.loadingIndicator.SetFocus(show)
    if show
        m.loadingIndicator.control = "start"
    else
        m.loadingIndicator.bEatKeyEvents = false
        m.loadingIndicator.control = "stop"
    end if
end function
