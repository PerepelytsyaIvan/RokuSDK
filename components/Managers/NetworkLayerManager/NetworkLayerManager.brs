function registerUser(url, param)
    request = CreateObject("roSGNode", "URLRequest")
    request.url = url
    request.method = "POST"
    request.body = {"data": param}
    networkManager = CreateObject("roSGNode", "NetworkTask")
    networkManager.request = request
    networkManager.observeField("response", "responceRegistration")
    networkManager.control = "RUN"
end function

sub responceRegistration(event)
    registration = event.getData()
    m.top.registrationResponce = registration.data
end sub

function loginUser(url, param, token)
    request = CreateObject("roSGNode", "URLRequest")
    request.url = url
    request.method = "POST"
    request.body = { "data": { "channelId": param.channelId, "userToken": token, "broadcasterName": param.broadcasterName } }
    networkManager = CreateObject("roSGNode", "NetworkTask")
    networkManager.request = request
    networkManager.observeField("response", "responceLoginization")
    networkManager.control = "RUN"
end function

sub responceLoginization(event)
    loginization = event.getData()
    m.top.loginizationResponce = loginization.data
end sub

function getInfo(url, param)
    userToken = RegRead("loginizationToken")

    request = CreateObject("roSGNode", "URLRequest")
    request.url = url
    request.method = "POST"
    request.body = { "data": { "broadcasterName": param.broadcasterName, "channelId": param.channelId, "server_timestamp": 1640854661, "language": getLanguage() } }
    networkManager = CreateObject("roSGNode", "NetworkTask")
    networkManager.request = request
    networkManager.observeField("response", "responceInfo")
    networkManager.control = "RUN"
end function

sub responceInfo(event)
    info = event.getData()
    m.top.infoResponce = info.data
end sub

function sendAnswer(url, param, answer, wager)
    userToken = RegRead("loginizationToken")

    request = CreateObject("roSGNode", "URLRequest")
    request.url = url
    request.method = "POST"
    if isValid(wager)
        request.body = { "data": { "channelId": param.channelId, "userToken": userToken, "broadcasterName": param.broadcasterName, "answer": answer,  "wager": wager} }
    else
        request.body = { "data": { "channelId": param.channelId, "userToken": userToken, "broadcasterName": param.broadcasterName, "answer": answer } }
    end if
    networkManager = CreateObject("roSGNode", "NetworkTask")
    networkManager.request = request
    networkManager.observeField("response", "onResponseAnsver")
    networkManager.control = "RUN"
end function

sub onResponseAnsver(event)
    data = event.getData()
    m.top.answerResponce = data.data
end sub

function getQuizEvent(url)
    request = CreateObject("roSGNode", "URLRequest")
    request.url = url
    request.method = "POST"
    networkManager = CreateObject("roSGNode", "NetworkTask")
    networkManager.request = request
    networkManager.observeField("response", "onResponseQuizEvent")
    networkManager.control = "RUN"
end function

sub onResponseQuizEvent(event)
    data = event.getData()
    m.top.quizEventResponce = data.data.question
end sub