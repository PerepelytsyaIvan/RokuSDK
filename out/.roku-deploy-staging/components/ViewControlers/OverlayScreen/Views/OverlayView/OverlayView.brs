sub init()
    initView()
    dependencyConnectionViews()
    configureObservers()
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

    if m.top.eventInfo.questionType = "injectProduct"
        personalArea = m.top.createChild("PersonalArea")
        personalArea.dataSource = m.top.eventInfo
    else if m.top.eventInfo.questiontype <> "predictionWager"
        showLoadingIndicator(true)
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
    showLoadingIndicator(true)
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
    m.loadingIndicator.loaderColor = m.global.design.buttonBackgroundColor
    m.questionLabel.font = getBoldFont(30)
    m.timeLabel.font = getBoldFont(40)
    m.secondsLabel.font = getMediumFont(30)
    m.questionLabel.translation = [(m.logo.translation[0] + m.logo.width) + 20, m.backgroundOverlay.translation[1] + (m.backgroundOverlay.height - 70) / 2]
    m.questionLabel.height = 80
end sub

function showPanel(asShow, model = invalid)
    if asShow = m.asShowPanel then return invalid
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
        showCollectionView(true, true)
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

    getPointsView(eventModel)
    dataSourceLeftButton = [{ "title": "Close", "itemComponent": "TextItemComponent" }]
    m.collectionViewLeftButton.dataSource = dataSourceLeftButton
    m.collectionViewLeftButton.translation = [1735, 107]
    m.collectionViewLeftButton.setFocus(true)
    showLoadingIndicator(false)
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

    for each answer in eventModel.answers
        if answer.answersending
            configureWagerLabel(answer.text)
        end if
    end for

end sub

sub configureWagerLabel(text)
    m.wagerLabel.text = text
    boundingLabel = m.questionLabel.boundingRect()
    maxWidth = 1920 - (boundingLabel.x + boundingLabel.width + 360)
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
    hidePredictionSubmit()
    if isInvalid(model) then return
    m.isWiki = false
    if model.questionType = "injectWiki"
        if model.type = "notification"
            m.isWiki = true
            wikiView = m.top.createChild("WikiView")
            wikiView.observeField("removeWikiView", "handleRemoveWikiView")
            if m.arrayNotificationView.count() > 0
                oldNotifyView = m.arrayNotificationView[m.arrayNotificationView.count() - 1]
                bounding = oldNotifyView.boundingRect()
                wikiView.translation = [0, (oldNotifyView.translation[1] + bounding.height) + 10]
            end if
            wikiView.dataSource = model
            m.arrayNotificationView.push(wikiView)
            wikiView.id = (m.arrayNotificationView.count() - 1).toStr()
            return
        else
            dataSourceLeftButton = [{ "title": "Close", "itemComponent": "TextItemComponent" }]
            showCollectionView(false, true)
            m.collectionViewLeftButton.translation = [1735, 107]
            m.collectionViewLeftButton.setFocus(true)
        end if
    else
        dataSourceLeftButton = [{ "title": "Account", "itemComponent": "TextItemComponent" }, { "title": "Close", "itemComponent": "TextItemComponent" }]
        m.collectionViewLeftButton.translation = [1685, 107]
        configureCollectionView(model)
    end if
    m.collectionViewLeftButton.horizontalSpacing = 15.0
    m.collectionViewLeftButton.dataSource = dataSourceLeftButton
    m.focusable = true
    m.layoutGroup.visible = false
end sub

sub handleRemoveWikiView(event)
    oldWikiView = event.getData()
    m.arrayNotificationView.Delete(oldWikiView.id.toInt())
    m.top.removeChild(oldWikiView)
    m.animation = m.top.createChild("Animation")
    m.animation.observeField("state", "changeStateAnimationNotify")
    m.animation.duration = 0.2
    m.animation.easeFunction = "linear"

    for each wikiView in m.arrayNotificationView
        if wikiView.id.toInt() > oldWikiView.id.toInt()
            wikiView.id = (wikiView.id.toInt() - 1).toStr()
            translationY = wikiView.translation[1] - wikiView.boundingRect().height - 10
            interpolator = getInterpolator(wikiView.id + ".translation", wikiView.translation, [wikiView.translation[0], translationY])
            m.animation.appendChild(interpolator)
            m.animation.delay = 0.01
        end if
    end for

    m.animation.control = "start"
end sub

sub changeStateAnimationNotify(event)
    state = event.getData()
    if state = "stopped"
        m.animation.removeChildrenIndex(0, 100)
    end if
end sub

sub getInterpolator(fieldToInterp, startValue, endValue) as object
    interpolator = CreateObject("roSGNode", "Vector2DFieldInterpolator")
    interpolator.fieldToInterp = fieldToInterp
    interpolator.key = [0.0, 1.0]
    interpolator.keyValue = [startValue, endValue]
    return interpolator
end sub

sub getPointsView(dataSource)
    m.timeLabel.visible = false
    m.secondsLabel.visible = false
    m.levelsLabelView = m.panelGroup.createChild("LevelsLabelView")
    m.levelsLabelView.dataSource = dataSource
    m.levelsLabelView.callFunc("animate", true)
    m.levelsLabelView.translation = [1920 - (290 - ((290 - m.levelsLabelView.boundingRect().width) / 2)), m.timeLabel.translation[1]]
end sub

sub configureCollectionView(model)
    boundingLabel = m.questionLabel.boundingRect()
    m.collectionView.horizontalSpacing = 40
    m.collectionView.dataSource = model.answers
    if isInvalid(model.answers) m.collectionView.dataSource = [model]
    collectionViewHeight = m.collectionView.elements[0].height
    maxWidth = 1920 - (boundingLabel.x + boundingLabel.width + 360)
    m.collectionView.size = [maxWidth, 100]
    m.collectionView.translation = [(boundingLabel.width + boundingLabel.x) + 60, m.logo.translation[1] + ((m.logo.height - collectionViewHeight) / 2)]
    m.collectionView.setFocus(true)

    if model.questionType = "injectRating"
        m.collectionView.focusImage = "nil"
    else
        m.collectionView.focusImage = "pkg:/images/focusSubmit.9.png"
    end if
    showCollectionView(true, true)
end sub

sub configureUI()
    eventInfo = m.top.eventInfo

    if eventInfo.questiontype = "injectProduct"
        if isInvalid(m.activity) then m.activity = m.top.createChild("ProductActivity")
        m.activity.dataSource = eventInfo
        return
    end if
    
    if eventInfo.type <> "notification"
        m.secondsLabel.text = "sec"
        if isValid(m.levelsLabelView) then m.levelsLabelView.callFunc("animate", false)

        m.questionLabel.text = eventInfo.question
        m.timeLabel.visible = true
        m.secondsLabel.visible = true
        localBoundingRect = m.questionLabel.boundingRect()
        if localBoundingRect.width > 700
            m.questionLabel.width = localBoundingRect.width / 2
        else
            m.questionLabel.width = localBoundingRect.width 
        end if

        m.separator.translation = [m.questionLabel.width + m.questionLabel.translation[0] + 30, m.logo.translation[1] - 10]
    end if
    
    if eventInfo.questionType = "injectWiki" and eventInfo.type = "notification"
        configureRowList(eventInfo)
        return
    end if

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

function showLoadingIndicator(show)
    boundingLabel = m.questionLabel.boundingRect()
    translationX = (1920 - ((boundingLabel.width + boundingLabel.x + 60 + 290) - 50)) / 2
    m.loadingIndicator.translationLoader = [boundingLabel.width + boundingLabel.x + translationX, (m.logo.translation[1] + ((m.logo.height - 50) / 2)) + 415]
    m.loadingIndicator.visible = show
    m.loadingIndicator.SetFocus(show)
    if show
        m.loadingIndicator.control = "start"
    else
        m.loadingIndicator.bEatKeyEvents = false
        m.loadingIndicator.control = "stop"
    end if
end function
