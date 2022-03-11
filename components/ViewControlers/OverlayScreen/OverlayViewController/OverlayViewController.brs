sub init()
    m.sideBarView = m.top.findNode("SideBarView")
    m.networkLayerManager = CreateObject("roSGNode", "NetworkLayerManager")
    m.modelOverlay = CreateObject("roSGNode", "ModelOverlay")

    m.timerHidePanel = configureTimer(1.0, true)

    m.timerShowPanel = configureTimer(1.0, true)
    m.timerHideNotification = configureTimer(1.0, true)
    m.showActivityViewTimer = configureTimer(0.5, false)
    m.showActivityProductTimer = configureTimer(0.5, false)
    m.arrayNotificationView = []
    configureObservers()
end sub

sub configureObservers()
    m.networkLayerManager.observeField("registrationResponce", "registrationUser")
    m.networkLayerManager.observeField("loginizationResponce", "loginizationUser")
    m.networkLayerManager.observeField("infoResponce", "infoApplication")
    m.networkLayerManager.observeField("answerResponce", "onResponceAnswer")
    m.networkLayerManager.observeField("quizEventResponce", "onResponceQuizEvent")

    m.timerHidePanel.observeField("fire", "hidingOverlay")

    m.showActivityViewTimer.observeField("fire", "showingActivityTimer")
    m.showActivityProductTimer.observeField("fire", "showingActivityProductTimer")

    m.timerShowPanel.observeField("fire", "showingOverlayWithInfoUser")
    m.timerHideNotification.observeField("fire", "hidingNotification")
end sub

sub onSelectAnswer(event)
    m.answer = event.getData()
    answer = m.answer.answer
    wager = invalid
    if isInvalid(answer) then answer = m.answer.title
    if IsValid(m.answer.wager) then wager = m.answer.wager

    m.networkLayerManager.callFunc("sendAnswer", getSendAnswerUrl(m.eventModel.questiontype, m.eventModel.idEvent), m.top.accountRoute, answer, wager)
end sub

sub onResponceAnswer(event)
    responce = event.getData()
    if m.eventModel.questionType = "injectRating"
        eventModel = m.modelOverlay.callFunc("getAnswerModelForRatings", m.eventModel, responce)
    else if m.eventModel.questionType = "predictionWager"
        eventModel = m.modelOverlay.callFunc("getAnswerWagerPrediction", m.eventModel, responce)
    else
        eventModel = m.modelOverlay.callFunc("getAnswers", m.answer, m.eventModel, responce)
    end if
    RegWrite(eventModel.idevent, FormatJson(eventModel))


    showActivitiViewWith(true, eventModel)

    m.timerHidePanel.control = "start"

    if isInvalid(eventModel.closePostInteraction) then return
    if eventModel.closePostInteraction
        m.timeForHidingOverlay = 6
    else
        m.timeForHidingOverlay = 10000000
    end if
end sub

sub onResponceQuizEvent(event)
    quizEvent = event.getData()
    if IsValid(m.isCloseQuiz) then quizEvent.close_post_interaction = m.isCloseQuiz
    m.eventModel = m.modelOverlay.callFunc("getEventInfoWithSocket", quizEvent, "injectQuiz", m.timeToStay)
    showActivitiViewWith(false)
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
            m.isCloseQuiz = invalid
            if json.messageType = "injectQuiz"
                m.timeToStay = json.timeToStay
                m.networkLayerManager.callFunc("getQuizEvent", getQuizUrl(json.id))
                m.isCloseQuiz = json.close_post_interaction
            else
                m.eventModel = m.modelOverlay.callFunc("getEventInfoWithSocket", json)
                if m.eventModel.questionType = "injectWiki"
                    if m.eventModel.type = "notification"
                        wikiView = m.top.createChild("WikiView")
                        wikiView.observeField("removeWikiView", "handleRemoveWikiView")
                        if m.arrayNotificationView.count() > 0
                            oldNotifyView = m.arrayNotificationView[m.arrayNotificationView.count() - 1]
                            bounding = oldNotifyView.boundingRect()
                            wikiView.translation = [0, (oldNotifyView.translation[1] + bounding.height) + 10]
                        end if
                        wikiView.dataSource = m.eventModel
                        m.arrayNotificationView.push(wikiView)
                        wikiView.id = (m.arrayNotificationView.count() - 1).toStr()
                        return
                    end if
                end if

                if isInvalid(m.eventModel.questionType) then return
                if m.eventModel.questiontype = "injectProduct"
                    showActivitiProductView()
                else
                    ' showActivitiViewWith(false)
                end if
                m.type = m.eventModel.questionType
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
    m.sideBarView.accountRoute = m.top.accountRoute
    desingModel = m.modelOverlay.callFunc("getDesignModel", infoApp)
    saveInGlobal("design", desingModel)
    m.eventModel = m.modelOverlay.callFunc("getEventInfo", infoApp)

    connectSocket()
    if m.eventModel.isShowView
        m.timeForHidingOverlay = m.eventModel.timeForHiding
        if isValid(m.eventModel.clockData)
            m.timeForShowingOverlay = m.eventModel.clockData.time
            m.type = m.eventModel.clockData.module
        else
            m.timeForShowingOverlay = 10
        end if
        m.timerShowPanel.control = "start"
    end if
end sub

sub hidingOverlay()
    ' if isInvalid(m.timeForHidingOverlay) then return
    ' m.timeForHidingOverlay -= 1
    ' ' m.overlayView.callFunc("configureSecondsLabel", m.timeForHidingOverlay)

    ' if m.timeForHidingOverlay = 0
    '     m.timeForHidingOverlay = invalid
    '     m.timerHidePanel.control = "stop"
    '     m.overlayView.callFunc("showPanel", false)
    '     m.top.setFocus(false)
    '     m.top.videoPlayer.setFocus(true)
    ' end if
end sub

sub hidingNotification()
    if isInvalid(m.timeForHidingNotification) then return
    m.timeForHidingNotification = invalid
    m.timerHideNotification.control = "stop"
end sub

sub showingOverlayWithInfoUser()
    if m.top.videoPlayer.position > m.timeForShowingOverlay
        m.timerShowPanel.control = "stop"
        ' showActivitiViewWith(false)
    end if
end sub

sub showActivitiViewWith(isAnswer, answers = invalid)
    m.answers = answers
    m.isAnswer = isAnswer

    if isValid(m.activityProduct)
        m.activityProduct.hideActivityView = not m.activityProduct.hideActivityView
        m.showActivityViewTimer.control = "start"
        return
    end if
    showingActivityTimer()
end sub

sub showActivitiProductView()
    if isValid(m.activityView)
        m.activityView.hideActivityView = not m.activityView.hideActivityView
        m.showActivityProductTimer.control = "start"
        return
    end if

    showingActivityProductTimer()
end sub

sub showingActivityProductTimer()
    m.showActivityProductTimer.control = "stop"
    if isInvalid(m.activityProduct) then m.activityProduct = m.top.createChild("ProductActivity")
    m.activityProduct.videoPlayer = m.top.videoPlayer
    m.activityProduct.dataSource = m.eventModel
end sub

sub showingActivityTimer()
    m.showActivityViewTimer.control = "stop"

    if isInvalid(m.activityView)
        m.activityView = m.top.createChild("ActivityView")
        m.activityView.observeField("selectedAnswer", "onSelectAnswer")
    end if

    if m.isAnswer
        m.activityView.dataSourceAnswer = m.answers
    else
        m.activityView.dataSource = m.eventModel
    end if
end sub

sub handleRemoveWikiView(event)
    oldWikiView = event.getData()
    m.arrayNotificationView.Delete(oldWikiView.id.toInt())
    m.top.removeChild(oldWikiView)
    m.animation = m.top.createChild("Animation")
    m.animation.observeField("state", "changeStateAnimationNotify")
    m.animation.duration = 0.2
    m.animation.easeFunction = "linear"

    for each wikiView in m.arrayNotificationView
        if wikiView.id.toInt() > oldWikiView.id.toInt()
            wikiView.id = (wikiView.id.toInt() - 1).toStr()
            translationY = wikiView.translation[1] - wikiView.boundingRect().height - 10
            interpolator = getInterpolator(wikiView.id + ".translation", wikiView.translation, [wikiView.translation[0], translationY])
            m.animation.appendChild(interpolator)
            m.animation.delay = 0.01
        end if
    end for

    m.animation.control = "start"
end sub

sub getInterpolator(fieldToInterp, startValue, endValue) as object
    interpolator = CreateObject("roSGNode", "Vector2DFieldInterpolator")
    interpolator.fieldToInterp = fieldToInterp
    interpolator.key = [0.0, 1.0]
    interpolator.keyValue = [startValue, endValue]
    return interpolator
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    result = false
    ? " Overlay function onKeyEvent("key" as string, "press" as boolean) as boolean"
    if key = "up" and not m.sideBarView.hasFocus()
        m.sideBarView.setFocus(true)
        result = true
    end if

    if not press then return result

    if key = "up" and not m.sideBarView.hasFocus()
        m.sideBarView.setFocus(true)
        result = true
    else if key = "down"
        if isValid(m.activityView)
            m.activityView.setFocus(m.activityView.hideActivityView)
        else if isValid(m.activityProduct)
            m.activityProduct.setFocus(m.activityProduct.hideActivityView)
        else
            m.top.videoPlayer.setFocus(true)
        end if
        result = true
    end if
    return result
end function