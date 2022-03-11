sub init()
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
    m.focusElement = m.top.findNode("focusElement")
    m.sendMeSMSLabel = m.top.findNode("sendMeSMSLabel")
    m.toggle = m.top.findNode("toggle")

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


    configureDesign()
end sub

sub configureDesign()
    m.containerView.translation = [(getScreenWidth() - m.background.width) / 2, (getScreenHeight() - m.background.height) / 2]
    m.separatorPoster.translation = [m.QRCodePoster.width + m.QRCodePoster.translation[0] + m.keyboardLayout.translation[0] + 60, (m.background.height - m.separatorPoster.height) / 2]
    m.centralViewsLayout.translation = [m.separatorPoster.translation[0] + 40, 130]
    m.rightViewsGroup.translation = [m.infoReciveSms.width + m.centralViewsLayout.translation[0] + 50, 0]
    m.rightViewsLayout.translation = [m.rightBackground.width / 2 - 130, 10]
    toggleRect = m.toggle.boundingRect()
    m.sendMeSMSLabel.translation = [m.interactiveLabelBackground.width + m.interactiveLabelBackground.translation[0] + 30, m.interactiveLabelBackground.height + m.infoReciveSms.height + m.interactiveLabelBackground.translation[1] + 200]
    m.toggle.translation = [m.sendMeSMSLabel.translation[0], toggleRect.height + m.sendMeSMSLabel.translation[1] + 50]
    m.saveInfoLabel.translation = [m.toggle.translation[0] + 40, m.toggle.translation[1] + 5]

    m.sendMeSMSLabel.font = getBoldFont(30)
    m.interactiveLabel.font = getRegularFont(23)
    m.infoReciveSms.font = getRegularFont(20)
    m.saveInfoLabel.font = getRegularFont(20)
    m.disableServiceLabel.font = getRegularFont(20)
    m.productNameLabel.font = getBoldFont(20)
    m.productDescriptionLabel.font = getRegularFont(20)
    m.discountLabel.font = getRegularFont(16)
    m.discountPercentLabel.font = getBoldFont(20)
    m.totalPriceLabel.font = getBoldFont(23)
    m.aboutPurchaseLabel.font = getRegularFont(16)
    m.toggle.scaleRotateCenter = [m.toggle.boundingRect().width / 2, m.toggle.boundingRect().height / 2]
    sendMeSMSLabelRect = m.sendMeSMSLabel.boundingRect()
    m.focusElement.width = sendMeSMSLabelRect.width + 50
    m.focusElement.height = sendMeSMSLabelRect.height
    m.focusElement.translation = [(sendMeSMSLabelRect.x + m.focusElement.width) / 2, sendMeSMSLabelRect.y]
end sub

sub configureDataSource()
    m.infoReciveSms.text = "To receive an SMS link. to continue the purchase, scan the code or enter vour mobile number"
    m.saveInfoLabel.text = "Save number on this device"
    m.sendMeSMSLabel.text = "Send me SMS"
    m.QRCodePoster.uri = getImageWithName(m.top.dataSource.qrcodeimage)
    m.disableServiceLabel.text = "If you`d like to disable this service, please go to Cellcom settings > Cellcom Play > Disable"
    m.productPoster.uri = getImageWithName(m.top.dataSource.image)
    m.productNameLabel.text = m.top.dataSource.name
    m.productDescriptionLabel.text = m.top.dataSource.description
    m.discountLabel.text = "discount of price"
    m.discountPercentLabel.text = "-50%"
    if m.top.dataSource.currency = "USD"
        m.totalPriceLabel.text = "$" + m.top.dataSource.price
    end if
    m.aboutPurchaseLabel.text = "This is preliminary information only. The full and binding details will be displayed at the time of purchase"

    m.collectionView.dataSource = getDataForKeyboard()
    m.collectionView.setFocus(true)
    m.savedNumberForSMS = RegRead("SMS")
    if m.savedNumberForSMS <> invalid
        m.interactiveLabel.text = m.savedNumberForSMS
    else
        m.interactiveLabel.text = ""
    end if
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

function onKeyEvent(key as string, press as boolean) as boolean
    result = true
    if not press then return true
    if key = "left" and not m.collectionView.hasFocus()
        m.collectionView.setFocus(true)
        m.toggle.scale = [1.0, 1.0]
        m.sendMeSMSLabel.scale = [1.0, 1.0]
        m.focusElement.opacity = 0
    else if key = "right" and not m.sendMeSMSLabel.hasFocus()
        m.sendMeSMSLabel.setFocus(true)
        ' m.sendMeSMSLabel.scale = [1.1, 1.1]

        m.focusElement.opacity = 1

    else if key = "OK"
        if m.toggle.hasFocus()
            if m.toggle.isOn = false
                m.toggle.isOn = true
            else
                m.toggle.isOn = false
            end if
        else if m.sendMeSMSLabel.hasFocus()
            m.sendMeSMSLabel.color = "#363636"
        end if
    else if key = "up" and m.toggle.hasFocus() and not m.collectionView.hasFocus()
        m.sendMeSMSLabel.setFocus(true)
        m.toggle.scale = [1.0, 1.0]
        m.saveInfoLabel.scale = [1.0, 1.0]
        ' m.sendMeSMSLabel.scale = [1.1, 1.1]
        m.focusElement.opacity = 1
    else if key = "down" and m.sendMeSMSLabel.hasFocus() and not m.collectionView.hasFocus()
        m.toggle.setFocus(true)
        ' m.sendMeSMSLabel.scale = [1.0, 1.0]
        ' m.saveInfoLabel.scale = [1.1, 1.1]
        m.toggle.scale = [1.1, 1.1]
        m.focusElement.opacity = 0
    else if key = "back"
        m.top.pressBackButton = true
        result = true
    end if
    return result
end function




sub onChangePercentFocus()
    if m.top.percentFocus > 0.2
        m.focusElement.opacity = m.top.percentFocus
    else
        m.focusElement.opacity = 0
    end if
end sub

sub layoutSubview()
    m.titleLabel.width = m.top.dataSource.width
    m.titleLabel.height = m.top.dataSource.height
    m.iconElement.height = 20
    m.iconElement.width = 30
    m.iconElement.translation = [(m.top.dataSource.height - 30) / 2, (m.top.dataSource.height - 20) / 2]
    topBoundingRect = m.top.boundingRect()

    widthElement = m.top.dataSource.width + topBoundingRect.x
    heightElement = topBoundingRect.height + (topBoundingRect.y * 2)

    if m.top.dataSource.title = "0"
        m.focusElement.width = 40
        m.focusElement.height = 40
        m.focusElement.translation = [(widthElement - m.focusElement.width) / 2, 0]
    else
        m.focusElement.width = widthElement
        m.focusElement.height = heightElement
    end if

    m.top.width = widthElement
    m.top.height = heightElement
end sub