sub initView()
    m.contentNodeService = CreateObject("roSGNode", "ContentNodeService")

    m.questionLabel = m.top.findNode("questionLabel")
    m.timeLabel = m.top.findNode("timeLabel")
    m.secLabel = m.top.findNode("secLabel")

    m.logoPoster = m.top.findNode("logoPoster")
    m.backgroundPanel = m.top.findNode("backgroundPanel")
    m.gradientPanel = m.top.findNode("gradientPanel")
    m.separatorPoster = m.top.findNode("separatorPoster")

    m.panelGroup = m.top.findNode("panel")
    m.loyoutGroup = m.top.findNode("loyoutGroup")
    m.rowListGroup = m.top.findNode("rowListGroup")

    m.rowList = m.top.findNode("rowList")
    m.rowListLeftButton = m.top.findNode("rowListLeftButton")

    m.rowListAnimation = m.top.findNode("rowListAnimation")
    m.translationAnimation = m.top.findNode("translationAnimation")
    m.translationGradientAnimation = m.top.findNode("translationGradientAnimation")
    m.panelInterpolator = m.top.findNode("panelInterpolator")
    m.videoInterpolator = m.top.findNode("videoInterpolator")
    m.gradientInterpolator = m.top.findNode("gradientInterpolator")
    m.rowListInterpolator = m.top.findNode("rowListInterpolator")
    m.listsInterpolator = m.top.findNode("listsInterpolator")

    m.timerHidePanel = configureTimer(1.0, true)
    m.timerShowPanel = configureTimer(1.0, true)

    configureObservers()
end sub

sub configureObservers()
    m.rowList.observeField("itemSelected", "onItemSelected")
    m.rowListLeftButton.observeField("itemSelected", "onItemSelectedLeftButton")
    m.timerHidePanel.observeField("fire", "hidePanel")
    m.timerShowPanel.observeField("fire", "showPanel")
end sub

sub configureUI(design)
    m.backgroundPanel.uri = getImageWithName(design.backgroundImage)
    m.logoPoster.uri = getImageWithName(design.backgroundLogo)

    m.questionLabel.color = design.textColor
    m.rowList.focusBitmapBlendColor = design.backgroundButton
    m.rowListLeftButton.focusBitmapBlendColor = design.backgroundButton
    m.separatorPoster.blendColor = design.backgroundButton
    m.timeLabel.color = design.textColor
    m.secLabel.color = design.textColor
    m.separatorPoster.height = m.logoPoster.height - 20
    m.asShowPanel = false

    buttons = ["Account", "Close"]
    m.contentNodeService.callFunc("getConfigurationForLeftButton", buttons, m.rowListLeftButton)
    configureLabelsFont()
    configurePlayerAnimation()
end sub

sub showBottomPanel(asShow)

    if asShow = m.asShowPanel
        m.asShowPanel = asShow
        m.playerAnimation.observeField("state", "onChnageStateAnimation")
        showBottomPanel(false)
        return
    end if

    if asShow   
        m.timerHidePanel.control = "start"
        m.timerShowPanel.control = "stop"
    end if

    if asShow
        configureText()
        m.panelInterpolator.keyValue = [m.panelGroup.translation, [m.panelGroup.translation[0], (m.panelGroup.translation[1] - m.backgroundPanel.height) - 15]]
        m.gradientInterpolator.keyValue = [[0, 200], [m.panelGroup.translation[0], -200]]
        m.listsInterpolator.keyValue = [[0, 1080], [0, 930]]
        m.playerInterpolatorHeight.keyValue = [m.top.videoPlayer.height, m.top.videoPlayer.height - 133]
    else
        m.playerInterpolatorHeight.keyValue = [m.top.videoPlayer.height, m.top.videoPlayer.height + 133]
        m.listsInterpolator.keyValue = [[0, 930], [0, 1080]]
        m.panelInterpolator.keyValue = [m.panelGroup.translation, [m.panelGroup.translation[0], (m.panelGroup.translation[1] + m.backgroundPanel.height) + 15]]
        m.gradientInterpolator.keyValue = [[0, -200], [m.panelGroup.translation[0], 200]]
    end if

    m.translationGradientAnimation.control = "start"
    m.translationAnimation.control = "start"
    m.playerAnimation.control = "start"
    m.asShowPanel = asShow
end sub

sub onChnageStateAnimation(event)
    state = event.getData()
    if state = "stopped"
        m.playerAnimation.unobserveField("state")
        showBottomPanel(true)
    end if
end sub

sub configureText()
    m.buttonsTitle = []
    for each item in m.item.answers
        m.buttonsTitle.push(item.answer)
    end for
    m.secLabel.text = "sec"
    m.questionLabel.text = m.item.question
    m.separatorPoster.translation = [m.questionLabel.boundingRect().width + 20 + m.questionLabel.boundingRect().x, m.logoPoster.translation[1] + 10]
    setupPanelButton()
end sub

sub configurePlayerAnimation()
    parent = m.top.videoPlayer.getParent()
    m.playerAnimation = parent.createChild("Animation")
    m.playerAnimation.duration = 0.4
    m.playerAnimation.easeFunction = "linear"
    m.playerInterpolatorHeight = m.playerAnimation.createChild("FloatFieldInterpolator")
    m.playerInterpolatorHeight.fieldToInterp = m.top.videoPlayer.id + ".height"
    m.playerInterpolatorHeight.key= [0.0, 1.0]
end sub

sub configureLabelsFont()
    m.questionLabel.font = getBoldFont(30)
    m.timeLabel.font = getBoldFont(40)
    m.secLabel.font = getMediumFont(30)
end sub 

sub configureSecondsLabel(seconds)
    m.timeLabel.text = seconds.toStr() 
    boundingRect = m.timeLabel.boundingRect()
    m.secLabel.height = boundingRect.height
    m.secLabel.translation = [boundingRect.x + boundingRect.width + 5, boundingRect.y - 3]
end sub

sub layoutSubviews()
    m.backgroundPanel.width = 1920
    m.questionLabel.translation = [(m.logoPoster.translation[0] + m.logoPoster.width) + 20, m.logoPoster.translation[1]]
    m.questionLabel.height = m.logoPoster.height
    m.rowList.itemSize = [700, 35]
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    ? ">>> VideoPanel: onKeyEvent("key", "press")"
    result = false
    if not press then return result
    if key = "left"
        if m.rowListLeftButton.hasFocus()
            m.rowList.setFocus(true)
        end if
    else if key = "right"
        if m.rowList.hasFocus()
            m.rowListLeftButton.setFocus(true)
        end if
    end if
    return result
end function
