sub init()
    m.networkLayerManager = CreateObject("roSGNode", "NetworkLayerManager")

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

    m.profileGroup = m.top.findNode("profileGroup")
    m.profileImage = m.top.findNode("profileImage")
    m.fieldsList.observeField("itemSelected", "onItemSelected")
    m.saveButton.observeField("selectButton", "didSelectSaveButton")
    m.networkLayerManager.observeField("avatarsResponce", "onResponseAvatar")
    configureDesign()
    configureDataSource()

    m.userData = {
        name: ""
        email: ""
    }
    m.hidingAnimation.addField("isShow", "bool", false)
end sub

sub configureDesign()
    m.subTitle.font = getMediumFont(30)
    m.title.font = getMediumFont(30)
    m.title.color =  m.global.design.questionTextColor
    m.subTitle.color = m.global.design.buttonBackgroundColor
    m.background.color = "#454545"
end sub

sub configureDataSource()
    m.subTitle.text = UCase(m.global.localization.sideMenuMy)
    m.title.text = UCase(m.global.localization.sideMenuAccount) 

    contentNode = CreateObject("roSGNode", "ContentNode")
    titles = ["Username", "Email"]
    for each title in titles
        row = contentNode.createChild("ContentNode")
        item = row.createChild("ContentNode")
        item.addField("itemSelected", "bool", false)
        item.addField("error", "string", false)
        item.title = title
        item.itemSelected = false
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
    m.keyboarddialog.text = m.fieldsList.content.getChild(m.fieldsList.itemFocused).getChild(0).description
    m.keyboarddialog.focusButton = "pkg:/nil"
    m.keyboarddialog.buttons = [m.global.localization.personalAreaClosePersonalArea, "OK"]
    m.keyboarddialog.observeField("buttonSelected", "didSelectKeyboardButton")
    m.keyboarddialog.setFocus(true)
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

sub didSelectSaveButton()
    regex = CreateObject("roRegex", "[A-Z0-9._%+-]+@", "i")

    if m.userData.name = ""
        m.fieldsList.content.getChild(0).getChild(0).error = "Invalid Username"
    else
        m.fieldsList.content.getChild(0).getChild(0).error = ""
    end if

    if not regex.isMatch(m.userData.email)
        m.fieldsList.content.getChild(1).getChild(0).error = "Invalid Email"
    else
        m.fieldsList.content.getChild(1).getChild(0).error = ""
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
    m.background.width = getSize(400)
    m.background.height = getSize(1080)
    m.background.translation = [(getSize(1920) - getSize(400)), 0]
    m.avatarsList.translation = [getSize(35), 0]
    m.saveButtonAvatar.translation = [(getSize(400) - m.saveButtonAvatar.boundingRect().width) / 2, getSize(850)]
    m.labelsLayoutGroup.translation = [(getSize(1920) - getSize(400)) + ((400 - m.labelsLayoutGroup.boundingRect().width) / 2), getSize(30)]
    m.accountGroup.translation = [getSize(1920) - getSize(400), m.labelsLayoutGroup.boundingRect().height + getSize(30)]
    m.profileGroup.translation = [(getSize(400) - getSize(100)) / 2, getSize(20)]
    m.fieldsList.translation = [(getSize(400) - m.fieldsList.rowItemSize[0][0]) / 2, m.profileGroup.translation[1] + getSize(80) + getSize(40)]
    m.saveButton.translation = [(getSize(400) - m.saveButton.boundingRect().width) / 2, m.fieldsList.boundingRect().height + m.fieldsList.boundingRect().y + getSize(30)]
    m.avatarGroup.translation = [getSize(1920) - getSize(400), getSize(100)]
end sub

sub onResponseAvatar(event)
    data = event.getData()
    contentNode = CreateObject("roSGNode", "ContentNode")
    rowContent = contentNode.createChild("ContentNode")
    count = 0
    for each item in data   
        if count = 3
            rowContent = contentNode.createChild("ContentNode")
            count = 0
        end if
        itemContent = rowContent.createChild("ContentNode")
        itemContent.addField("image", "string", false)
        itemContent.image = getImageWithName(item.thumbnail)
        count++
    end for
    m.avatarsList.content = contentNode
    m.hidingInterpolator.fieldToInterp = m.accountGroup.id + ".opacity"
    m.hidingAnimation.isShow = true
    m.hidingAnimation.observeField("state", "changeStateAnimation")
    showGroups(false)
    updateFocus(4)
end sub

sub updateFocus(key)
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
    end if
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    result = false
    if not press then return result

    if key <> "back"
        result = true
    end if

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
    else if key = "OK" and not m.profileFocus.hasFocus() and m.saveButtonAvatar.hasFocus()

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