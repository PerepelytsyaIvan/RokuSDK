sub init()
    m.top.functionName = "getUserData"
end sub

sub getUserData()
    userToken = RegRead("registrationToken")
    if isValid(userToken)
        loginizationUser(userToken)
    else
        registerUser()
    end if
end sub

sub registerUser()
    request = CreateObject("roSGNode", "URLRequest") 
    request.url = "https://itg-dev4.inthegame.io/userApi/user/register"
    request.method = "POST"
    request.body = {"data": m.top.accountRoute}
    networkManager = CreateObject("roSGNode", "NetworkTask")
    networkManager.request = request
    networkManager.observeField("response", "responceRegistration")
    networkManager.control = "RUN"
end sub

sub responceRegistration(event)
    responce = event.getData()
    RegWrite("registrationToken", responce.data.token)
    loginizationUser(responce.data.token)
end sub

sub loginizationUser(token)
    request = CreateObject("roSGNode", "URLRequest")
    request.url = "https://itg-dev4.inthegame.io/userApi/user/login_by_token"
    request.method = "POST"
    request.body = {"data": {"channelId": m.top.accountRoute.channelId, "userToken":token, "broadcasterName": m.top.accountRoute.broadcasterName}}
    networkManager = CreateObject("roSGNode", "NetworkTask")
    networkManager.request = request
    networkManager.observeField("response", "responceLoginizationUser")
    networkManager.control = "RUN"
end sub

sub responceLoginizationUser(event)
    responce = event.getData()
    RegWrite("loginizationToken", responce.data.token)
    m.top.response = responce
end sub
