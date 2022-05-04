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

function getCheers(url, param)
    userToken = RegRead("loginizationToken")
    request = CreateObject("roSGNode", "URLRequest")
    request.url = url
    request.method = "POST"
    ' request.body = { "data": { "userToken": userToken, "broadcasterName": param.broadcasterName, "channelId": param.channelId} }
    request.body = { "data": { "userToken": "dd1c1a4bfa5c01f541035f35e08ac9bf", "broadcasterName": param.broadcasterName, "channelId": param.channelId} }
    networkManager = CreateObject("roSGNode", "NetworkTask")
    networkManager.request = request
    networkManager.observeField("response", "onResponceCheers")
    networkManager.control = "RUN"
end function

function sendSms(url, param)
    userToken = RegRead("loginizationToken")
    request = CreateObject("roSGNode", "URLRequest")
    request.url = url
    emojies = ""
    count = 0
    for each item in param.emoji
        emojies += item.shortcut + " "
    end for
    request.method = "POST"
    request.body = {"data": {"message": {"text": emojies, "channelId": param.channelId, "userName": m.global.userData.name, "userId": m.global.userData.id, "avatar": m.global.userData.thumbnail, "approved": true}, "userToken": userToken, "broadcasterName": param.broadcasterName}}
    networkManager = CreateObject("roSGNode", "NetworkTask")
    networkManager.request = request
    networkManager.observeField("response", "onResponceSms")
    networkManager.control = "RUN"
end function

function getChat(url, param)
    userToken = RegRead("loginizationToken")
    request = CreateObject("roSGNode", "URLRequest")
    request.url = url
    request.method = "POST"

    request.body = {"data": {"message": {"text": "gggg", "channelId": param.channelId, "userName": m.global.userData.name, "userId": m.global.userData.id, "avatar": m.global.userData.thumbnail, "approved": true}, "userToken": userToken, "broadcasterName": param.broadcasterName}}
    networkManager = CreateObject("roSGNode", "NetworkTask")
    networkManager.request = request
    networkManager.observeField("response", "onResponceSms")
    networkManager.control = "RUN"
end function

function sendUserUpdate(url, param)
    userData = m.global.userData
    userData.accountRoute = param.accountRoute
    request = CreateObject("roSGNode", "URLRequest")
    userData.amount_of_credits_won = m.global.userPoints
    userData.userLevel = m.global.userLevel
    userData.name = param.userData.name
    userData.email = param.userData.email
    if isValid(param.userData.avatar )
        userData.thumbnail = param.userData.avatar 
    end if

    request.url = url
    request.body = getUserUpdatesParam(userData)
    request.method = "POST"
    networkManager = CreateObject("roSGNode", "NetworkTask")
    networkManager.request = request
    networkManager.observeField("response", "onResponseUserUpdates")
    networkManager.control = "RUN"
end function

sub onResponseUserUpdates(event)
    data = event.getData()
    if isValid(data.data)
        saveInGlobal("userData", data.data)
        RegWrite("loginizationToken", data.data.token)
        RegWrite("userDataLoginization", FormatJson(data.data))
        if isValid(data.data.amount_of_credits_won) then saveInGlobal("userPoints", data.data.amount_of_credits_won)
        if isValid(data.data.userLevel) then saveInGlobal("userLevel", data.data.userLevel.level)
        m.top.isUpdateUserInfo = true
    else
        m.top.isUpdateUserInfo = false
    end if
end sub

sub onResponceSms(event)
    data = event.getData()
    ? data
end sub

sub onResponceCheers(event)
    data = event.getData()
    m.top.responceCheers = data.data
end sub

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

sub getUserUpdatesParam(userData) as object
    param = {"data": {
                "channelId": userData.accountRoute.channelId,
                "userToken": userData.token,
                "broadcasterName": userData.accountRoute.broadcasterName,
                "userDetails": {
                                    "name": userData.name,
                                    "email": userData.email, 
                                    "type": "registered",
                                    "thumbnail": userData.thumbnail,
                                    "broadcaster_id": userData.accountRoute.broadcasterName,
                                    "token": userData.token,
                                    "amount_of_credits": userData.amount_of_credits,
                                    "amount_of_credits_won": userData.amount_of_credits_won,
                                    "pages_credits": userData.pages_credits,
                                    "pages_expoints": userData.pages_expoints,
                                    "available_shouts": userData.available_shouts,
                                    "expirience_points": userData.expirience_points,
                                    "available_points": userData.available_points,
                                    "level": userData.level,
                                    "stats": userData.stats,
                                    "status": userData.status,
                                    "updated": userData.updated,
                                    "about": userData.about,
                                    "active": userData.active,
                                    "userBroadcasterForeignID": userData.userBroadcasterForeignID,
                                    "bonuses": userData.bonuses,
                                    "trivias": userData.trivias,
                                    "polls": userData.polls,
                                    "predictionsResults": userData.predictionsResults,
                                    "ratings": userData.ratings,
                                    "register_date": userData.register_date,
                                    "server_timestamp": userData.server_timestamp,
                                    "permissions": userData.permissions,
                                    "_id": userData._id,
                                    "id": userData.id,
                                    "pollAnswers": userData.pollAnswers,
                                    "triviaAnswers": userData.triviaAnswers,
                                    "userLevel": userData.userLevel,
                                    "channelId": userData.accountRoute.channelId 
                                }
                    }
            }

    return param
end sub