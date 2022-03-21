sub init()
    m.networkLayerManager = CreateObject("roSGNode", "NetworkLayerManager")

    m.loadingIndicator = m.top.findNode("loadingProgress")
    m.QRCodePoster = m.top.findNode("QRCodePoster")
    m.containerView = m.top.findNode("containerView")
    m.background = m.top.findNode("background")
    m.collectionView = m.top.findNode("collectionView")
    m.separatorPoster = m.top.findNode("separatorPoster")
    m.keyboardLayout = m.top.findNode("keyboardLayout")
    m.centralViewsLayout = m.top.findNode("centralViewsLayout")
    m.infoReciveSms = m.top.findNode("infoReciveSms")
    m.interactiveLabel = m.top.findNode("interactiveLabel")
    m.interactiveLabelBackground = m.top.findNode("interactiveLabelBackground")
    m.toggle = m.top.findNode("toggle")
    m.rowList = m.top.findNode("rowList")

    m.disableServiceLabel = m.top.findNode("disableServiceLabel")
    m.saveInfoLabel = m.top.findNode("saveInfoLabel")
    m.rightViewsGroup = m.top.findNode("rightViewsGroup")

    m.collectionView.observeField("item", "didSelectOnKeyboard")

    m.rightBackground = m.top.findNode("rightBackground")
    m.rightViewsLayout = m.top.findNode("rightViewsLayout")

    m.productPoster = m.top.findNode("productPoster")
    m.productNameLabel = m.top.findNode("productNameLabel")
    m.productDescriptionLabel = m.top.findNode("productDescriptionLabel")
    m.discountLabel = m.top.findNode("discountLabel")
    m.discountPercentLabel = m.top.findNode("discountPercentLabel")
    m.totalPriceLabel = m.top.findNode("totalPriceLabel")
    m.aboutPurchaseLabel = m.top.findNode("aboutPurchaseLabel")

    m.animation = m.top.findNode("animation")
    m.hidingInterpolator = m.top.findNode("hidingInterpolator")
    m.interpolatorGroup = m.top.findNode("interpolatorGroup")
    m.interpolator = m.top.findNode("interpolator")
    m.errorLabel = m.top.findNode("errorLabel")
    m.infoLabel = m.top.findNode("infoLabel")
    m.buttonsGroup = m.top.findNode("buttonsGroup")
    m.rowList.observeField("itemSelected", "didSelectButton")
    configureDesign()
end sub

sub setupAnimation()
    if m.interpolator.keyValue[0][0] = 320 then return
    m.interpolator.keyValue = [[320, 40], [320, 60]]
    m.hidingInterpolator.keyValue = [1, 0]
    m.interpolatorGroup.keyValue = [m.buttonsGroup.translation, [m.buttonsGroup.translation[0], m.buttonsGroup.translation[1] + 30]]
    m.animation.control = "start"
end sub

sub configureDesign()
    m.interactiveLabel.font = getRegularFont(23)
    m.infoReciveSms.font = getRegularFont(20)
    m.saveInfoLabel.font = getRegularFont(20)
    m.disableServiceLabel.font = getRegularFont(20)
    m.productNameLabel.font = getBoldFont(20)
    m.productDescriptionLabel.font = getRegularFont(20)
    m.discountLabel.font = getRegularFont(16)
    m.discountPercentLabel.font = getBoldFont(20)
    m.totalPriceLabel.font = getBoldFont(26)
    m.aboutPurchaseLabel.font = getRegularFont(16)
    m.errorLabel.font = getRegularFont(15)
    m.infoLabel.font = getMediumFont(18)
    m.toggle.scaleRotateCenter = [m.toggle.boundingRect().width / 2, m.toggle.boundingRect().height / 2]
    m.errorLabel.color = m.global.design.wrongAnswerTextColor
end sub

sub configureDataSource()
    configureContentNode(false)
    m.infoReciveSms.text = "To receive an SMS link. to continue the purchase, scan the code or enter vour mobile number"
    m.saveInfoLabel.text = "Save number on this device"
    m.QRCodePoster.uri = getImageWithName(m.top.dataSource.qrcodeimage)
    m.disableServiceLabel.text = "If you`d like to disable this service, please go to Cellcom settings > Cellcom Play > Disable"
    m.productPoster.uri = getImageWithName(m.top.dataSource.image)
    m.productNameLabel.text = m.top.dataSource.name
    m.productDescriptionLabel.text = m.top.dataSource.description
    m.discountLabel.text = "discount of price"
    m.discountPercentLabel.text = m.top.dataSource.discount.toStr() + "%"
    m.totalPriceLabel.text = m.top.dataSource.price + " " + m.top.dataSource.currency

    m.aboutPurchaseLabel.text = "This is preliminary information only. The full and binding details will be displayed at the time of purchase"

    m.collectionView.dataSource = getDataForKeyboard()
    m.collectionView.setFocus(true)
    m.savedNumberForSMS = RegRead("SMS")
    if m.savedNumberForSMS <> invalid
        m.interactiveLabel.text = m.savedNumberForSMS
    else
        m.interactiveLabel.text = ""
    end if
    layoutSubview()
end sub

sub configureContentNode(withExitButton)
    if withExitButton
        array = ["Send me sms again", "Exit"]
    else
        array = ["Send me sms"]
    end if
    rowItemSize = []
    contentNode = CreateObject("roSGNode", "ContentNode")
    for each item in array
        rowNode = contentNode.createChild("ContentNode")
        elementNode = rowNode.createChild("ContentNode")
        elementNode.title = item
        rowItemSize.Push([getWidthForText(item, getBoldFont(getSize(30))) + 40, 40])
    end for
    
    m.rowList.rowItemSize = rowItemSize
    m.rowList.content = contentNode
    m.rowList.setFocus(true)
end sub

sub didSelectOnKeyboard(event)
    item = event.getData()
    if item.title = "Clear"
        m.interactiveLabel.text = ""
        RegDelete("SMS")
    else if item.title = ""
        m.interactiveLabel.text = Left(m.interactiveLabel.text, m.interactiveLabel.text.len() - 1)
        a = Left(m.savedNumberForSMS, m.interactiveLabel.text.len() - 1)
        RegWrite("SMS", m.interactiveLabel.text)
    else
        if m.interactiveLabel.text.len() < 15
            m.interactiveLabel.text += item.title
            RegWrite("SMS", m.interactiveLabel.text)
        end if
    end if
end sub

sub getDataForKeyboard() as object
    dataSource = [
        { "title": "1", "image": "", width: 40, height: 40, itemComponent: "KeyboardItem" }
        { "title": "2", "image": "", width: 40, height: 40, itemComponent: "KeyboardItem" }
        { "title": "3", "image": "", width: 40, height: 40, itemComponent: "KeyboardItem" }
        { "title": "", "image": "pkg:/images/removeIcon.png", width: 40, height: 40, itemComponent: "KeyboardItem" }
        { "title": "4", "image": "", width: 40, height: 40, itemComponent: "KeyboardItem", newSection: true }
        { "title": "5", "image": "", width: 40, height: 40, itemComponent: "KeyboardItem" }
        { "title": "6", "image": "", width: 40, height: 40, itemComponent: "KeyboardItem" }
        { "title": "7", "image": "", width: 40, height: 40, itemComponent: "KeyboardItem", newSection: true }
        { "title": "8", "image": "", width: 40, height: 40, itemComponent: "KeyboardItem" }
        { "title": "9", "image": "", width: 40, height: 40, itemComponent: "KeyboardItem" }
        { "title": "Clear", "image": "", width: 70, height: 40, itemComponent: "KeyboardItem" }
        { "title": "0", "image": "", width: 135, height: 40, itemComponent: "KeyboardItem", newSection: true }
    ]
    return dataSource
end sub

sub didSelectButton(event)
    itemSelected = event.getData()

    if m.rowList.content.getChildCount() = 1 
        sendSms()
    else
        if itemSelected = 0
            sendSms()
        else
            m.top.pressBackButton = true
        end if
    end if
end sub

sub sendSms()
    showLoadingIndicator(true)
    m.networkLayerManager.callFunc("buyProduct", buyItemUrl(), {"productId": m.top.dataSource.idEvent, "userPhoneNum": m.interactiveLabel.text, "broadcasterName": m.top.accountRoute.broadcasterName})
    m.networkLayerManager.observeField("buyItem", "responceSendSMS")
end sub

sub responceSendSMS(event)
    data = event.getData()

    showLoadingIndicator(false)
    m.rowList.SetFocus(true)
    if data.status = "success"
        m.errorLabel.text = ""
        m.infoLabel.text = "SMS has just been sent. Haven't received it yet?"
        configureContentNode(true)
        m.rowList.setFocus(true)
        setupAnimation()
    else
        error = ParseJson(data.error)
        m.errorLabel.text = error.message
        RegDelete("SMS")
    end if
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    result = true
    if not press then return true
    if key = "left" and not m.collectionView.hasFocus()
        m.collectionView.setFocus(true)
        m.toggle.scale = [1.0, 1.0]
    else if key = "right"
        m.toggle.setFocus(true)
        m.toggle.scale = [1.1, 1.1]
    else if key = "OK"
        if m.toggle.hasFocus()
            if m.toggle.isOn = false
                m.toggle.isOn = true
            else
                m.toggle.isOn = false
            end if
        end if
    else if key = "up" and not m.toggle.hasFocus() and m.rowList.hasFocus()
        m.toggle.scale = [1.1, 1.1]
        m.toggle.setFocus(true)
    else if key = "down" and  not m.collectionView.hasFocus()
        m.toggle.scale = [1.0, 1.0]
        m.rowList.setFocus(true)
    else if key = "back"
        m.top.pressBackButton = true
        result = true
    end if
    return result
end function

sub layoutSubview()
    m.containerView.translation = [(getScreenWidth() - m.background.width) / 2, (getScreenHeight() - m.background.height) / 2]
    m.separatorPoster.translation = [m.QRCodePoster.width + m.QRCodePoster.translation[0] + m.keyboardLayout.translation[0] + 60, (m.background.height - m.separatorPoster.height) / 2]
    m.centralViewsLayout.translation = [m.separatorPoster.translation[0] + 40, 130]
    m.rightViewsGroup.translation = [m.infoReciveSms.width + m.centralViewsLayout.translation[0] + 50, 0]
    m.rightViewsLayout.translation = [(m.rightBackground.width / 2), 10]
    m.toggle.translation = [m.interactiveLabelBackground.width + m.interactiveLabelBackground.translation[0] + 30, m.interactiveLabelBackground.height + m.infoReciveSms.height + m.interactiveLabelBackground.translation[1] + 185]
    m.saveInfoLabel.translation = [m.toggle.translation[0] + 40, m.toggle.translation[1] + 5]
    m.buttonsGroup.translation = [m.toggle.translation[0], m.toggle.translation[1] + 30]
    m.rowList.translation = [0, 40]
    m.infoLabel.translation = [0, 0]
    m.aboutPurchaseLabel.translation = [20, m.rightBackground.height - 100]
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
