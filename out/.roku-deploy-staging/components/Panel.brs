''''''''''''''''''''''''''''''''''
''''''''''''LIFE CYCLE''''''''''''
''''''''''''''''''''''''''''''''''
sub init()
    m.top.setFocus(true)
    m.panel = m.top.findNode("panel")
    m.questionLabel = m.top.findNode("questionLabel")
    m.panelButtons = m.top.findNode("panelButtons")
    m.focusKey = 0
    m.buttons = []
    m.buttonsTitle = []
    m.timerShowPanel = CreateObject("roSGNode", "Timer")
    m.timerShowPanel.duration = 0.1
    m.timerShowPanel.repeat = true
    m.timerShowPanel.observeField("fire", "showPanel")
    m.rowList = m.top.findNode("rowList")
end sub

''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''''CONFIGURE USER INTERFACE''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''
sub showPanel()
    if m.top.videoPlayer.position > m.clock.time

        for each item in m.item.answers
            ? item
            m.buttonsTitle.push(item.answer)
        end for


        m.questionLabel.text = m.item.question
        setupPanelButton()
        m.panel.visible = true

        m.timerHidePanel = CreateObject("roSGNode", "Timer")
        m.timerHidePanel.duration = m.clock.timeToStay
        m.timerHidePanel.observeField("fire", "hidePanel")
        m.timerHidePanel.control = "start"
        m.timerShowPanel.control = "stop"
    end if
end sub

sub hidePanel()
    m.panel.visible = false
    m.top.setFocus(true)
end sub

sub setupPanelButton()
    configureContentNode()
end sub

sub configureContentNode()
    contentNode = CreateObject("roSGNode", "ContentNode")
    rowNode = contentNode.createChild("ContentNode")
    for each item in m.buttonsTitle
        itemNode = rowNode.createChild("ContentNode")
        itemNode.title = item
    end for

    m.rowList.content = contentNode
    m.rowList.setFocus(true)
end sub

sub layoutSubviews()
    m.panel.translation = [700, 560]
    m.questionLabel.width = m.top.widthPanel
    m.questionLabel.height = (m.top.heightPanel - 70)
    m.rowList.itemSize = [m.top.widthPanel - 50, 50]
    m.rowList.translation = [20, m.top.heightPanel - 65]
end sub

''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''''''''CONFIGURE SERTVICE'''''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''
sub setupSDK()
    if m.top.runSDK
        m.userServise = CreateObject("roSGNode", "UserService")
        m.userServise.accountRoute = m.top.accountRoute
        m.userServise.observeField("response", "responseUserData")
        m.userServise.control = "RUN"
        m.top.videoPlayer.observeField("state", "onChangeStateVideoPlayer")
    end if
end sub

sub responseUserData(event)
    responce = event.getData()
    m.infoService = CreateObject("roSGNode", "InfoService")
    m.infoService.accountRoute = m.top.accountRoute
    m.infoService.observeField("response", "responseInfo")
    m.infoService.control = "RUN"
end sub

sub responseInfo(event)
    responce = event.getData()
    clock = responce.data.clocks[0]
    for each item in responce.data.polls
        if item.id = clock.id
            poll = item
        end if
    end for
    m.item = poll
    m.clock = clock
    connectSocket()
    m.timerShowPanel.control = "start"
end sub

''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''''''''CONFIGURE SOCKET''''''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''
sub connectSocket()
    m.socketClient = createObject("roSGNode", "WebSocketClient")
    m.socketClient.observeField("on_open", "connectedSocket")
    m.socketClient.observeField("on_message", "on_message")
    m.socketClient.open = "ws://ws-us2.pusher.com:80/app/9f45bc3adf59ff3ef36d?client=js&version=1.0&protocol=5"
end sub

sub connectedSocket(event)
    isOpen = event.getData()
    m.socketClient.send = [FormatJson({ "event": "pusher:subscribe", "data": { "channel": "CH_" + m.top.accountRoute.channelId } })]
end sub

sub on_message(event)
    message = event.getData()
    parseMessage = ParseJson(message.message)
    if isValid(parseMessage.data)
        json = ParseJson(parseMessage.data)
        if isValid(json.poll)
            m.buttonsTitle = []
            m.item = json.poll
            m.clock.timeToStay = json.timeToStay
            m.clock.time = (json.starting_time / 1000)
            for each item in m.item.answers
                m.buttonsTitle.push(item.answer)
            end for

            m.questionLabel.text = m.item.question
            setupPanelButton()
            m.panel.visible = true

            m.timerHidePanel = CreateObject("roSGNode", "Timer")
            m.timerHidePanel.duration = json.timeToStay
            m.timerHidePanel.observeField("fire", "hidePanel")
            m.timerHidePanel.control = "start"
            m.timerShowPanel.control = "stop"
        end if

        ? "message------->>>>" json
    end if
end sub

''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''''''''PLAYER OBSERVERS''''''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''
sub onChangeStateVideoPlayer(event)
    state = event.getData()
    if state = "paused" or state = "stopped" or state = "finished"
        m.timerShowPanel.control = "stop"
    else if state = "playing"
    end if
end sub

''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''''''''PROCCESING FOCUS'''''''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''
sub unfocusAllButton()
    for each item in m.buttons
        focusButton(item, false)
    end for
end sub

sub updateFocusButton(key)
    unfocusAllButton()
    if key < m.buttons.count()
        m.indexButton = key
        focusButton(m.buttons[key], true)
    end if
end sub


sub focusButton(button, focused)
    if button = invalid then return
    if focused
        button.opacity = 1.0
    else
        button.opacity = 0.4
    end if
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    ? ">>> VideoPanel: onKeyEvent("key", "press")"
    result = false
    if not press then return result
    if key = "right"
        updateFocusButton(min(m.focusKey + 1, m.buttons.count() - 1))
        result = true
    else if key = "left"
        updateFocusButton(max(m.focusKey - 1, 0))
        result = true
    else if key = "OK"
        if m.indexButton = 0

        else
            m.panel.visible = false
            m.top.videoPlayer.setFocus(true)
            result = true
        end if
    end if
    return result
end function
