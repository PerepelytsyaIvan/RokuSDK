sub init()
    m.top.setFocus(true)
    m.videoPlayer = m.top.findNode("videoPlayer")
    m.questionLabel = m.top.findNode("questionLabel")
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
    m.overlayViewController = m.top.findNode("overlayViewController")
    m.overlayViewController.videoPlayer = m.videoPlayer
    m.overlayViewController.accountRoute = {"broadcasterName": "leonidtest", "channelId": "leonidpage"}
end sub
