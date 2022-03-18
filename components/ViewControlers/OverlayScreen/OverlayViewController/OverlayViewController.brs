sub init()
    m.sideBarView = m.top.findNode("SideBarView")
    m.notificationGroup = m.top.findNode("notificationGroup")
    m.translationAnimation = m.top.findNode("translationAnimation")
    m.iterpolator = m.top.findNode("iterpolator")

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
end sub

sub onResponceQuizEvent(event)
    quizEvent = event.getData()
    if IsValid(m.isCloseQuiz) then quizEvent.close_post_interaction = m.isCloseQuiz
    m.eventModel = m.modelOverlay.callFunc("getEventInfoWithSocket", quizEvent, "injectQuiz", m.timeToStay)
    RegWrite(m.eventModel.idevent, FormatJson(m.eventModel))
    showActivitiViewWith(false)
end sub

sub connectSocket()
    m.socketClient = createObject("roSGNode", "WebSocketClient")
    m.socketClient.observeField("on_open", "connectedSocket")
    m.socketClient.observeField("on_message", "on_message")
    m.socketClient.open = "ws://ws-us2.pusher.com:80/app/9f45bc3adf59ff3ef36d?protocol=7&client=js&version=7.0.3&flash=false"
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
                        wikiView = m.notificationGroup.createChild("WikiView")
                        wikiView.observeField("removeWikiView", "handleRemoveWikiView")
                        if m.arrayNotificationView.count() > 0
                            oldNotifyView = m.arrayNotificationView[m.arrayNotificationView.count() - 1]
                            bounding = oldNotifyView.boundingRect()
                            wikiView.translation = [0, (oldNotifyView.translation[1] + bounding.height) + 10]
                        end if
                        wikiView.dataSource = m.eventModel
                        m.arrayNotificationView.push(wikiView)
                        wikiView.id = (m.arrayNotificationView.count() - 1).toStr()
                        configureAnimation()
                        return
                    end if
                end if

                if isInvalid(m.eventModel.questionType) then return
                if m.eventModel.questiontype = "injectProduct"
                    showActivitiProductView() 
                else
                    showActivitiViewWith(false)
                end if
                m.type = m.eventModel.questionType
            end if
        end if
    end if
end sub

sub configureAnimation()
    boundingRect = m.notificationGroup.boundingRect()
    if boundingRect.height > getSize(700) 
        m.animation = m.top.createChild("Animation")
        m.animation.observeField("state", "changeStateAnimationNotify")
        m.animation.duration = 0.2
        m.animation.easeFunction = "linear"
        for each wikiView in m.arrayNotificationView
            translationY = wikiView.translation[1] - wikiView.boundingRect().height - 10
            interpolator = getInterpolator(wikiView.id + ".translation", wikiView.translation, [wikiView.translation[0], translationY])
            m.animation.appendChild(interpolator)
            m.animation.delay = 0.01
        end for
        m.animation.control = "start"
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
    m.eventModelWithGetInfo = m.modelOverlay.callFunc("getEventInfo", infoApp)
    
    connectSocket()
    if m.eventModelWithGetInfo.isShowView
        if isValid(m.eventModelWithGetInfo.clockData)
            m.timeForShowingOverlay = m.eventModelWithGetInfo.clockData.time
            m.type = m.eventModelWithGetInfo.clockData.module
            m.timerShowPanel.control = "start"
        else if m.eventModelWithGetInfo.showAnswerView
            m.eventModel = m.eventModelWithGetInfo
            showingActivityTimer()
        end if
    end if
end sub

sub hidingOverlay()

end sub

sub hidingNotification()
    if isInvalid(m.timeForHidingNotification) then return
    m.timeForHidingNotification = invalid
    m.timerHideNotification.control = "stop"
end sub

sub showingOverlayWithInfoUser() 
    if m.top.videoPlayer.position > m.timeForShowingOverlay
        m.eventModel = m.eventModelWithGetInfo

        m.timerShowPanel.control = "stop"
        if m.eventModel.questiontype = "injectProduct"
            showActivitiProductView() 
        else
            showActivitiViewWith(false)
        end if
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
    m.activityProduct.setFocus(true)
end sub

sub showingActivityTimer()
    m.showActivityViewTimer.control = "stop"
    if isInvalid(m.isAnswer) then m.isAnswer = false

    if isInvalid(m.activityView)
        m.activityView = m.top.createChild("ActivityView")
        m.activityView.observeField("selectedAnswer", "onSelectAnswer")
    end if

    if m.isAnswer
        m.activityView.dataSourceAnswer = m.answers
    else if m.eventModel.showAnswerView
        m.activityView.dataAnswer = m.eventModel
    else
        m.activityView.dataSource = m.eventModel 
    end if

    m.activityView.setFocus(true)
end sub

sub handleRemoveWikiView(event)
    oldWikiView = event.getData()
    animationRemove(oldWikiView)
end sub

sub animationRemove(removedView)
    boundingGroup = m.notificationGroup.boundingRect()
    m.notificationGroup.removeChild(removedView)

    oldView = removedView

    m.animation = m.top.createChild("Animation")
    m.animation.duration = 0.2
    m.animation.delay = 0.2
    m.animation.easeFunction = "linear"
    m.animation.observeField("state", "changeStateAnimationNotify")

    if boundingGroup.height > getSize(700)
        for i = removedView.id.toInt() to 0 step - 1
            view = m.arrayNotificationView[i]
            newTranslation = oldView.translation[1] + (oldView.boundingRect().height - view.boundingRect().height)
            interpolator = getInterpolator(view.id + ".translation", view.translation, [view.translation[0], newTranslation])
            m.animation.appendChild(interpolator)
            oldView = view
        end for
    else
        for each view in m.arrayNotificationView
            if view.id.toInt() > removedView.id.toInt()
                newTranslation = view.translation[1] - oldView.boundingRect().height - 10
                interpolator = getInterpolator(view.id + ".translation", view.translation, [view.translation[0], newTranslation])
                m.animation.appendChild(interpolator)
                oldView = view
            end if
        end for
    end if

    m.arrayNotificationView.Delete(removedView.id.toInt())
    m.animation.control = "start"
end sub

sub changeStateAnimationNotify(event)
    state = event.getData()

    if state = "stopped"
        count = 0
        for each item in m.arrayNotificationView
            item.id = count.toStr()
            count++
        end for 
    end if
end sub

sub animationDown(oldWikiView)
    for index = m.arrayNotificationView.count() - 1 to 0 step - 1
        view = m.arrayNotificationView[index]
        newTranslation = view.translation[1] + (oldWikiView.translation[1] + oldWikiView.boundingRect().height)
        interpolator = getInterpolator(view.id + ".translation", view.translation, [view.translation[0], newTranslation])
        m.animation.appendChild(interpolator)
        m.animation.delay = 0.01
        oldWikiView = view
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
    
    if not press then return result

    if key = "up" and not m.sideBarView.hasFocus()
        m.sideBarView.setFocus(true)
        result = true
    else if key = "down"
        if isValid(m.activityView)
            m.activityView.setFocus(true)
        else if isValid(m.activityProduct)
            m.activityProduct.setFocus(true)
        else
            m.top.videoPlayer.setFocus(true)
        end if
        result = true
    end if
    
    if key = "up" and not m.sideBarView.hasFocus()
        m.sideBarView.setFocus(true)
        result = true
    end if

    return result
end function