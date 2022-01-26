sub init()
    initView()
    m.buttonsTitle = []
    layoutSubviews()
    m.previusPollId = ""
end sub

sub setupSDK()
    if m.top.runSDK
        m.userServise = CreateObject("roSGNode", "UserService")
        m.userServise.accountRoute = m.top.accountRoute
        m.userServise.observeField("response", "responseUserData")
        m.userServise.control = "RUN"
        m.top.videoPlayer.observeField("state", "onChangeStateVideoPlayer")
    end if
end sub

sub showPanel()
    if m.top.videoPlayer.position > m.clock.time
        showBottomPanel(true)
    end if
end sub

sub hidePanel()
    if not isValid(m.hideTimer)
        m.hideTimer = m.clock.timeToStay
    end if

    m.hideTimer -= 1
    configureSecondsLabel(m.hideTimer)
    if m.hideTimer = 0
        m.hideTimer = invalid
        m.timerHidePanel.control = "stop"
        showBottomPanel(false)
        m.top.setFocus(false)
        m.top.videoPlayer.setFocus(true)
    end if
end sub

sub setupPanelButton()
    m.contentNodeService.callFunc("getConfigurationForButtons", m.buttonsTitle, m.rowList, {translation: m.logoPoster.translation, height: m.logoPoster.height})
end sub

sub onItemSelected(event)
    m.rowListInterpolator.keyValue = [[700, 35], [0, 35]]
    m.rowListAnimation.control = "start"

    index = m.rowList.rowItemSelected[1]
    userToken = RegRead("loginizationToken")
    answer = m.item.answers[index].answer
    m.answer = m.item.answers[index]
   
    request = CreateObject("roSGNode", "URLRequest") 
    request.url = "https://itg-dev4.inthegame.io/userApi/poll/answer_new/" + m.item.id
    request.method = "POST" 
    request.body = {"data": {"channelId": m.top.accountRoute.channelId, "userToken": userToken, "broadcasterName": m.top.accountRoute.broadcasterName, "answer": answer}}
    networkManager = CreateObject("roSGNode", "NetworkTask")
    networkManager.request = request
    networkManager.observeField("response", "onResponseAnsver")
    networkManager.control = "RUN"
end sub

sub onResponseAnsver(event)
    response = event.getData()

    totals = 0
    arrayAnswers = []

    m.item.answers[m.rowList.rowItemSelected[1]].totals += 1
    for each answer in m.item.answers
        totals += answer.totals
    end for
    

    for each answer in m.item.answers
        if m.answer.answer = answer.answer
            answer.answerSending = m.answer.answer = answer.answer
            answer.totals += 1
        end if

        answer.percent = (answer.totals / totals) * 100
    end for
    configureContentNodeWithAnswers()
end sub

sub onChangeStateVideoPlayer(event)
    state = event.getData()
    if state = "paused" or state = "stopped" or state = "finished"
        m.timerShowPanel.control = "stop"
    else if state = "playing"
    end if
end sub

sub configureContentNodeWithAnswers()
    m.contentNodeService.callFunc("getAnswersContentWith", m.item, m.rowList)
    m.rowListInterpolator.keyValue = [[0, 35 + 25], [700, 35 + 25]]
    m.rowListAnimation.control = "start"
    m.hideTimer = 5
    m.timerHidePanel.control = "start"
end sub

sub onItemSelectedLeftButton(event)
    index = m.rowListLeftButton.rowItemSelected[1]

    if index = 1
        showBottomPanel(false)
        m.top.setFocus(false)
        m.top.videoPlayer.setFocus(true)
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
    m.hideTimer = m.clock.timeToStay
    configureSecondsLabel(m.hideTimer)
    connectSocket()
    configureUI(responce.data.designs[5])
    m.timerShowPanel.control = "start"
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
        if parseMessage.event = "injectPoll" and m.previusPollId <> json.poll.id
            m.previusPollId = json.poll.id
            m.item = json.poll
            m.clock.timeToStay = json.timeToStay
            m.clock.time = (json.starting_time / 1000)
            m.questionLabel.text = m.item.question
            m.hideTimer = m.clock.timeToStay
            configureSecondsLabel(m.hideTimer)
            showBottomPanel(true)
        end if
    end if
end sub
