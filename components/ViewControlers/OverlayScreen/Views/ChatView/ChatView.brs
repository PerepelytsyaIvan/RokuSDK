sub init()
    m.networkLayerManager = CreateObject("roSGNode", "NetworkLayerManager")
    m.networkLayerManager.observeField("responceCheers", "responceCheers")
    m.background = m.top.findNode("background")
    m.bottomContainer = m.top.findNode("bottomContainer")
    m.sectionCheerList = m.top.findNode("sectionCheerList")
    m.messageBackground = m.top.findNode("messageBackground")
    m.messageGroup = m.top.findNode("messageGroup")
    m.containerTopSmiles = m.top.findNode("containerTopSmiles")
    m.profileImage = m.top.findNode("profileImage")
    m.cheerList = m.top.findNode("cheerList")
    m.sectionCheerList.observeField("itemSelected", "didSelectSection")
    m.cheerList.observeField("itemSelected", "didSelectItemCheer")
    m.removeButton = m.top.findNode("removeButton")
    m.sendButton = m.top.findNode("sendButton")
    m.smileContainerCollection = [m.top.findNode("sendSmileView"), m.top.findNode("sendSmileView1"), m.top.findNode("sendSmileView2")]
    m.removeButton.observeField("selectButton", "didSelectRemoveButton")
    m.sendButton.observeField("selectButton", "didSelectSendButton")
    m.global.observeField("chatData", "onChangeSMS")
    m.messageView = m.top.findNode("messageView")
    m.logoChat = m.top.findNode("logoChat")
    m.mask = m.top.findNode("mask")
    m.animation = m.top.findNode("animation")
    m.interpolatorChatGroup = m.top.findNode("interpolatorChatGroup")
    m.interpolatorEmojiGroup = m.top.findNode("interpolatorEmojiGroup")
    m.interpolatorHeightEmojiGroup = m.top.findNode("interpolatorHeightEmojiGroup")
    m.top.observeField("focusedChild", "onFocusedChild")
    m.timer = configureTimer(10, false)
    m.timer.observeField("fire", "onChangeTimer")
    m.smileArray = []
    m.sendingSmileArray = []
    m.isSetRow = false
    layoutSubviews()
    configureDesign()
    m.num = 0
    m.isAllowedSendSms = true
end sub

sub onChangeTimer()
    m.isAllowedSendSms = true
    m.timer.control = "stop"
end sub

sub configureDesign()
    m.sectionCheerList.focusBitmapBlendColor = m.global.design.buttonBackgroundColor
    m.cheerList.focusBitmapBlendColor = m.global.design.buttonBackgroundColor
end sub

sub configureDataSource()
    m.networkLayerManager.callFunc("getCheers", getCheersUrl(), m.top.accountRoute)
    m.profileImage.uri = getImageWithName(m.global.userData.thumbnail)
end sub

sub onChangeSMS(event)
    data = event.getData()
    elementContent = CreateObject("roSGNode", "ContentNode")
    elementContent.addField("item", "assocarray", false)
    elementContent.addField("emojies", "array", false)
    item = data[data.count() - 1]
    elementContent.item = item
    elementContent.emojies = getEmojies(item.message)
    m.messageView.dataSource = elementContent
end sub

sub configureChatData()
    content = CreateObject("roSGNode", "ContentNode")
end sub

sub getEmojies(message) as object
    presentEmoji = []
    if isValid(message) and message <> ""
        emojies = message.split(" ")
        for each key in m.global.cheers.items()
            item = m.global.cheers[key.key]
            for each cheer in item.cheers
                for each emoji in emojies
                    if emoji = cheer.shortcut or emoji + " " = cheer.shortcut
                        presentEmoji.Push(cheer)
                    end if
                end for
            end for
        end for
    end if

    return presentEmoji
end sub

sub responceCheers(event)
    data = event.getData()
    contentNode = CreateObject("roSGNode", "ContentNode")
    m.cheers = []
    saveInGlobal("cheers", data.cheers)
    for each key in data.cheers
        cheer = data.cheers[key]
        rowContent = contentNode.createChild("ContentNode")
        elementContent = rowContent.createChild("ContentNode")
        elementContent.addField("image", "string", false)
        elementContent.image = getImageWithName(cheer.categoryThumb)
        m.cheers.push(cheer)
    end for
    m.sectionCheerList.itemSize = [getSize(40), getSize(40)]
    m.sectionCheerList.rowItemSize = [[getSize(40), getSize(40)]]
    m.sectionCheerList.itemSpacing = [getSize(0), getSize(15)]
    m.sectionCheerList.rowItemSpacing = [[getSize(0), getSize(15)]]
    m.sectionCheerList.content = contentNode
    m.top.focusKey = 0
    configureChatData()
    configureCheerContentNode(m.cheers[0].cheers)
    layoutSubviews()
end sub

sub configureCheerContentNode(items)
    contentNode = CreateObject("roSGNode", "ContentNode")
    count = 0
    widthAndHeight = []
    spacings = []
    for each item in items
        widthAndHeight.push(getSize(55))
        spacings.push(getSize(5))
        elementContent = contentNode.createChild("ContentNode")
        elementContent.addField("image", "string", false)
        elementContent.image = getImageWithName(item.thumbnail)
        elementContent.addField("cheer", "assocarray", false)
        elementContent.cheer = item
    end for
    m.cheerList.itemSize = [getSize(300), getSize(55)]
    m.cheerList.rowHeights = widthAndHeight
    m.cheerList.columnWidths = widthAndHeight
    m.cheerList.columnSpacings = spacings
    m.cheerList.rowSpacings = spacings
    m.cheerList.numRows = 4
    m.cheerList.content = contentNode
end sub

sub didSelectSection(event)
    index = event.getData()
    if isValid(m.cheers[index]) then configureCheerContentNode(m.cheers[index].cheers)
end sub

sub didSelectItemCheer(event)
    index = event.getData()
    smileUri = m.cheerList.content.getChild(index).image
    if m.smileArray.count() < 3
        m.sendingSmileArray.push(m.cheerList.content.getChild(index).cheer)
        m.smileArray.push(smileUri)
        m.smileContainerCollection[m.smileArray.count() - 1].smileUri = smileUri
        if m.smileArray.count() = 3 then m.top.focusKey = 3        
    end if
end sub

sub didSelectRemoveButton()
    if m.smileArray.count() > 0
        m.smileContainerCollection[m.smileArray.count() - 1].smileUri = "nil"
        m.smileArray.delete(m.smileArray.count() - 1)
        m.sendingSmileArray.delete(m.sendingSmileArray.count() - 1)
    end if
end sub

sub didSelectSendButton()
    if not m.isAllowedSendSms then return
    param = m.top.accountRoute
    param.emoji = m.sendingSmileArray
    m.networkLayerManager.callFunc("sendSms", sendSmsUrl(), param)
    for index = 0 to m.smileArray.count() - 1
        m.smileContainerCollection[index].smileUri = "nil"
        m.smileArray.delete(0)
        m.sendingSmileArray.delete(0)
    end for
    m.timer.control = "start"
    m.isAllowedSendSms = false
end sub

sub setFocusSendSmile()
    m.sendPosterMask.setFocus(true)
end sub

sub setFocusRemoveSmile()
    m.removePosterMask.setFocus(true)
end sub

sub onFocusedChild()
    if m.top.hasFocus()
        m.top.focusKey = m.top.focusKey
    end if
end sub

sub updateFocus()
    if m.top.focusKey = 0 
        m.sectionCheerList.setFocus(true)
        m.removeButton.isFocused = false
        m.sendButton.isFocused = false
    else if m.top.focusKey = 1
        m.cheerList.setFocus(true)
        m.removeButton.isFocused = false
        m.sendButton.isFocused = false
    else if m.top.focusKey = 2
        m.sendButton.isFocused = false
        m.removeButton.isFocused = true
    else if m.top.focusKey = 3
        m.removeButton.isFocused = false
        m.sendButton.isFocused = true
    end if
end sub

sub animationJumpChat(event)
    isShow = event.getData()
    jumpView(isShow)
end sub

sub jumpView(isUp)
    if isUp
        m.interpolatorEmojiGroup.keyValue = [m.bottomContainer.translation, [m.bottomContainer.translation[0], m.bottomContainer.translation[1] - 140]]
        m.interpolatorHeightEmojiGroup.keyValue = [m.messageView.height, m.messageView.height - 140]
    else
        m.interpolatorEmojiGroup.keyValue = [m.bottomContainer.translation, [m.bottomContainer.translation[0], m.bottomContainer.translation[1] + 140]]
        m.interpolatorHeightEmojiGroup.keyValue = [m.messageView.height, m.messageView.height + 140]
    end if

    m.animation.control = "start"
end sub

sub layoutSubviews()
    m.background.width = getSize(400)
    m.background.height = getSize(1080)
    m.background.translation = [(getSize(1920) - getSize(395)), 0]
    m.messageView.height = getSize(549)
    m.mask.width = getSize(395)
    m.mask.height = getSize(150)
    m.logoChat.width = getSize(265)
    m.logoChat.height = getSize(71)
    m.messageBackground.width = getSize(355)
    m.messageBackground.height = getSize(75)
    m.profileImage.width  = getSize(50)
    m.profileImage.height  = getSize(50)
    m.logoChat.translation = [m.background.translation[0] + ((m.background.width - m.logoChat.width) / 2), getSize(30)]
    m.bottomContainer.translation = [m.background.translation[0] + getSize(20), getSize(740)]
    m.sectionCheerList.translation = [0, m.containerTopSmiles.boundingrect().height + getSize(20)]
    m.containerTopSmiles.translation = [getSize(10), (m.containerTopSmiles.boundingrect().height / 2) + getSize(5)]
    m.cheerList.translation = [m.sectionCheerList.translation[0] + m.sectionCheerList.boundingrect().width + getSize(20), m.sectionCheerList.translation[1]]
    m.messageView.translation = [m.background.translation[0] + getSize(20), m.logoChat.translation[1] + m.logoChat.height + getSize(60)]
    m.mask.translation = m.background.translation
    if m.top.isShowActivity then jumpView(true)
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    result = false
    if not press then return result

    if key = "left"
        if m.top.focusKey = 1
            m.top.focusKey = 0
            result = true
        end if
    else if key = "right"
        if m.top.focusKey = 0
            m.top.focusKey = 1
            result = true
        end if
    else if key = "down"
        if m.top.focusKey = 3
            m.top.focusKey = 2
            result = true
        else if m.top.focusKey = 2
            m.top.focusKey = 1
            result = true
        end if
    else if key = "up" 
        if m.top.focusKey = 1 or m.top.focusKey = 0
            m.top.focusKey = 2
            result = true
        else if m.top.focusKey = 2
            m.top.focusKey = 3
            result = true
        end if
    end if

    return result
end function