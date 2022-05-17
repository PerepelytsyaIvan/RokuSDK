sub init()
    m.containerView = m.top.findNode("containerView")
    m.background = m.top.findNode("background")
    m.questionLabel = m.top.findNode("questionLabel")
    m.translationAnimation = m.top.findNode("translationAnimation")
    m.iterpolator = m.top.findNode("iterpolator")
    m.progress = m.top.findNode("progress")
    m.wikiPoster = m.top.findNode("wikiPoster")
    m.iterpolatorWiki = m.top.findNode("iterpolatorWiki")
    m.wikiLayout = m.top.findNode("wikiLayout")
    m.posterWiki = m.top.findNode("posterWiki")
    m.background.observeField("translation", "onChangeTranslation")
    m.seconds = 0
end sub

sub configureDataSource()
    m.questionLabel.font = getRegularFont(getSize(25))
    m.questionLabel.text = m.top.dataSource.content
    if getImageWithName(m.top.dataSource.icon) <> getImageWithName("")
        m.posterWiki.uri = getImageWithName(m.top.dataSource.icon)
        m.questionLabel.translation = [getSize(35), getSize(20)]
    end if
    m.posterWiki.translation = [-getSize(25), -getSize(25)]
    setTextLayout()
    m.seconds = m.top.dataSource.timeforhiding + 1
    m.startSeconds = m.top.dataSource.timeforhiding + 1
    m.timer = configureTimer(0.1, true)
    m.timer.observeField("fire", "changeTimer")
    m.timer.control = "start"
    showNotification(true)
end sub

sub setTextLayout()
    maxTextWidth = getSize(240)
    textWidth = m.questionLabel.boundingRect().width
    m.questionLabel.width = textWidth

    if textWidth > maxTextWidth
        m.questionLabel.wrap = true
        m.questionLabel.width = maxTextWidth
        bounds = m.questionLabel.boundingRect()
        if bounds.height < getSize(500)
            m.background.height = bounds.height + getSize(40)
            m.questionLabel.height = bounds.height
        else
            m.background.height = getSize(500) + getSize(40)
            m.questionLabel.height = getSize(500)
        end if
    else
        m.questionLabel.wrap = false
        m.questionLabel.width = m.background.width - getSize(20)
        m.questionLabel.height = getSize(50)
        m.background.height = getSize(50) + getSize(40)
    end if

    m.questionLabel.horizAlign = "left"
    if m.posterWiki.uri <> "" and m.posterWiki.uri <> getImageWithName("") 
        m.questionLabel.width = m.questionLabel.width - getSize(20)
    end if
    m.wikiPoster.width = getSize(19)
    m.wikiPoster.height = getSize(22)
    m.wikiLayout.translation = [m.background.width - getSize(2), 0]
    m.wikiLayout.itemSpacings = [(m.background.height * 20) / getSize(100)]
    m.progress.translation = [0, m.background.height - getSize(2)]
end sub

sub changeTimer()
    m.seconds -= 0.1

    if m.seconds <= 0
        m.timer.control = "stop"
        m.translationAnimation.observeField("state", "changeStateAnimation")
        showNotification(false)
        return
    end if
    progressPercent = (m.seconds / m.startSeconds) * 100
    width = (progressPercent * (m.background.width - getSize(25))) / 100
    
    m.progress.width = width
    if m.questionLabel.height = getSize(50)
        m.progress.translation = [m.background.width - width - getSize(12.5), m.background.height - getSize(2)]
    else
        m.progress.translation = [m.background.width - width - getSize(12.5), m.background.height - getSize(2)]
    end if
end sub

sub showNotification(asShow)
    if asShow                             
        m.iterpolator.keyValue = [[getScreenWidth(), getSize(50)], [(getScreenWidth() - (m.background.width + getSize(50))), getSize(50)]]
    else
        m.iterpolator.keyValue = [m.iterpolator.keyValue[1], [getScreenWidth(), getSize(50)]]
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