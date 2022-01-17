sub init()
    m.top.setFocus(true)
    m.videoPlayer = m.top.findNode("videoPlayer")
    m.panel = m.top.findNode("panel")
    m.questionLabel = m.top.findNode("questionLabel")
    m.panelButtons = m.top.findNode("panelButtons")
    m.buttons = []
    configureVideoContentNode()
end sub

sub configureVideoContentNode()
    configureSDKPanel()
    content = CreateObject("roSGNode", "ContentNode")
    content.url = "https://media2.inthegame.io/uploads/20minutes_auto_demo_2.mp4"
    content.streamformat = "mp4"
    m.videoPlayer.content = content
    m.videoPlayer.control = "play"
end sub

sub configureSDKPanel()
    m.panel = m.top.findNode("panel")
    m.panel.translation = [360, 250]
    m.panel.videoPlayer = m.videoPlayer
    m.panel.accountRoute = {"broadcasterName": "leonidtest", "channelId": "leonidpage"}
    m.panel.backgroundUri = "pkg:/images/buttonBackground.png"
    m.panel.widthPanel = 700
    m.panel.heightPanel = 250
    m.panel.runSDK = true
end sub
