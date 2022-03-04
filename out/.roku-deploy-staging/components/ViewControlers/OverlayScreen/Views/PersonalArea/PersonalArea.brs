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
    m.toggle = m.top.findNode("toggle")
    m.saveInfoLabel = m.top.findNode("saveInfoLabel")
    m.rightViewsGroup = m.top.findNode("rightViewsGroup")

    m.collectionView.observeField("item", "didSelectOnKeyboard")
    configureDesign()
end sub

sub configureDesign()
    m.containerView.translation = [(getScreenWidth() - m.background.width) / 2, (getScreenHeight() - m.background.height) / 2]
    m.separatorPoster.translation = [m.QRCodePoster.width + m.QRCodePoster.translation[0] + m.keyboardLayout.translation[0] + 60, (m.background.height - m.separatorPoster.height) / 2]
    m.centralViewsLayout.translation = [m.separatorPoster.translation[0] + 40, 130]
    m.rightViewsGroup.translation = [m.infoReciveSms.width + m.centralViewsLayout.translation[0] + 50, 0]
    m.interactiveLabel.font = getRegularFont(23)
    m.infoReciveSms.font = getRegularFont(20)
    m.saveInfoLabel.font = getRegularFont(20)
end sub

sub configureDataSource()
    m.infoReciveSms.text = "To receive an SMS link. to continue the purchase, scan the code or enter vour mobile number"
    m.saveInfoLabel.text = "Save number on this device"
    m.QRCodePoster.uri = getImageWithName(m.top.dataSource.qrcodeimage)
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
        {"title": "1", "image": "", width: 40, height: 40, itemComponent: "KeyboardItem"}
        {"title": "2", "image": "", width: 40, height: 40, itemComponent: "KeyboardItem"}
        {"title": "3", "image": "", width: 40, height: 40, itemComponent: "KeyboardItem"}
        {"title": "", "image": "pkg:/images/removeIcon.png", width: 40, height: 40, itemComponent: "KeyboardItem"}
        {"title": "4", "image": "", width: 40, height: 40, itemComponent: "KeyboardItem", newSection: true}
        {"title": "5", "image": "", width: 40, height: 40, itemComponent: "KeyboardItem"}
        {"title": "6", "image": "", width: 40, height: 40, itemComponent: "KeyboardItem"}
        {"title": "7", "image": "", width: 40, height: 40, itemComponent: "KeyboardItem", newSection: true}
        {"title": "8", "image": "", width: 40, height: 40, itemComponent: "KeyboardItem"}
        {"title": "9", "image": "", width: 40, height: 40, itemComponent: "KeyboardItem"}
        {"title": "Clear", "image": "", width: 70, height: 40, itemComponent: "KeyboardItem"}
        {"title": "0", "image": "", width: 135, height: 40, itemComponent: "KeyboardItem", newSection: true}
    ]
    return dataSource
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    result = true
    if not press then return true
    
    if key = "left"
        m.toggle.isOn = false
    else if key = "right"
        m.toggle.isOn = true
    end if
    return result
end function