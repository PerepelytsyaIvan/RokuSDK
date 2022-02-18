sub init()
    m.contentNodeService = CreateObject("roSGNode", "ContentNodeService")
    dependencyConnectionViews()
    configureObservers()
end sub

sub dependencyConnectionViews()
    m.questionLabel = m.top.findNode("questionLabel")
    m.timeLabel = m.top.findNode("timeLabel")
    m.secondsLabel = m.top.findNode("secondsLabel")
    m.wagerLabel = m.top.findNode("wagerLabel")

    m.logo = m.top.findNode("logo")
    m.backgroundOverlay = m.top.findNode("backgroundOverlay")
    m.gradient = m.top.findNode("gradient")
    m.separator = m.top.findNode("separator")

    m.panelGroup = m.top.findNode("panel")
    m.rowListGroup = m.top.findNode("rowListGroup")

    m.layoutGroup = m.top.findNode("layoutGroup")
    m.quizGruop = m.top.findNode("quizGruop")
    m.collectionView = m.top.findNode("collectionView")
    m.collectionViewLeftButton = m.top.findNode("collectionViewLeftButton")

    m.translationAnimation = m.top.findNode("translationAnimation")
    m.translationGradientAnimation = m.top.findNode("translationGradientAnimation")
    m.panelInterpolator = m.top.findNode("panelInterpolator")
    m.videoInterpolator = m.top.findNode("videoInterpolator")
    m.gradientInterpolator = m.top.findNode("gradientInterpolator")
    m.rowListInterpolator = m.top.findNode("rowListInterpolator")
    m.listsInterpolator = m.top.findNode("listsInterpolator")
    m.collectionViewAnimation = m.top.findNode("collectionViewAnimation")
    m.collectionViewInterpolator = m.top.findNode("collectionViewInterpolator")
    m.collectionViewAnimation.observeField("state", "changeStateCollectionAnimation")

    m.focusable = false
    m.asShowPanel = false
    m.focusKey = 0
end sub

sub configureObservers()
    m.collectionViewLeftButton.observeField("item", "onItemSelectedLeftButton")
    m.collectionView.observeField("item", "didSelectItem")
end sub

sub onItemSelectedLeftButton(event)
    item = event.getData()
    if item.TITLE = "Close"
        m.top.videoPlayer.setFocus(true)
        showPanel(false)
    end if
end sub

sub didSelectItem(event)
    item = event.getData()

    if m.top.eventInfo.questiontype <> "predictionWager"
        m.top.selectedAnswer = item
    else
        showCollectionView(false, true)
        m.predicationSubmitView = m.rowListGroup.createChild("PredicationSubmitView")
        m.predicationSubmitView.observeField("pressBack", "didSelectBackButton")
        m.predicationSubmitView.observeField("itemParam", "didSelectButtonSubmit")

        m.predicationSubmitView.dataSource = item
        bounding = m.predicationSubmitView.boundingRect()
        m.predicationSubmitView.setFocus(true)
        maxWidth = 1920 - (m.separator.translation[0] + m.separator.width + 350)

        translationX = m.separator.translation[0] + ((maxWidth - bounding.width) / 2)
        m.predicationSubmitView.translation = [translationX, m.logo.translation[1] + ((m.logo.height - bounding.height) / 2)]
    end if
end sub

sub didSelectBackButton()
    hidePredictionSubmit()
    showCollectionView(true, true)
end sub

sub hidePredictionSubmit()
    if isValid(m.predicationSubmitView)
        m.predicationSubmitView.callFunc("showView", false)
        m.rowListGroup.removeChild(m.predicationSubmitView)
        m.predicationSubmitView = invalid
    end if
end sub

sub didSelectButtonSubmit(event)
    infoParam = event.getData()
    m.top.selectedAnswer = infoParam
end sub

sub changeStateCollectionAnimation(event)
    state = event.getData()
    if state = "stopped" or state = "paused"
        if isValid(m.predicationSubmitView)
            m.predicationSubmitView.callFunc("showView", true)
        end if
    end if
end sub

sub showCollectionView(asShow, animated)
    if asShow
        if animated
            if m.collectionViewInterpolator.keyValue[0] = 0.0 then return
            m.collectionViewInterpolator.keyValue = [0.0, 1.0]
            m.collectionViewAnimation.control = "start"
            m.collectionView.setFocus(true)
        end if
    else
        if animated
            if m.collectionViewInterpolator.keyValue[0] = 1.0 then return
            m.collectionViewInterpolator.keyValue = [1.0, 0.0]
            m.collectionViewAnimation.control = "start"
        end if
    end if
end sub

sub configureDesign(event)
    designModel = event.getData()
    m.questionLabel.color = m.global.design.questionTextColor
    m.timeLabel.color = m.global.design.questionTextColor
    m.secondsLabel.color = m.global.design.questionTextColor
    m.wagerLabel.color = m.global.design.questionTextColor

    m.logo.uri = m.global.design.logoImage
    m.backgroundOverlay.uri = m.global.design.backgrounImage
    m.separator.blendColor = m.global.design.buttonBackgroundColor

    m.wagerLabel.font = getMediumFont(30)
    m.questionLabel.font = getBoldFont(30)
    m.timeLabel.font = getBoldFont(40)
    m.secondsLabel.font = getMediumFont(30)
    m.questionLabel.translation = [(m.logo.translation[0] + m.logo.width) + 20, m.backgroundOverlay.translation[1] + (m.backgroundOverlay.height - 70) / 2]
    m.questionLabel.height = 80
end sub

function showPanel(asShow, model = invalid)
    configureAnimationFor(asShow)
    m.translationGradientAnimation.control = "finish"
    m.translationAnimation.control = "finish"
    m.playerAnimation.control = "finish"

    m.translationGradientAnimation.control = "start"
    m.translationAnimation.control = "start"
    m.playerAnimation.control = "start"
    m.asShowPanel = asShow
end function

sub configureAnimationFor(showView)
    if isInvalid(m.playerAnimation)
        configurePlayerAnimation()
    end if

    if showView
        m.panelInterpolator.keyValue = [m.panelGroup.translation, [m.panelGroup.translation[0], m.panelGroup.translation[1] - m.backgroundOverlay.height]]
        m.gradientInterpolator.keyValue = [[0, 200], [m.panelGroup.translation[0], -200]]
        m.listsInterpolator.keyValue = [[0, 1080], [0, 930]]
        m.playerInterpolatorHeight.keyValue = [m.top.videoPlayer.height, m.top.videoPlayer.height - m.backgroundOverlay.height]
    else
        m.playerInterpolatorHeight.keyValue = [m.top.videoPlayer.height, m.top.videoPlayer.height + m.backgroundOverlay.height]
        m.listsInterpolator.keyValue = [[0, 930], [0, 1080]]
        m.panelInterpolator.keyValue = [m.panelGroup.translation, [m.panelGroup.translation[0], (m.panelGroup.translation[1] + m.backgroundOverlay.height)]]
        m.gradientInterpolator.keyValue = [[0, -200], [m.panelGroup.translation[0], 200]]
    end if
end sub

function showAnswers(eventModel)
    m.layoutGroup.visible = false
    m.wagerLabel.callFunc("animate", false)
    if eventModel.questionType <> "injectQuiz" and eventModel.questionType <> "predictionWager"
        m.focusable = false
        getSpacingsItem(eventModel.questionType)
        boundingLabel = m.questionLabel.boundingRect()
        maxWidth = 1920 - (boundingLabel.x + boundingLabel.width + 360)
        m.collectionView.dataSource = eventModel.answers
        boundsCollectionView = m.collectionView.boundingRect()
        x = (maxWidth - boundsCollectionView.width) / 2
        m.collectionView.size = [x, m.collectionView.elements[0].height]
        if boundsCollectionView.width < maxWidth
            m.collectionView.translation = [((boundingLabel.width + boundingLabel.x) + 60) + x, m.logo.translation[1] + ((m.logo.height - m.collectionView.elements[0].height) / 2)]
        else
            m.focusable = true
            m.collectionView.translation = [((boundingLabel.width + boundingLabel.x) + 60), m.logo.translation[1] + ((m.logo.height - m.collectionView.elements[0].height) / 2)]
        end if
    end if

    if eventModel.questionType = "injectRating"
        showCollectionView(true, true)
    else if eventModel.questionType = "injectQuiz"
        showCollectionView(false, true)
        m.contentNodeService.callFunc("getConfigurationQuizeAnswer", eventModel, m.layoutGroup, m.questionLabel.boundingRect())
        m.layoutGroup.visible = true
    else if eventModel.questionType = "predictionWager"
        showCollectionView(false, true)
        configureWagerAnswer(eventModel)
    end if
    dataSourceLeftButton = [{ "title": "Close", "itemComponent": "TextItemComponent" }]
    m.collectionViewLeftButton.dataSource = dataSourceLeftButton
    m.collectionViewLeftButton.translation = [1735, 107]
    m.collectionViewLeftButton.setFocus(true)
end function

sub getSpacingsItem(typeEvent)
    if typeEvent = "injectRating"
        m.collectionView.horizontalSpacing = 5.0
    else
        m.collectionView.horizontalSpacing = 40
    end if
end sub

sub configureWagerAnswer(eventModel)
    hidePredictionSubmit()
    boundingLabel = m.questionLabel.boundingRect()
    maxWidth = 1920 - (boundingLabel.x + boundingLabel.width + 360)
    for each answer in eventModel.answers
        if answer.answersending
            m.wagerLabel.text = answer.text
        end if
    end for
    boundingRectLabel = m.wagerLabel.localBoundingRect()
    x = (maxWidth - boundingRectLabel.width) / 2
    m.wagerLabel.width = boundingRectLabel.width
    m.wagerLabel.translation = [((boundingLabel.width + boundingLabel.x) + 60) + x, m.logo.translation[1] + ((m.logo.height - boundingRectLabel.height) / 2)]
    m.wagerLabel.callFunc("animate", true)
end sub

sub onChnageStateAnimation(event)
    state = event.getData()
    if state = "stopped"
        m.playerAnimation.unobserveField("state")
        showPanel(true)
    end if
end sub

sub configureRowList(model)
    m.wagerLabel.callFunc("animate", false)
    if isInvalid(model) then return
    boundingLabel = m.questionLabel.boundingRect()
    m.collectionView.horizontalSpacing = 40
    m.collectionView.dataSource = model.answers
    collectionViewHeight = m.collectionView.elements[0].height
    maxWidth = 1920 - (boundingLabel.x + boundingLabel.width + 360)
    m.collectionView.size = [maxWidth, 100]
    m.collectionView.translation = [(boundingLabel.width + boundingLabel.x) + 60, m.logo.translation[1] + ((m.logo.height - collectionViewHeight) / 2)]
    m.collectionView.setFocus(true)
    dataSourceLeftButton = [{ "title": "Account", "itemComponent": "TextItemComponent" }, { "title": "Close", "itemComponent": "TextItemComponent" }]
    m.collectionViewLeftButton.horizontalSpacing = 15.0
    m.collectionViewLeftButton.dataSource = dataSourceLeftButton
    m.collectionViewLeftButton.translation = [1685, 107]
    if model.questionType = "injectRating"
        m.collectionView.focusImage = "nil"
    else
        m.collectionView.focusImage = "pkg:/images/focusSubmit.9.png"
    end if
    m.focusable = true
    m.layoutGroup.visible = false
    showCollectionView(true, true)
end sub

sub configureUI()
    eventInfo = m.top.eventInfo

    m.secondsLabel.text = "sec"
    m.questionLabel.text = eventInfo.question

    localBoundingRect = m.questionLabel.localBoundingRect()
    if localBoundingRect.width > 700
        m.questionLabel.width = localBoundingRect.width / 2
    else
        m.questionLabel.width = localBoundingRect.width
    end if

    m.separator.translation = [m.questionLabel.boundingRect().width + m.questionLabel.boundingRect().x + 30, m.logo.translation[1] - 10]

    if eventInfo.showAnswerview
        showAnswers(eventInfo)
        if not m.asShowPanel
            showPanel(true)
        end if
    else
        if m.asShowPanel
            showPanel(false)
        end if

        m.animationTimer = configureTimer(0.5, true)
        m.animationTimer.observeField("fire", "changeStateAnimationForConfigureRowList")

        if m.translationAnimation.state <> "stopped"
            m.animationTimer.control = "start"
        else
            configureRowList(eventInfo)
        end if

        if m.translationAnimation.state = "stopped"
            showPanel(true, m.top.eventInfo)
        else
            m.stateTimerAnimatiom = configureTimer(0.5, true)
            m.stateTimerAnimatiom.observeField("fire", "onChangeStateAnimation")
            m.stateTimerAnimatiom.control = "start"
        end if
    end if
end sub

sub changeStateAnimationForConfigureRowList()
    if m.translationAnimation.state = "stopped"
        configureRowList(m.top.eventInfo)
        m.animationTimer.control = "stop"
    end if
end sub

sub onChangeStateAnimation()
    if m.translationAnimation.state = "stopped"
        m.stateTimerAnimatiom.control = "stop"
        showPanel(true, m.top.eventInfo)
    end if
end sub

sub configureSecondsLabel(seconds)
    m.timeLabel.text = seconds.toStr()
    boundingRect = m.timeLabel.boundingRect()
    m.secondsLabel.height = boundingRect.height
    m.secondsLabel.translation = [boundingRect.x + boundingRect.width + 5, boundingRect.y - 3]
end sub

sub configurePlayerAnimation()
    parent = m.top.videoPlayer.getParent()
    m.playerAnimation = parent.createChild("Animation")
    m.playerAnimation.duration = 0.4
    m.playerAnimation.easeFunction = "linear"
    m.playerInterpolatorHeight = m.playerAnimation.createChild("FloatFieldInterpolator")
    m.playerInterpolatorHeight.fieldToInterp = m.top.videoPlayer.id + ".height"
    m.playerInterpolatorHeight.key = [0.0, 1.0]
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    result = false

    if not press then return result

    if key = "left"
        if m.collectionView.visible and m.collectionViewLeftButton.hasFocus() and m.focusable
            m.collectionView.setFocus(true)
            result = true
        else if m.layoutGroup.visible and m.collectionViewLeftButton.hasFocus() and m.focusable
            m.layoutGroup.setFocus(true)
            result = true
        end if
    else if key = "right"
        if m.collectionView.hasFocus()
            m.collectionViewLeftButton.setFocus(true)
            result = true
        else if m.layoutGroup.hasFocus() and m.focusKey < m.layoutGroup.GetChildCount() - 1
            m.focusKey = min(m.focusKey + 1, m.layoutGroup.GetChildCount() - 1)
            result = true
        else
            m.collectionViewLeftButton.setFocus(true)
        end if
    else if key = "OK" and m.layoutGroup.hasFocus()
        item = m.layoutGroup.GetChild(m.focusKey)
        m.top.selectedAnswer = { "answer": item.title }
    end if

    return result
end function