sub init()
    m.networkLayerManager = CreateObject("roSGNode", "NetworkLayerManager")

    m.channelList = m.top.findNode("channelList")
    getChannels()
    m.channelList.observeField("itemSelected", "onItemSelected")
    m.networkLayerManager.observeField("infoResponce", "infoApplication")
end sub

function getChannels()
    request = CreateObject("roSGNode", "URLRequest")
    request.url = "https://inthegameplatform.s3.us-west-2.amazonaws.com/generalFiles/list1.json"
    request.method = "GET"
    request.withBody = false
    networkManager = CreateObject("roSGNode", "NetworkTask")
    networkManager.request = request
    networkManager.observeField("response", "onResponceChannels")
    networkManager.control = "RUN"
end function

sub onItemSelected(event)
    index = event.getData()
    item = m.channelList.content.getChild(index).getChild(0).item
    m.accountRoute = {"broadcasterName": item.broadcasterName, "channelId": item.channelId}
    m.networkLayerManager.callFunc("getInfo", getInfoAppUrl(), m.accountRoute)
end sub

sub infoApplication(event)
    data = event.getData()
    videoPlayer = m.top.createChild("VideoPlayer")
    videoPlayer.videoUrl = data.stream_url
    videoPlayer.accountRoute = m.accountRoute
    videoPlayer.setFocus(true)
end sub

sub onResponceChannels(event)
    data = event.getData()

    content = CreateObject("roSGNode", "ContentNode")
    for each item in data.arrayData
        rowContent = content.createChild("ContentNode")
        elementContent = rowContent.createChild("ContentNode")
        elementContent.addField("item", "assocarray", false)
        elementContent.item = item
    end for
    m.channelList.content = content
    m.channelList.itemSize = [getSize(600), getSize(100)]
    m.channelList.rowItemSize = [[getSize(600), getSize(100)]]
    m.channelList.itemSpacing = [0, getSize(30)]
    m.channelList.rowItemSpacing = [[0, getSize(30)]]
    m.channelList.translation = [(getSize(1920) - m.channelList.itemSize[0]) / 2, getSize(50)]
    m.channelList.setFocus(true)
end sub
