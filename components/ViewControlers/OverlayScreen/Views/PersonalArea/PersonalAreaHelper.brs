sub initView()
    m.loadingIndicator = m.top.findNode("loadingProgress")

    m.containerView = m.top.findNode("containerView")
    m.centralViewsContainer = m.top.findNode("centralViewsContainer")
    m.rightViewsGroup = m.top.findNode("rightViewsGroup")
    m.rightViewsLayout = m.top.findNode("rightViewsLayout")
    m.descriptionProductLayout = m.top.findNode("descriptionProductLayout")
    m.bottomGroup = m.top.findNode("bottomGroup")

    m.collectionView = m.top.findNode("collectionView")
    m.numberList = m.top.findNode("numberList")
    m.codeButtonList = m.top.findNode("codeButtonList")
    m.numberView = m.top.findNode("numberView")

    m.productPoster = m.top.findNode("productPoster")
    m.indicatorView = m.top.findNode("indicatorView")
    m.QRCodePoster = m.top.findNode("QRCodePoster")
    m.background = m.top.findNode("background")
    m.separatorPoster = m.top.findNode("separatorPoster")
    m.keyboardLayout = m.top.findNode("keyboardLayout")
    m.infoReciveSms = m.top.findNode("infoReciveSms")
    m.noSearchResultLabel = m.top.findNode("noSearchResultLabel")
    m.rowList = m.top.findNode("rowList")
    m.maskButton = m.top.findNode("maskButton")
    m.saveInfoLabel = m.top.findNode("saveInfoLabel")

    m.rightBackground = m.top.findNode("rightBackground")
    m.maskNumberList = m.top.findNode("maskNumberList")

    m.productNameLabel = m.top.findNode("productNameLabel")
    m.productDescriptionLabel = m.top.findNode("productDescriptionLabel")
    m.discountLabel = m.top.findNode("discountLabel")
    m.discountPercentLabel = m.top.findNode("discountPercentLabel")
    m.totalPriceLabel = m.top.findNode("totalPriceLabel")
    m.aboutPurchaseLabel = m.top.findNode("aboutPurchaseLabel")
    m.errorLabel = m.top.findNode("errorLabel")

    m.switch = m.top.findNode("switch")

    m.animation = m.top.findNode("animation")
    m.hidingInterpolator = m.top.findNode("hidingInterpolator")
    m.interpolatorGroup = m.top.findNode("interpolatorGroup")
    m.interpolator = m.top.findNode("interpolator")
    m.infoLabel = m.top.findNode("infoLabel")
    m.buttonsGroup = m.top.findNode("buttonsGroup")
    
    m.interpolatorMaskWidth = m.top.findNode("interpolatorMaskWidth")
    m.interpolatorMask = m.top.findNode("interpolatorMask")
    m.animationMask = m.top.findNode("animationMask")
    m.interpolatorSwitchGroup = m.top.findNode("interpolatorSwitchGroup")
    m.interpolatorIndicatorView = m.top.findNode("interpolatorIndicatorView")
    m.animationButton = m.top.findNode("animationButton")
    m.interpolatorButtonTranslation = m.top.findNode("interpolatorButtonTranslation")
    m.interpolatorButton = m.top.findNode("interpolatorButton")

    m.isShowMenuCode = false
    m.animationMask.addField("isShow", "boolean", false)
    configureObserve()
end sub

sub configureObserve()
    m.rowList.observeField("rowItemSelected", "didSelectRow")
    m.codeButtonList.observeField("rowItemSelected", "didSelectNumberCode")
    m.numberView.observeField("rowItemSelected", "didSelectNumberView")
    m.codeButtonList.observeField("rowItemFocused", "focusedNumberCode")
    m.collectionView.observeField("item", "didSelectOnKeyboard")
    m.numberList.observeField("rowItemSelected", "didSelectNumberList")
    m.numberList.observeField("currFocusRow", "changeFocusedNumberList")
end sub

sub configureDesign()
    m.infoReciveSms.font = getRegularFont(20)
    m.productNameLabel.font = getBoldFont(30)
    m.productDescriptionLabel.font = getRegularFont(20)
    m.discountLabel.font = getRegularFont(20)
    m.discountPercentLabel.font = getBoldFont(25)
    m.noSearchResultLabel.font = getBoldFont(30)
    m.totalPriceLabel.font = getBoldFont(26)
    m.aboutPurchaseLabel.font = getRegularFont(16)
    m.infoLabel.font = getMediumFont(18)
    m.errorLabel.font = getMediumFont(15)
    m.errorLabel.color = m.global.design.wrongAnswerTextColor
end sub

sub getDataForKeyboard() as object
    dataSource = [
        { "title": "1", "image": "", width: 45, height: 45, itemComponent: "KeyboardItem" }
        { "title": "2", "image": "", width: 45, height: 45, itemComponent: "KeyboardItem" }
        { "title": "3", "image": "", width: 45, height: 45, itemComponent: "KeyboardItem" }
        { "title": "4", "image": "", width: 45, height: 45, itemComponent: "KeyboardItem", newSection: true }
        { "title": "5", "image": "", width: 45, height: 45, itemComponent: "KeyboardItem" }
        { "title": "6", "image": "", width: 45, height: 45, itemComponent: "KeyboardItem" }
        { "title": "7", "image": "", width: 45, height: 45, itemComponent: "KeyboardItem", newSection: true }
        { "title": "8", "image": "", width: 45, height: 45, itemComponent: "KeyboardItem" }
        { "title": "9", "image": "", width: 45, height: 45, itemComponent: "KeyboardItem" }
        { "title": m.global.localization.personalAreaClear, "image": "", width: 45, height: 45, itemComponent: "KeyboardItem", fontSize: 15, newSection: true}
        { "title": "0", "image": "", width: 45, height: 45, itemComponent: "KeyboardItem" }
        { "title": "", "image": "pkg:/images/removeIcon.png", width: 45, height: 45, itemComponent: "KeyboardItem" }
    ]
    return dataSource
end sub

sub getContentNodeForNumberList()
    configureCountryCodeContentNode()
    contentNodeCode = CreateObject("roSGNode", "ContentNode")
    rowContentCode = contentNodeCode.createChild("ContentNode")
    elementContentCode = rowContentCode.createChild("ContentNode")
    item = {"country": "", "code": "+" + m.global.infoApp.countryCodeToSendSMS.toStr(), selected: false}
    elementContentCode.addField("item", "assocarray", true)
    elementContentCode.item = item
    m.codeButtonList.rowItemSize = [115, 55]
    m.codeButtonList.itemSize = [115, 55]
    m.codeButtonList.content = contentNodeCode
    configureNumberView()
end sub

sub configureCountryCodeContentNode(codeList = invalid)
    countryCodeList = codeList
    m.numberList.content = invalid
    if IsInvalid(codeList) then countryCodeList = m.global.infoApp.countryList

    contentNode = CreateObject("roSGNode", "ContentNode")
    rowSpacing = []
    for each item in countryCodeList
        rowContent = contentNode.createChild("ContentNode")
        elementContent = rowContent.createChild("ContentNode")
        elementContent.addField("item", "assocarray", true)
        country = item.country
        arrayCountry = country.Split("(")
        item.country = arrayCountry[0]
        elementContent.item = item
        rowSpacing.push(5)
    end for
    m.noSearchResultLabel.visible = contentNode.getChildCount() = 0
    m.indicatorView.visible = not contentNode.getChildCount() = 0

    m.numberList.rowItemSize = [[390, 40]]
    m.numberList.rowSpacings = rowSpacing
    m.numberList.itemSize = [390, 40]
    m.numberList.content = contentNode
end sub

sub configureNumberView()
    content = CreateObject("roSGNode", "ContentNode")
    rowContent = content.createChild("ContentNode")
    elementContent = rowContent.createChild("ContentNode")
    elementContent.addField("item", "assocarray", false)
    elementContent.item = {"country": "", "code": "", selected: false}
    m.numberView.content = content
end sub

sub configureContentNode(withExitButton)
    if withExitButton
        array = [m.global.localization.personalAreaSendSmsAgain, m.global.localization.personalAreaExit]
    else
        array = [m.global.localization.personalAreaSendSms]
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

    if withExitButton
        m.rowList.jumpToRowItem = [1, 0]
    end if
end sub

sub editingCountryCode(text)
    code = m.codeButtonList.content.getChild(0).getChild(0).item.code
    if text = m.global.localization.personalAreaClear
        code = "+"
    else if text = ""
        code = Left(code, code.len() - 1)
    else
        if code.len() < 5
            code += text
        end if    
    end if
    if code = ""
        code = "+"
    end if
    item = m.codeButtonList.content.getChild(0).getChild(0).item
    item.code = code
    m.codeButtonList.content.getChild(0).getChild(0).item = item
    item.code = item.code.replace("+", "")
    configureCountryCodeContentNode(filterAssocarray(m.global.infoApp.countryList, item))
end sub

sub editingNumber(text)
    numberInfo = {code: m.numberView.content.getChild(0).getChild(0).item.code, number: "", isNumberPhone: true, selected: true}

    if text = m.global.localization.personalAreaClear
        numberInfo.code = ""
    else if text = ""
        numberInfo.code = Left(numberInfo.code, numberInfo.code.len() - 1)
    else
        if numberInfo.code.len() < 10
            numberInfo.code += text
        end if
    end if
    m.numberView.content.getChild(0).getChild(0).item = numberInfo
end sub

sub activateNumberBox(isActive)
    item = m.numberView.content.getChild(0).getChild(0).item
    item.selected = isActive
    m.numberView.content.getChild(0).getChild(0).item = item
end sub

sub activateCodeBox(isActive)
    item = m.codeButtonList.content.getChild(0).getChild(0).item
    item.selected = isActive
    m.codeButtonList.content.getChild(0).getChild(0).item = item
end sub

sub showNumberList()
    if m.animationMask.isShow then return
    m.errorLabel.text = ""
    m.interpolatorMask.keyValue = [m.maskNumberList.translation, [m.maskNumberList.translation[0], m.maskNumberList.translation[1] + m.maskNumberList.height]]
    m.interpolatorSwitchGroup.keyValue = [m.bottomGroup.translation, [m.bottomGroup.translation[0], m.bottomGroup.translation[1] + 263 - 35]]
    translationX = m.indicatorView.translation[0]
    m.interpolatorIndicatorView.keyValue = [[translationX, m.interpolatorMask.keyValue[0][1]], [translationX, m.interpolatorMask.keyValue[1][1]]]
    m.animationMask.isShow = true
    m.animationMask.control = "start"
    if m.numberList.content.getChildCount() = 0
        m.noSearchResultLabel.text = "No search results"
    end if
end sub

sub hideNumberList()
    m.noSearchResultLabel.text = ""
    if not m.animationMask.isShow then return
    m.interpolatorMask.keyValue = [m.interpolatorMask.keyValue[1], [m.maskNumberList.translation[0], m.interpolatorMask.keyValue[1][1] - m.maskNumberList.height]]
    m.interpolatorSwitchGroup.keyValue = [m.interpolatorSwitchGroup.keyValue[1], [m.bottomGroup.translation[0], m.bottomGroup.translation[1] - 263 + 35]]
    translationX = m.indicatorView.translation[0]
    m.interpolatorIndicatorView.keyValue = [[translationX, m.interpolatorMask.keyValue[0][1]], [translationX, m.interpolatorMask.keyValue[1][1]]]
    m.animationMask.isShow = false
    m.animationMask.control = "start"
end sub

sub showAnimationButton()
    m.interpolatorButtonTranslation.keyValue = [m.maskButton.translation, [m.maskButton.translation[0], m.maskButton.translation[1] + 60]]
    m.interpolatorButton.keyValue = [m.maskButton.height, 0]
    m.animationButton.control = "start"
end sub