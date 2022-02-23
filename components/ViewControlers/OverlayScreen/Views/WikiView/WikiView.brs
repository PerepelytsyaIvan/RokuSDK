sub init()
    m.containerView = m.top.findNode("containerView")
    m.background = m.top.findNode("background")
    m.questionLabel = m.top.findNode("questionLabel")
    m.translationAnimation = m.top.findNode("translationAnimation")
    m.iterpolator = m.top.findNode("iterpolator")
    m.progress = m.top.findNode("progress")
    m.seconds = 0
end sub

sub configureDataSource()
    m.questionLabel.font = getRegularFont(25)
    ' m.questionLabel.text = m.top.dataSource.question
    m.questionLabel.text = "000000000000000000000000000000000000000000000"
    setTextLayout()

    m.seconds = m.top.dataSource.timeforhiding
    m.timer = configureTimer(0.1, true)
    m.timer.observeField("fire", "changeTimer")
    m.timer.control = "start"
    showNotification(true)

end sub

sub setTextLayout()
    maxTextWidth = 240
    textWidth = m.questionLabel.boundingRect().width
    m.questionLabel.width = textWidth
    if textWidth > maxTextWidth
        m.questionLabel.wrap = true
        m.questionLabel.width = maxTextWidth
        m.questionLabel.height = 100
        m.background.height = 100
    else
        m.questionLabel.wrap = false
        m.questionLabel.width = m.background.width
        m.questionLabel.height = 50
        m.background.height = 50
    end if
end sub

sub changeTimer()
    m.seconds -= 0.1
    if m.seconds <= 0
        m.timer.control = "stop"
        m.translationAnimation.observeField("state", "changeStateAnimation")
        showNotification(false)
        return
    end if
    progressPercent = (m.seconds / m.top.dataSource.timeforhiding) * 100
    width = (progressPercent * m.background.width) / 100
    m.progress.width = width
    if m.questionLabel.height = 50
        m.progress.translation = [m.background.width - width, m.progress.translation[1]]
    else
        m.progress.translation = [m.background.width - width, 98]
    end if
end sub

sub showNotification(asShow)
    if asShow
        m.iterpolator.keyValue = [[1920, 50], [(1920 - (m.background.width + 50)), 50]]
    else
        m.iterpolator.keyValue = [m.iterpolator.keyValue[1], [1920, 50]]
    end if
    m.translationAnimation.control = "start"
end sub

sub changeStateAnimation(event)
    state = event.getData()

    if state = "stopped"
        m.translationAnimation.unobserveField("state")
        m.top.removeWikiView = m.top
    end if
end sub