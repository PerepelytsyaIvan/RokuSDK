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

end sub

sub configureDataSource()
    m.infoReciveSms.text = "To receive an SMS link. to continue the purchase, scan the code or enter vour mobile number"
    m.saveInfoLabel.text = "Save number on this device"
    m.sendMeSMSLabel.text = "Send me SMS"
    m.QRCodePoster.uri = getImageWithName(m.top.dataSource.qrcodeimage)
    m.disableServiceLabel.text = "If you`d like to disable this service, please go to Cellcom settings > Cellcom Play > Disable"
    m.productPoster.uri = getImageWithName(m.top.dataSource.image)
    ' BUG with text?
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
end sub

sub didSelectOnKeyboard(event)
    item = event.getData()

    if item.title = "Clear"
        m.interactiveLabel.text = ""
    else if item.title = ""
        m.interactiveLabel.text = Left(m.interactiveLabel.text, m.interactiveLabel.text.len() - 1)
    else
        if m.interactiveLabel.text.len() < 15
            m.interactiveLabel.text += item.title
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
        m.toggle.scale = [0.8, 0.8]
        m.sendMeSMSLabel.scale = [0.8, 0.8]
    else if key = "right" and not m.sendMeSMSLabel.hasFocus()
        m.sendMeSMSLabel.setFocus(true)
        m.sendMeSMSLabel.scale = [1.0, 1.0]
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
        m.toggle.scale = [0.8, 0.8]
        m.sendMeSMSLabel.scale = [1.0, 1.0]
    else if key = "down" and m.sendMeSMSLabel.hasFocus() and not m.collectionView.hasFocus()
        m.toggle.setFocus(true)
        m.sendMeSMSLabel.scale = [0.8, 0.8]
        m.toggle.scale = [1.0, 1.0]
    else if key = "back"
        m.top.pressBackButton = true
        result = true
    end if
    return result
end function