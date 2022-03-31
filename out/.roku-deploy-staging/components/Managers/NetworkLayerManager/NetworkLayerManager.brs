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

function getAllAvatars(url, param)
    request = CreateObject("roSGNode", "URLRequest")
    request.url = url
    request.method = "POST"
    request.body = { "data": { "broadcasterName": param.broadcasterName, "channelId": param.channelId, "server_timestamp": 1640854661, "language": getLanguage() } }
    networkManager = CreateObject("roSGNode", "NetworkTask")
    networkManager.request = request
    networkManager.observeField("response", "onResponseAvatars")
    networkManager.control = "RUN"
end function

function getLeaders(url, param)
    userToken = RegRead("loginizationToken")

    request = CreateObject("roSGNode", "URLRequest")
    request.url = url
    request.method = "POST"
    
    ' request.body = { "data": { "channelId": param.channelId, "userToken": userToken, "broadcasterName": param.broadcasterName} }
    request.body = {"data":{"userToken":"6c8ffb0366c3f75ded53a8bec570f495","broadcasterName":"testings","channelId":"pagename"}}
    networkManager = CreateObject("roSGNode", "NetworkTask")
    networkManager.request = request
    networkManager.observeField("response", "onResponseLeaders")
    networkManager.control = "RUN"
end function

function getProducts(url, param)
    userToken = RegRead("loginizationToken")

    request = CreateObject("roSGNode", "URLRequest")
    request.url = url
    request.method = "POST"
    request.body = { "data": { "categoryId": param.categoryId, "broadcasterName": param.broadcasterName} }
    networkManager = CreateObject("roSGNode", "NetworkTask")
    networkManager.request = request
    networkManager.observeField("response", "onResponseProducts")
    networkManager.control = "RUN"
end function

sub onResponseAvatars(event)
    data = event.getData()
    m.top.avatarsResponce = data.arrayData
end sub

sub onResponseAnsver(event)
    data = event.getData()
    m.top.answerResponce = data.data
end sub

sub onResponseProducts(event)
    responce = event.getData()
    m.top.productsResponce = responce.arrayData
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

function buyProduct(url, param)
    userToken = RegRead("loginizationToken")

    request = CreateObject("roSGNode", "URLRequest")
    request.url = url
    request.method = "POST"

    request.body = {"data":{"productId": param.productId, "userPhoneNum":param.userPhoneNum, "userToken": userToken, "broadcasterName": param.broadcasterName, "language": getLanguage()}}
    networkManager = CreateObject("roSGNode", "NetworkTask")
    networkManager.request = request
    networkManager.observeField("response", "onResponseBuyProduct")
    networkManager.control = "RUN"
end function

sub onResponseBuyProduct(event)
    data = event.getData()
    m.top.buyItem = data.data
end sub

sub onResponseQuizEvent(event)
    data = event.getData()
    m.top.quizEventResponce = data.data.question
end sub

sub onResponseLeaders(event)
    responce = event.getData()
    m.top.leadersResponce = responce.data
end sub
