sub init()
    m.top.setFocus(true)
    m.videoPlayer = m.top.findNode("videoPlayer")
    m.questionLabel = m.top.findNode("questionLabel")
    m.animation = m.top.findNode("animation")
    m.interpolator = m.top.findNode("interpolator")
end sub

sub configureVideoContentNode()
    configureSDKPanel()
    content = CreateObject("roSGNode", "ContentNode")
    content.url = m.top.videoUrl
    content.streamformat = "mp4"
    m.videoPlayer.height = getSize(1080)
    m.videoPlayer.width = getSize(1920)
    m.videoPlayer.content = content
    m.videoPlayer.control = "play"
    m.videoPlayer.setFocus(true)
end sub

sub configureSDKPanel()
    m.overlayViewController = m.top.findNode("overlayViewController")
    m.overlayViewController.fonts = invalid
    m.overlayViewController.fonts = [
        {
            type: "Bold"
            uri: "pkg:/<font path>.otf"
        }

        {
            type: "Medium"
            uri: "pkg:/<font path>.otf"
        }

        {
            type: "Regular"
            uri: "pkg:/<font path>.otf"
        }
    ]
    m.overlayViewController.videoPlayer = m.videoPlayer
    m.overlayViewController.observeField("setVideoFocus", "onSetVideoFocus")
    m.overlayViewController.observeField("isShownActivity", "onShowingActivity")
    accountRoute = m.top.accountRoute
    accountRoute.userBroadcasterForeignID = "jifdfddffd"
    accountRoute.userInitialName = "!@"
    m.overlayViewController.accountRoute = accountRoute
end sub

sub onShowingActivity(event)
    isShowing = event.getData()
    if isShowing
        m.interpolator.keyValue = [m.videoPlayer.height, getSize(1080) - getSize(140)]
        m.animation.control = "start"
    else
        m.interpolator.keyValue = [getSize(1080) - getSize(140), getSize(1080)]
        m.animation.control = "start"
    end if
end sub

sub onSetVideoFocus()
    m.videoPlayer.setFocus(true)
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    result = false
    ? "VideoPlayr onKeyEvent(key -> "key", press -> "press")"
    if not press then return result

    if not press then return result
    
    if key = "up"
        m.overlayViewController.focusedMenu = true
        result = false
    end if

    return result
end function