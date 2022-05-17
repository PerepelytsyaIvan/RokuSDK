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
    m.chatData = []
    saveInGlobal("chatData", m.chatData)
    configureObservers()
    m.notificationGroup.translation = [getSize(1500), getSize(30)]
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
    m.sideBarView.observeField("shopItem", "onSelectedShopItem")
    m.sideBarView.observeField("focusedActivity", "setFocusActivity")
end sub

sub configureFonts()
    saveInGlobal("fonts", m.top.fonts)
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

    if isValid(responce.answer)
        if isValid(responce.answer.total_points) then saveInGlobal("userPoints", responce.answer.total_points)
        if isValid(responce.answer.userLevel)
            level = responce.answer.userLevel.level
            if IsString(level) then level = level.toInt()
            if level > m.global.userLevel
                configureLevel(responce.answer.userLevel)
            end if
            saveInGlobal("userLevel", responce.answer.userLevel.level)
        end if
    end if

    RegWrite(eventModel.idevent, FormatJson(eventModel), "Activity")
    showActivitiViewWith(true, eventModel)
end sub

sub configureLevel(level)
    itemlevel = invalid
    if IsInvalid(m.global.infoApp.moderator_data[0]) then return
    for each item in m.global.infoApp.moderator_data[0].levelsDefinition
        levelDefinition = item.level
        level1 = level.level
        if IsString(item.level) then levelDefinition = item.level.toInt()
        if IsString(level.level) then level1 = level.level.toInt()
        if levelDefinition = level1
            itemlevel = item
        end if
    end for

    if isValid(itemlevel)
        text = m.global.localization.predictionsLevelUp + " " + levelDefinition.toStr() + " (" + itemlevel.name + "), " + m.global.localization.predictionsYouGotPoints.replace("{{ points }}", itemlevel.gift_points)
        event = { "content": text, icon: "", timeforhiding: 30 }
        configureWikiNotification(event)
    end if
end sub

sub onResponceQuizEvent(event)
    quizEvent = event.getData()
    if IsValid(m.isCloseQuiz) then quizEvent.close_post_interaction = m.isCloseQuiz

    m.eventModel = m.modelOverlay.callFunc("getEventInfoWithSocket", quizEvent, "injectQuiz", m.timeToStay)

    if isValid(m.oncePerUser)
        if m.oncePerUser and m.eventModel.showAnswerView then return
    end if

    m.eventModel.feedbackTime = convertStrToInt(m.feedbackTime)
    RegWrite(m.eventModel.idevent, FormatJson(m.eventModel))
    showActivitiViewWith(false)
end sub

sub connectSocket()
    m.socketClient = createObject("roSGNode", "WebSocketClient")
    m.socketClient.observeField("on_open", "connectedSocket")
    m.socketClient.observeField("on_message", "on_message")
    m.socketClient.open = "ws://ws-us2.pusher.com:80/app/94d23998f17b0f96663e?protocol=7&client=js&version=7.0.3&flash=false"
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
        if parseMessage.event = "injectAccount" or parseMessage.event = "injectChat" or parseMessage.event = "injectLeaderboard" or parseMessage.event = "injectShop" then return

        if parseMessage.event = "chatMessage"
            m.chatData.push(json)
            m.global.chatData = m.chatData
            return
        end if

        if parseMessage.event <> "pusher_internal:subscription_succeeded" and parseMessage.event <> "pusher:connection_established" and json.messageType <> "streamerInfo"
            m.isCloseQuiz = invalid
            isShowActivity = false

            if json.messageType = "initiateRefresh"
                registrationToken = RegRead("registrationToken")
                m.networkLayerManager.callFunc("loginUser", getLoginizationUrl(), m.top.accountRoute, registrationToken)
                return
            end if

            if isValid(json.messageType) and json.messageType = "pollWin"
                predictionNotifiction = m.notificationGroup.createChild("PredictionNotifiction")
                predictionNotifiction.observeField("removeWikiView", "handleRemoveWikiView")
                predictionNotifiction.dataSource = json
                m.arrayNotificationView.push(predictionNotifiction)
                predictionNotifiction.id = (m.arrayNotificationView.count() - 1).toStr()
                configureAnimation()
                return
            end if

            if IsValid(json.conditional)
                model = m.modelOverlay.callFunc("getEventInfoWithSocket", json)
                for each condition in json.conditional.conditions
                    jsonAnswer = RegRead(condition.id, "Activity")
                    if IsValid(jsonAnswer) and jsonAnswer <> ""
                        data = ParseJson(jsonAnswer)
                        for each answer in data.answers
                            if answer.answersending and answer.answer = condition.answer
                                isShowActivity = true
                            end if
                        end for
                    end if
                end for

                if not isShowActivity then return
            end if



            if json.messageType = "injectQuiz"
                m.oncePerUser = json.once_per_user
                m.timeToStay = json.timeToStay
                m.feedbackTime = convertStrToInt(json.feedbackTime)
                m.networkLayerManager.callFunc("getQuizEvent", getQuizUrl(json.id))
                m.isCloseQuiz = json.close_post_interaction
            else
                m.eventModel = m.modelOverlay.callFunc("getEventInfoWithSocket", json)
                if isValid(json.once_per_user) and json.once_per_user and m.eventModel.showAnswerView then return
                if m.eventModel.questionType = "injectWiki"
                    if m.eventModel.type = "notification"
                        configureWikiNotification(m.eventModel)
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

sub configureWikiNotification(eventModel)
    wikiView = m.notificationGroup.createChild("WikiView")
    wikiView.observeField("removeWikiView", "handleRemoveWikiView")
    wikiView.dataSource = eventModel
    m.arrayNotificationView.push(wikiView)
    wikiView.id = (m.arrayNotificationView.count() - 1).toStr()
    configureAnimation()
end sub

sub showNotificationPrediction(event)
    param = event.getData()
    if param.type = "zeroPoints"
        eventNoPrediction = { "content": m.global.localization.predictionsPointsNotAvailable, icon: "", timeforhiding: 30 }
    else
        eventNoPrediction = { "content": m.global.localization.predictionsPointsAvailable.replace("{{ points }}", m.global.userPoints.toStr()), icon: "", timeforhiding: 30 }
    end if
    configureWikiNotification(eventNoPrediction)
end sub

sub configureAnimation()
    boundingRect = m.notificationGroup.boundingRect()
    if boundingRect.height > getSize(700)
        translationY = getSize(700) - getSize(30) - boundingRect.height
        m.iterpolator.keyValue = [m.notificationGroup.translation, [m.notificationGroup.translation[0], translationY]]
        m.translationAnimation.control = "start"
    end if
end sub

sub configurationUser()
    m.top.videoPlayer.observeField("position", "onChangePositionVideo")

    registrationToken = RegRead("registrationToken")
    if isValid(m.top.accountRoute)
        if isInvalid(registrationToken)
            userBroadcasterForeignId = "none"
            if m.top.accountRoute.userBroadcasterForeignId <> "" then userBroadcasterForeignId = m.top.accountRoute.userBroadcasterForeignId 
            m.networkLayerManager.callFunc("registerUser", getRegistrationUrl(userBroadcasterForeignId), m.top.accountRoute)
        else
            m.networkLayerManager.callFunc("loginUser", getLoginizationUrl(), m.top.accountRoute, registrationToken)
        end if
    end if
end sub

sub registrationUser(event)
    registrationInfo = event.getData()
    RegWrite("registrationToken", registrationInfo.token)
    m.networkLayerManager.callFunc("loginUser", getLoginizationUrl(), m.top.accountRoute, registrationInfo.token)
end sub

sub loginizationUser(event)
    loginizationInfo = event.getData()
    resetLovalActivity(loginizationInfo)
    RegWrite("loginizationToken", loginizationInfo.token)
    RegWrite("userDataLoginization", FormatJson(loginizationInfo))
    if IsValid(m.top.accountRoute.userinitialname) and m.top.accountRoute.userinitialname <> "" and validationUsername(m.top.accountRoute.userinitialname)
        loginizationInfo.name = m.top.accountRoute.userinitialname
    end if
    saveInGlobal("userData", loginizationInfo)
    if isValid(loginizationInfo.amount_of_credits_won) then saveInGlobal("userPoints", loginizationInfo.amount_of_credits_won)
    if isValid(loginizationInfo.userLevel.level) then saveInGlobal("userLevel", loginizationInfo.userLevel.level)
    m.networkLayerManager.callFunc("getInfo", getInfoAppUrl(), m.top.accountRoute)
end sub

sub resetLovalActivity(loginizationInfo)
    allItems = []
    allItems.push(loginizationInfo.polls)
    allItems.push(loginizationInfo.trivias)
    allItems.push(loginizationInfo.ratings)
    allItems.push(loginizationInfo.predictionsResults)
    localItems = []
    for each item in allItems
        if item.count() > 0
            for each key in item.items()
                savingKey = key.key.split("_____")[0]
                if IsValid(RegRead(savingKey, "Activity"))
                    localItem = {}
                    localItem[savingKey] = RegRead(savingKey, "Activity")
                    localItems.push(localItem)
                end if
            end for
        end if
    end for

    RegDelete(invalid, "Activity")
    for each item in localItems
        for each key in item
            RegWrite(key, item[key], "Activity")
        end for
    end for
end sub

sub infoApplication(event)
    infoApp = event.getData()
    m.sideBarView.accountRoute = m.top.accountRoute
    desingModel = m.modelOverlay.callFunc("getDesignModel", infoApp)
    localizationModel = m.modelOverlay.callFunc("getLocaliztion", infoApp)
    saveInGlobal("localization", localizationModel)
    saveInGlobal("design", desingModel)
    saveInGlobal("infoApp", infoApp)
    m.sideBarView.callFunc("configureDataSource")

    if infoApp.live = 1
        connectSocket()
    end if

    if infoApp.clocks.count() = 0 then return
    m.eventModelsWithGetInfo = m.modelOverlay.callFunc("getEventInfo", infoApp)
    ? m.eventModelsWithGetInfo
end sub

sub onChangePositionVideo(event)
    position = event.getData()
    if isInvalid(m.eventModelsWithGetInfo) then return
    for each eventModel in m.eventModelsWithGetInfo
        myPosition = position.toStr().toInt()

        if eventModel.clockData.time = myPosition and IsInvalid(eventModel.isShowing) 
            eventModel.isShowing = true
            if IsValid(eventModel.type) and eventModel.type = "notification"
                configureWikiNotification(eventModel)
            else
                showActivityWithGetInfo(eventModel)
            end if
            return
        end if
    end for
end sub

sub showActivityWithGetInfo(eventModel)
    isShowActivity = false

    if isValid(eventModel.clockdata.conditional)
        for each condition in eventModel.clockdata.conditional.conditions
            jsonAnswer = RegRead(condition.id, "Activity")
            if IsValid(jsonAnswer) and jsonAnswer <> ""
                data = ParseJson(jsonAnswer)
                for each answer in data.answers
                    if answer.answersending and answer.answer = condition.answer
                        isShowActivity = true
                    end if
                end for
            end if
        end for

        if eventModel.clockdata.conditional.conditions.count() > 0
            if not isShowActivity then return
        end if
    end if

    if isValid(eventModel.clockdata) and isValid(eventModel.clockdata.once_per_user) and eventModel.clockdata.once_per_user and eventModel.showAnswerView then return

    if isValid(eventModel.clockData)
        m.type = eventModel.clockData.module
        showingOverlayWithInfoUser(eventModel)
    else if eventModel.showAnswerView
        m.eventModel = eventModel
        if isValid(eventModel.clockdata)
                if eventModel.showanswerview and eventModel.clockdata.once_per_user then return
        end if
        showingOverlayWithInfoUser(eventModel)
    end if
end sub

sub hidingNotification()
    if isInvalid(m.timeForHidingNotification) then return
    m.timeForHidingNotification = invalid
    m.timerHideNotification.control = "stop"
end sub

sub showingOverlayWithInfoUser(eventModel)
        m.eventModel = eventModel

        if m.eventModel.questiontype = "injectProduct"
            showActivitiProductView()
        else
            showActivitiViewWith(false)
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

sub onSelectedShopItem(event)
    item = event.getData()
    m.eventModel = m.modelOverlay.callFunc("getProduct", item)
    showActivitiProductView()
end sub

sub showingActivityProductTimer()
    m.showActivityProductTimer.control = "stop"
    if isInvalid(m.activityProduct) then m.activityProduct = m.top.createChild("ProductActivity")
    m.activityProduct.observeField("isOpenMenu", "openedMenu")
    m.activityProduct.observeField("didDisselectedFocus", "didDisselectedFocusActivity")
    m.activityProduct.observeField("isShowActivity", "onShowActivity")
    m.activityView = invalid
    m.activityProduct.videoPlayer = m.top.videoPlayer
    m.activityProduct.accountRoute = m.top.accountRoute
    m.activityProduct.dataSource = m.eventModel
    m.activityProduct.setFocus(true)
end sub

sub showingActivityTimer()
    m.showActivityViewTimer.control = "stop"
    if isInvalid(m.isAnswer) then m.isAnswer = false
    m.activityProduct = invalid

    if isInvalid(m.activityView)
        m.activityView = m.top.createChild("ActivityView")
        m.activityView.observeField("selectedAnswer", "onSelectAnswer")
        m.activityView.observeField("isOpenMenu", "openedMenu")
        m.activityView.observeField("didDisselectedFocus", "didDisselectedFocusActivity")
        m.activityView.observeField("isShowActivity", "onShowActivity")
        m.activityView.observeField("showNotificationPoints", "showNotificationPrediction")
    end if

    if m.isAnswer
        m.activityView.dataSourceAnswer = m.answers
    else if m.eventModel.showAnswerView
        m.activityView.dataAnswer = m.eventModel
    else
        m.activityView.dataSource = m.eventModel
    end if

    m.activityView.videoPlayer = m.top.videoPlayer
    if m.sideBarView.isActiveMenu
        m.sideBarView.focusKey = m.sideBarView.focusKey
    else
        m.activityView.setFocus(true)
    end if
end sub

sub didDisselectedFocusActivity()
    if m.sideBarView.isActiveMenu
        m.sideBarView.focusKey = m.sideBarView.focusKey
    end if
end sub

sub onShowActivity(event)
    isShow = event.getData()
    m.top.isShownActivity = isShow
    m.sideBarView.isShowActivity = isShow

    if IsValid(m.eventModel) and isValid(m.eventModel.clockdata) and m.eventModel.clockdata.isPause
        if isShow then m.top.videoPlayer.control = "pause"
        if not isShow then m.top.videoPlayer.control = "resume"
    end if
end sub

sub handleRemoveWikiView(event)
    oldWikiView = event.getData()
    animationRemove(oldWikiView)
end sub

sub animationRemove(removedView)
    m.notificationGroup.removeChild(removedView)
    boundingGroup = m.notificationGroup.boundingRect()
    if boundingGroup.height > getSize(700)
        translationY = getSize(700) - getSize(30) - boundingGroup.height
        m.notificationGroup.translation = [m.notificationGroup.translation[0], translationY]
    else
        m.iterpolator.keyValue = [m.notificationGroup.translation, [m.notificationGroup.translation[0], getSize(30)]]
        m.translationAnimation.control = "start"
    end if
end sub

sub animationDown(oldWikiView)
    for index = m.arrayNotificationView.count() - 1 to 0 step -1
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

sub openedMenu(event)
    isOpen = event.getData()
    if not isOpen then return
    m.sideBarView.isOpenMenu = isOpen
end sub

sub isActiveActivityView() as boolean
    if isInvalid(m.activityView) or IsValid(m.activityView) and not m.activityView.isShowActivity then return false
    return true
end sub

sub isActiveProductView() as boolean
    if isInvalid(m.activityProduct) or IsValid(m.activityProduct) and not m.activityProduct.isShowActivity then return false
    return true
end sub

sub setFocusMenu(event)
    focused = event.getData()
    if isValid(m.global.infoApp) and not m.global.infoApp.modules.logo then return

    if not focused
        m.top.videoPlayer.setFocus(true)
        return
    end if

    if m.sideBarView.isActiveMenu
        m.sideBarView.focusKey = m.sideBarView.focusKey
    else if not isActiveActivityView() and not isActiveProductView()
        m.sideBarView.focusKey = 0
    end if
end sub

sub setFocusActivity(event)
    isFocused = event.getData()
    if not isFocused then return

    if isActiveActivityView()
        m.activityView.focusKey = m.activityView.focusKey
    else if isActiveProductView()
        m.activityProduct.focusKey = m.activityProduct.focusKey
    else
        m.top.videoPlayer.setFocus(true)
    end if
end sub



function onKeyEvent(key as string, press as boolean) as boolean
    result = false
    ? "OverlayViewController  onKeyEvent(key -> "key", press -> "press") "
    if not press then return result

    if key = "up"
        if m.sideBarView.isActiveMenu
            m.sideBarView.focusKey = m.sideBarView.focusKey
            result = true
        else if not isActiveActivityView() and not isActiveProductView()
            m.sideBarView.focusKey = 0
            result = true
        end if
    else if key = "down"
        if isValid(m.activityProduct) and m.activityProduct.isShowActivity
            m.activityProduct.focusKey = m.activityProduct.focusKey
            result = true
        else if isValid(m.activityView) and m.activityView.isShowActivity
            m.activityView.focusKey = m.activityView.focusKey
            result = true
        else if not m.sideBarView.isActiveMenu
            m.top.videoPlayer.setFocus(true)
            result = true
        end if
    end if
    return result
end function