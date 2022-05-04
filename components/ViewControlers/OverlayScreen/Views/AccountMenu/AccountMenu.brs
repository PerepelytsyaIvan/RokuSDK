sub init()
    m.networkLayerManager = CreateObject("roSGNode", "NetworkLayerManager")
    m.loadingIndicator = m.top.findNode("loadingProgress")
    m.hidingButtonAnimation = m.top.findNode("hidingButtonAnimation")
    m.interpolator = m.top.findNode("interpolator")
    m.backgroundProfile = m.top.findNode("backgroundProfile")
    m.profileImage = m.top.findNode("profileImage")
    m.profileFocus = m.top.findNode("profileFocus")

    m.background = m.top.findNode("background")
    m.layoutGroup = m.top.findNode("layoutGroup")
    m.subTitle = m.top.findNode("subTitle")
    m.title = m.top.findNode("title")
    m.fieldsList = m.top.findNode("fieldsList")
    m.saveButton = m.top.findNode("saveButton")
    m.profileFocus = m.top.findNode("profileFocus")
    m.avatarsList = m.top.findNode("avatarsList")
    m.accountGroup = m.top.findNode("accountGroup")
    m.labelsLayoutGroup = m.top.findNode("labelsLayoutGroup")
    m.hidingAnimation = m.top.findNode("hidingAnimation")
    m.hidingInterpolator = m.top.findNode("hidingInterpolator")
    m.saveButtonAvatar = m.top.findNode("saveButtonAvatar")
    m.avatarGroup = m.top.findNode("avatarGroup")
    m.infoUpdateLabel = m.top.findNode("infoUpdateLabel")

    m.profileGroup = m.top.findNode("profileGroup")
    m.profileImage = m.top.findNode("profileImage")
    m.fieldsList.observeField("itemSelected", "onItemSelected")
    m.saveButton.observeField("selectButton", "didSelectSaveButton")
    m.top.observeField("focusedChild", "onFocusedChild")
    m.networkLayerManager.observeField("avatarsResponce", "onResponseAvatar")
    m.networkLayerManager.observeField("isUpdateUserInfo", "onResponseUpdateUser")
    m.avatarsList.observeField("itemSelected", "didSelectAvatar")
    m.saveButtonAvatar.observeField("selectButton", "didSelectSaveButtonAvatar")

    m.userData = {
        name: ""
        email: ""
    }

    configureDesign()

    m.hidingAnimation.addField("isShow", "bool", false)
end sub

sub didSelectAvatar(event)
    index = event.getData()
    item = m.avatarsList.content.getChild(index)
    m.userAvatar = item.image
    m.avatarsList.content.getChild(index).isSelectItem = true
    if isValid(m.previusIndex)
        if m.previusIndex <> index
            m.avatarsList.content.getChild(m.previusIndex).isSelectItem = false
        end if
    end if
    m.previusIndex = index
end sub

sub configureDesign()
    m.subTitle.font = getMediumFont(30)
    m.title.font = getMediumFont(30)
    m.infoUpdateLabel.font = getMediumFont(25)
    m.title.color =  m.global.design.questionTextColor
    m.infoUpdateLabel.color = m.global.design.buttonBackgroundColor
    m.subTitle.color = m.global.design.buttonBackgroundColor
    m.background.color = "#000000"
end sub

sub configureDataSource()
    m.subTitle.text = UCase(m.global.localization.sideMenuMy)
    m.title.text = UCase(m.global.localization.generalOverlayMenu) 
    savedImage = RegRead("userAvatar")

    if isValid(savedImage)
        m.profileImage.uri = savedImage
    end if

    contentNode = CreateObject("roSGNode", "ContentNode")
    titles = [m.global.localization.sideMenuUsername, m.global.localization.sideMenuEmail]

    fieldsData = [m.global.userData.name, m.global.userData.email]
    if m.global.userData.name <> ""
        m.saveButton.activateButton = true
    end if
    m.userData.name = m.global.userData.name
    m.userData.email = m.global.userData.email
    count = 0
    for each title in titles
        row = contentNode.createChild("ContentNode")
        item = row.createChild("ContentNode")
        item.addField("itemSelected", "bool", false)
        item.addField("error", "string", false)
        if fieldsData[count] <> ""
            item.description = fieldsData[count]
        end if
        item.title = title
        item.itemSelected = false
        count++
    end for

    m.fieldsList.content = contentNode
    updateFocus(0)
    layoutSubviews()
end sub

sub showGroups(asShow)
    if asShow
        m.hidingInterpolator.keyValue = [0, 1]
    else
        m.hidingInterpolator.keyValue = [1, 0]
    end if
    m.hidingAnimation.control = "start"
end sub

sub onItemSelected(event)
    index = event.getData()
    createKeyboard(m.fieldsList.content.getChild(index).getChild(0).title)
end sub

sub createKeyboard(title)
    m.keyboarddialog = m.top.createChild("KeyboardDialog")
    m.keyboarddialog.backgroundUri = "pkg:/images/backgroundKeyboard.9.png"
    m.keyboarddialog.title = "Please enter " + title
    m.keyboarddialog.text = m.fieldsList.content.getChild(m.fieldsList.itemSelected).getChild(0).description
    m.keyboarddialog.keyboard.textEditBox.cursorPosition = m.fieldsList.content.getChild(m.fieldsList.itemSelected).getChild(0).description.len()
    m.keyboarddialog.focusButton = "pkg:/nil"
    m.keyboarddialog.buttons = ["OK", m.global.localization.personalAreaClosePersonalArea]
    m.keyboarddialog.observeField("buttonSelected", "didSelectKeyboardButton")
    updateFocus(6)
end sub

sub didSelectKeyboardButton(event)
    index = event.getData()

    if index = 0
        m.fieldsList.content.getChild(m.fieldsList.itemSelected).getChild(0).description = m.keyboarddialog.text
    end if
    m.top.removeChild(m.keyboarddialog)
    m.fieldsList.setFocus(true)

    m.userData.name = m.fieldsList.content.getChild(0).getChild(0).description
    m.userData.email = m.fieldsList.content.getChild(1).getChild(0).description

    if m.userData.name <> "" or m.userData.email <> ""
        m.saveButton.activateButton = true
    else
        m.saveButton.activateButton = false
    end if
end sub

sub validateEmail() as object
    regexEmail1 = CreateObject("roRegex", "[@]", "i")
    isMatchEmail1 = regexEmail1.isMatch(m.userData.email)

    regexEmail2 = CreateObject("roRegex", "[.]", "i")
    isMatchEmail2 = regexEmail2.isMatch(m.userData.email)

    if m.userData.email.len() > 50 then return false
    return isMatchEmail1 and isMatchEmail2
end sub

sub validateUsername() as object
    regexUsername = CreateObject("roRegex", "[`!@#$%^&*()+\=\[\]{};:\\|,.<>\/?~]", "i")
    isMatchUsername = regexUsername.isMatch(m.userData.name)

    if m.userData.name.len() < 30 and m.userData.name.len() > 3 then isMatchUsername = true
    return isMatchUsername
end sub

sub didSelectSaveButton()
    regex = CreateObject("roRegex", "[A-Z0-9._%+-]+@", "i")
    m.infoUpdateLabel.text = ""
    isValidEmail = false
    isValidUsername = false
    if m.userData.name = "" or not validateUsername() 
        isValidUsername = false
        m.fieldsList.content.getChild(0).getChild(0).error = m.global.localization.sideMenuUsernameValidation
    else
        isValidUsername = true
        m.fieldsList.content.getChild(0).getChild(0).error = ""
    end if

    if not validateEmail() and m.userData.email <> ""
        isValidEmail = false
        m.fieldsList.content.getChild(1).getChild(0).error = m.global.localization.sideMenuEmailValidation
    else
        m.fieldsList.content.getChild(1).getChild(0).error = ""
        isValidEmail = true
    end if

    if isValidUsername and isValidEmail
        showLoadingIndicator(true)
        animaetButton(false)
        param = {}
        m.userData.avatar = m.profileImage.uri.replace("https://media2.inthegame.io", "")
        param.userData = m.userData
        param.accountRoute = m.top.accountRoute
        m.networkLayerManager.callFunc("sendUserUpdate", sendUserUpdateUrl(), param)
    end if
end sub

sub onResponseUpdateUser(event)
    isUpdate = event.getData()
    showLoadingIndicator(false)
    animaetButton(true)

    if isUpdate
        m.infoUpdateLabel.text = m.global.localization.sideMenuInfoSaved
    end if
end sub

sub changeStateAnimation(event)
    state = event.getData()

    if state = "stopped"
        if m.hidingAnimation.isShow
            m.hidingInterpolator.fieldToInterp = m.avatarGroup.id + ".opacity"
        else
            m.hidingInterpolator.fieldToInterp = m.accountGroup.id + ".opacity"
        end if
        m.hidingAnimation.unobserveField("state")
        showGroups(true)
    end if
end sub

sub layoutSubviews()
    arrayImages = [m.backgroundProfile, m.profileFocus]
    for each image in arrayImages
        image.width = getSize(100)
        image.height = getSize(100)
    end for
    m.profileImage.width = getSize(60)
    m.profileImage.height = getSize(60)
    m.profileImage.translation = [(m.backgroundProfile.width - m.profileImage.width) / 2, (m.backgroundProfile.height - m.profileImage.height) / 2]
    m.background.width = getSize(405)
    m.background.height = getSize(1080)
    m.background.translation = [(getSize(1920) - getSize(400)), 0]
    m.avatarsList.translation = [getSize(35), 0]
    m.saveButtonAvatar.translation = [(getSize(400) - m.saveButtonAvatar.boundingRect().width) / 2, getSize(750)]
    m.labelsLayoutGroup.translation = [(getSize(1920) - getSize(400)) + ((getSize(400) - m.labelsLayoutGroup.boundingRect().width) / 2), getSize(30)]
    m.accountGroup.translation = [getSize(1920) - getSize(400), m.labelsLayoutGroup.boundingRect().height + getSize(30)]
    m.profileGroup.translation = [(getSize(400) - getSize(100)) / 2, getSize(20)]
    m.fieldsList.itemSize = [getSize(320), getSize(120)]
    m.fieldsList.rowItemSize = [[getSize(320), getSize(120)]]
    m.fieldsList.translation = [(getSize(400) - m.fieldsList.rowItemSize[0][0]) / 2, m.profileGroup.translation[1] + getSize(80) + getSize(40)]
    m.saveButton.translation = [(getSize(400) - m.saveButton.boundingRect().width) / 2, m.fieldsList.boundingRect().height + m.fieldsList.boundingRect().y + getSize(30)]
    m.avatarGroup.translation = [getSize(1920) - getSize(400), getSize(100)]
    m.infoUpdateLabel.translation = [0, m.saveButton.translation[1] + 30 + m.saveButton.boundingRect().height]
    m.infoUpdateLabel.width = m.background.width
end sub

sub onResponseAvatar(event)
    data = event.getData()

    contentNode = CreateObject("roSGNode", "ContentNode")
    count = 0
    widthAndHeight = []
    spacings = []

    for each item in data
        widthAndHeight.push(getSize(100))
        spacings.push(getSize(15))
        elementContent = contentNode.createChild("ContentNode")
        elementContent.addField("image", "string", false)
        elementContent.image = getImageWithName(item.thumbnail)
        elementContent.addField("isSelectItem", "bool", false)

        savedImage = RegRead("userAvatar")
        if isValid(savedImage) and savedImage = getImageWithName(item.thumbnail)
            elementContent.isSelectItem = true
            m.previusIndex = contentNode.getChildCount() - 1
        else
            elementContent.isSelectItem = false 
        end if

        elementContent.cheer = item
    end for
    m.avatarsList.itemSize = [getSize(300), getSize(55)]
    m.avatarsList.rowHeights = widthAndHeight
    m.avatarsList.columnWidths = widthAndHeight
    m.avatarsList.columnSpacings = spacings
    m.avatarsList.rowSpacings = spacings
    m.avatarsList.numRows = 6
    m.avatarsList.content = contentNode

    m.hidingInterpolator.fieldToInterp = m.accountGroup.id + ".opacity"
    m.hidingAnimation.isShow = true
    m.hidingAnimation.observeField("state", "changeStateAnimation")
    showGroups(false)
    updateFocus(4)
end sub

sub didSelectSaveButtonAvatar()
    if isValid(m.userAvatar)
        RegWrite("userAvatar", m.userAvatar)
        m.profileImage.uri = m.userAvatar
    end if
    m.hidingAnimation.observeField("state", "changeStateAnimation")
    m.hidingInterpolator.fieldToInterp = m.avatarGroup.id + ".opacity"
    m.hidingAnimation.isShow = false
    m.userData.avatar = m.userAvatar
    showGroups(false)
    updateFocus(0)
end sub

sub animaetButton(isShow)
    if isShow
        updateFocus(2)
        m.interpolator.keyValue = [0,1]
    else
        m.top.setFocus(true)
        m.interpolator.keyValue = [1,0]
    end if
    m.hidingButtonAnimation.control = "start"
end sub

function showLoadingIndicator(show)
    m.loadingIndicator.translation = [getSize(762), getSize(-20)]
    m.loadingIndicator.visible = show

    if show
        m.loadingIndicator.control = "start"
    else
        m.top.focusKey = m.top.focusKey
        m.loadingIndicator.bEatKeyEvents = false
        m.loadingIndicator.control = "stop"
    end if
end function

sub updateFocus(key)
    m.previusKey = key
    if key = 0
        m.profileFocus.opacity = 1
        m.profileFocus.setFocus(true)
    else if key = 1
        m.profileFocus.opacity = 0
        m.saveButton.focusButton = false
        m.fieldsList.setFocus(true)
    else if key = 2
        m.saveButton.focusButton = true
        m.saveButton.setFocus(true)
    else if key = 4
        m.saveButtonAvatar.focusButton = false
        m.avatarsList.setFocus(true)
    else if key = 5
        m.saveButtonAvatar.focusButton = true
        m.saveButtonAvatar.setFocus(true)
    else if key = 6
        m.keyboarddialog.setFocus(true)
    end if
end sub

sub onFocusedChild()
    if m.top.hasFocus()
        updateFocus(m.previusKey)
    end if
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    result = false
    if not press then return result

    if key = "up" and m.saveButton.hasFocus() and not m.saveButtonAvatar.hasFocus()
        updateFocus(1)
        result = true
    else if key = "up" and m.fieldsList.hasFocus() and not m.saveButtonAvatar.hasFocus()
        updateFocus(0)
        result = true
    else if key = "up" and m.saveButtonAvatar.hasFocus()
        updateFocus(4)
        result = true
    else if key = "down" and m.fieldsList.hasFocus() and m.saveButton.activateButton and not m.saveButtonAvatar.hasFocus()
        updateFocus(2)
        result = true
    else if key = "down" and m.profileFocus.hasFocus() and not m.avatarsList.hasFocus() and not m.saveButtonAvatar.hasFocus() and not m.fieldsList.hasFocus()
        updateFocus(1)
        result = true
    else if key = "down" and m.avatarsList.hasFocus()
        updateFocus(5)
        result = true
    else if key = "OK" and m.profileFocus.hasFocus() and not m.saveButtonAvatar.hasFocus()
        m.networkLayerManager.callFunc("getAllAvatars", getAvatarsUrl(), m.top.accountRoute)
        result = true
    else if key = "back" and m.hidingAnimation.isShow
        m.hidingAnimation.observeField("state", "changeStateAnimation")
        m.hidingInterpolator.fieldToInterp = m.avatarGroup.id + ".opacity"
        m.hidingAnimation.isShow = false
        showGroups(false)
        updateFocus(0)
        result = true
    end if
    return result
end function
