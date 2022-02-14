sub init()
    m.networkLayerManager = CreateObject("roSGNode", "NetworkLayerManager")
    m.modelOverlay = CreateObject("roSGNode", "ModelOverlay")
    m.overlayView = m.top.findNode("overlayView")

    m.timerHidePanel = configureTimer(1.0, true)
    m.timerShowPanel = configureTimer(1.0, true)

    configureObservers()
end sub

sub configureObservers()
    m.networkLayerManager.observeField("registrationResponce", "registrationUser")
    m.networkLayerManager.observeField("loginizationResponce", "loginizationUser")
    m.networkLayerManager.observeField("infoResponce", "infoApplication")
    m.networkLayerManager.observeField("answerResponce", "onResponceAnswer")
    m.networkLayerManager.observeField("quizEventResponce", "onResponceQuizEvent")

    m.timerHidePanel.observeField("fire", "hidingOverlay")
    m.timerShowPanel.observeField("fire", "showingOverlayWithInfoUser")

    m.overlayView.observeField("selectedAnswer", "onSelectAnswer")
end sub

sub onSelectAnswer(event)
    m.answer = event.getData() 
    m.networkLayerManager.callFunc("sendAnswer", getSendAnswerUrl(m.eventModel.questiontype, m.eventModel.idEvent), m.top.accountRoute, m.answer.answer)
end sub

sub onResponceAnswer(event)
    responce = event.getData()
    eventModel = m.modelOverlay.callFunc("getAnswers", m.answer, m.eventModel, responce)
    RegWrite(eventModel.idevent, FormatJson(eventModel))
    m.overlayView.callFunc("showAnswers", eventModel)
    m.timerHidePanel.control = "start"
end sub

sub onResponceQuizEvent(event)
    quizEvent = event.getData()
    m.eventModel = m.modelOverlay.callFunc("getEventInfoWithSocket", quizEvent, "injectQuiz")
    m.timeForHidingOverlay = m.eventModel.timeForHiding
    m.overlayView.callFunc("configureSecondsLabel", m.timeForHidingOverlay)
    m.type = m.eventModel.questionType
    showingOverlay()
end sub

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
        if parseMessage.event <> "pusher_internal:subscription_succeeded" and parseMessage.event <> "pusher:connection_established" and json.messageType <> "streamerInfo"
            if json.messageType = "injectQuiz"
                m.networkLayerManager.callFunc("getQuizEvent", getQuizUrl(json.id))
            else
                m.eventModel = m.modelOverlay.callFunc("getEventInfoWithSocket", json)
                m.timeForHidingOverlay = m.eventModel.timeForHiding
                m.overlayView.callFunc("configureSecondsLabel", m.timeForHidingOverlay)
                m.type = m.eventModel.questionType
                showingOverlay()
            end if
        end if
    end if
end sub

sub configurationUser()
    if isValid(m.top.accountRoute)
        m.networkLayerManager.callFunc("registerUser", getRegistrationUrl(), m.top.accountRoute)
    end if
end sub

sub registrationUser(event)
    registrationInfo = event.getData()
    RegWrite("registrationToken", registrationInfo.token)
    m.networkLayerManager.callFunc("loginUser", getLoginizationUrl(), m.top.accountRoute, registrationInfo.token)
end sub

sub loginizationUser(event)
    loginizationInfo = event.getData()
    RegWrite("loginizationToken", loginizationInfo.token)
    m.networkLayerManager.callFunc("getInfo", getInfoAppUrl(), m.top.accountRoute)
end sub

sub infoApplication(event)
    infoApp = event.getData()
    desingModel = m.modelOverlay.callFunc("getDesignModel", infoApp)
    m.eventModel = m.modelOverlay.callFunc("getEventInfo", infoApp)
    m.overlayView.designModel = desingModel

    connectSocket()
    if m.eventModel.isShowView
        m.timeForHidingOverlay = m.eventModel.timeForHiding
        m.overlayView.callFunc("configureSecondsLabel", m.timeForHidingOverlay)
        m.timeForShowingOverlay = m.eventModel.clockData.time
        m.type = m.eventModel.clockData.module
        m.timerShowPanel.control = "start"
    end if
end sub

sub hidingOverlay()
    if isInvalid(m.timeForHidingOverlay) then return
    m.timeForHidingOverlay -= 1
    m.overlayView.callFunc("configureSecondsLabel", m.timeForHidingOverlay)

    if m.timeForHidingOverlay = 0
        m.timeForHidingOverlay = invalid
        m.timerHidePanel.control = "stop"
        m.overlayView.callFunc("showPanel", false)
        m.top.setFocus(false)
        m.top.videoPlayer.setFocus(true)
    end if
end sub

sub showingOverlayWithInfoUser() 
    if m.top.videoPlayer.position > m.timeForShowingOverlay
        showingOverlay()
    end if
end sub

sub showingOverlay()
    m.timerHidePanel.control = "start"
    m.timerShowPanel.control = "stop"
    m.overlayView.eventInfo = m.eventModel 
end sub

