sub init()
    m.top.functionName = "getInfo"
end sub

function getInfo()
    request = CreateObject("roSGNode", "URLRequest")
    request.url = "https://itg-dev4.inthegame.io/userApi/streamer/getInfo"
    request.method = "POST"
    locale = getLanguage()
    request.body = {"data":{"broadcasterName": m.top.accountRoute.broadcasterName, "channelId": m.top.accountRoute.channelId, "server_timestamp": 1640854661,"language": locale}}
    networkManager = CreateObject("roSGNode", "NetworkTask")
    networkManager.request = request
    networkManager.observeField("response", "responceInfo")
    networkManager.control = "RUN"
end function

function responceInfo(event)
    responce = event.getData()
    m.top.responce = responce
end function