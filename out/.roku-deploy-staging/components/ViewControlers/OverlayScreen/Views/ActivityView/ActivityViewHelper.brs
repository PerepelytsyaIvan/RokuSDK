sub initProperties()
    m.hidingTimer = configureTimer(1, true)
    m.showActivityTimer = configureTimer(0.5, false)
    m.showCollectionTimer = configureTimer(0.4, false)
    m.showTimeGroupTimer = configureTimer(0.4, false)
    m.translationInterpolator.addField("isShow", "boolean", false)
    m.hidingInterpolator.addField("isShow", "boolean", false)
    m.timeForHideView = 0
    m.isShowCollection = false
    m.isDataAnswer = false
end sub

sub initView()
    m.loadingIndicator = m.top.findNode("loadingProgress")

    m.activityContainerGroup = m.top.findNode("activityContainerGroup")
    m.activityLayout = m.top.findNode("activityLayout")

    m.timeGroup = m.top.findNode("timeGroup")
    m.scrollingArrowGroup = m.top.findNode("scrollingArrowGroup")

    m.backgroundActivity = m.top.findNode("backgroundActivity")
    m.logoActivity = m.top.findNode("logoActivity")

    m.questionLabel = m.top.findNode("questionLabel")
    m.timeLabel = m.top.findNode("timeLabel")
    m.unitTime = m.top.findNode("unitTime")
    m.wagerSummitedLabel = m.top.findNode("wagerSummitedLabel")

    m.collectionViewLeftButton = m.top.findNode("collectionViewLeftButton")
    m.collectionView = m.top.findNode("collectionView")

    m.separator = m.top.findNode("separator")
    m.separatorScrolling = m.top.findNode("separatorScrolling")
    m.scrollingArrow = m.top.findNode("scrollingArrow")

    m.translationAnimation = m.top.findNode("translationAnimation")
    m.translationInterpolator = m.top.findNode("translationInterpolator")

    m.hidingAnimation = m.top.findNode("hidingAnimation")
    m.hidingInterpolator = m.top.findNode("hidingInterpolator")

    m.hidingTimeInterpolator = m.top.findNode("hidingTimeInterpolator")
end sub

sub configureObservers()
    m.showActivityTimer.observeField("fire", "showActifityAfterTimer")
    m.showCollectionTimer.observeField("fire", "showCollectionAfterTimer")
    m.hidingTimer.observeField("fire", "changeTime")
    m.showTimeGroupTimer.observeField("fire", "showTimeGroupTimerChange")
    m.collectionView.observeField("item", "didSelectButton")
    m.collectionViewLeftButton.observeField("item", "didSelectButtonLeft")
    m.translationAnimation.observeField("state", "changeStateAnimation")
    m.top.observeField("focusedChild", "onChangeFocusedChild")
end sub

sub layoutViews()
    m.questionLabel.font = getBoldFont(getSize(30))
    m.questionLabel.width = 0

    if m.questionLabel.boundingRect().width > getSize(550) 
        boundsWidth = m.questionLabel.boundingRect().width / 2
        if boundsWidth < getSize(550)
            m.questionLabel.width = boundsWidth
        else
            m.questionLabel.width = getSize(550)
        end if
    else
        m.questionLabel.width = m.questionLabel.boundingRect().width
    end if

    if IsValid(m.top.dataSource) and m.top.dataSource.questiontype = "injectWiki" and not m.isShowAnswer
        m.separator.visible = false
        m.questionLabel.width = getSize(1300)
        m.scrollingArrowGroup.visible = false
    else
        m.separator.visible = true
    end if

    m.questionLabel.height = getSize(80)
    m.unitTime.height = m.timeLabel.boundingRect().height - 5
    m.activityContainerGroup.translation = getSizeMaskGroupWith([0, 1080])
    m.activityLayout.translation = getSizeMaskGroupWith([30, 50])
    m.backgroundActivity.width = getSize(1920)
    m.backgroundActivity.height = getSize(150)

    m.separator.width = getSize(2)
    m.separator.height = getSize(80)

    m.logoActivity.width = getSize(80)
    m.logoActivity.height = getSize(80)

    m.separatorScrolling.width = getSize(2)
    m.separatorScrolling.height = getSize(80)

    m.scrollingArrow.width = getSize(25)
    m.scrollingArrow.height = getSize(25)

    m.scrollingArrow.translation = [0, (m.separatorScrolling.height - m.scrollingArrow.height) / 2]
    m.separatorScrolling.translation = [(m.scrollingArrow.width - m.separatorScrolling.width) / 2, 0]
    m.scrollingArrowGroup.translation = [getSize(1550), m.activityLayout.translation[1]]
    m.collectionView.translation = [m.activityLayout.boundingRect().width + m.activityLayout.translation[0] + getSize(30), m.activityLayout.translation[1] + getSize(10)]
    m.collectionViewLeftButton.translation = [(getWidthScreen() - getSize(250)) + (getSize(250) - m.collectionViewLeftButton.localBoundingRect().width) / 2, getSize(112)]
end sub

sub layoutViewsAnswer(questionType)
    if questionType = "injectRating"
        activityBounding = m.activityLayout.boundingRect()
        translationX = activityBounding.width - activityBounding.x + ((getSize(1920) - activityBounding.width - activityBounding.x - getSize(250)  - m.collectionView.boundingRect().width) / 2)
        m.collectionView.translation = [translationX, m.activityLayout.translation[1] + getSize(20)]
        m.collectionView.widthLayoutView = 500
        m.collectionView.sizeMask = [maxWidth, getSize(80)]
    else
        maxWidth = getSize(1920) - m.activityLayout.boundingRect().width - m.activityLayout.translation[0] - getSize(410)
        m.collectionView.widthLayoutView = 3000
        m.collectionView.sizeMask = [maxWidth, getSize(80)]
    end if
end sub

sub configureCollectionFor(eventType)
    maxWidth = getSize(1920) - m.activityLayout.boundingRect().width - m.activityLayout.translation[0] - getSize(410)
    m.collectionView.widthLayoutView = 3000
    m.collectionView.sizeMask = [maxWidth, getSize(80)]

    if eventType = "injectRating"
        m.collectionView.itemSpacing = getSize(40)
        m.collectionView.focusImage = "pkg:/nil"
    else if eventType = "prediction"
        m.collectionView.itemSpacing = getSize(50)
        m.collectionView.focusImage = "pkg:/nil"
    else
        m.collectionView.itemSpacing = getSize(20)
        m.collectionView.focusImage = "pkg:/images/gradienFocusButton.9.png"
    end if
end sub

sub configureCollectionAnswerFor(eventType)
    if eventType = "injectRating"
        m.collectionView.itemSpacing = getSize(5)
        m.collectionView.focusImage = "pkg:/nil"
        m.collectionView.widthLayoutView = 1000
    else
        m.collectionView.itemSpacing = getSize(80)
        m.collectionView.focusImage = "pkg:/images/gradienFocusButton.9.png"
    end if
end sub

sub configureDesign()
    m.questionLabel.color = m.global.design.questionTextColor
    m.wagerSummitedLabel.color = m.global.design.questionTextColor
    m.logoActivity.uri = m.global.design.logoImage
    m.backgroundActivity.uri = m.global.design.backgrounImage
    m.timeLabel.font = getBoldFont(getSize(60))
    m.unitTime.font = getMediumFont(getSize(40))
    m.wagerSummitedLabel.font = getRegularFont(getSize(40))
end sub

sub configureLabel(seconds)
    hidingTime = gmdate(seconds)
    array = hidingTime.split("m")
    if array.count() = 2
        m.timeLabel.text = array[0] + "m"
        m.unitTime.text = array[1]
    else
        m.timeLabel.text = array[0]
        m.unitTime.text = "sec"
    end if
    m.timeGroup.translation = [(getSize(1920) - getSize(260)) + ((getSize(260) - m.timeGroup.localboundingRect().width) / 2), (m.timeGroup.localboundingRect().height - getSize(30)) / 2]
end sub

sub createQuizView(answers)
    if IsInvalid(m.quizeAnswerView) then m.quizeAnswerView = m.activityContainerGroup.createChild("QuizeAnswerView")
    m.quizeAnswerView.dataSource = m.top.dataSourceAnswer
    m.quizeAnswerView.translation = [m.activityLayout.boundingRect().width + m.activityLayout.translation[0] + getSize(30), m.activityLayout.translation[1] + getSize(10)]
    m.quizeAnswerView.id = "quizeAnswerView"
    m.quizeAnswerView.opacity = 0
end sub

sub createPredictionSubmitView(item)
    if IsInvalid(m.predicationSubmitView) then m.predicationSubmitView = m.activityContainerGroup.createChild("PredicationSubmitView")
    m.predicationSubmitView.opacity = 0
    m.predicationSubmitView.observeField("pressBack", "didSelectBackButton")
    m.predicationSubmitView.observeField("itemParam", "didSelectButtonSubmit")
    m.predicationSubmitView.dataSource = item
    boundingRect = m.predicationSubmitView.boundingRect()


    width = m.activityLayout.localBoundingRect().width
    maxWidth = (1920 - width - m.activityLayout.translation[0] - getSize(365))
    centerX = (maxWidth - boundingRect.width) / 2
    transaltionX = centerX + (width + m.activityLayout.translation[0])

    m.predicationSubmitView.translation = [transaltionX, m.activityLayout.translation[1]]
    m.predicationSubmitView.id = "predicationSubmitView"
    m.top.focusKey = 2
    m.previusFocusedNode = m.predicationSubmitView
end sub

sub configureWagerAnswer(item)
    m.wagerSummitedLabel.opacity = 0
    for each item in item.answers
        if item.answersending
            m.wagerSummitedLabel.text = item.text
        end if
    end for
    m.wagerSummitedLabel.height = m.activityLayout.boundingRect().height

    width = m.activityLayout.localBoundingRect().width
    maxWidth = (1920 - width + m.activityLayout.translation[0] - getSize(365))
    m.wagerSummitedLabel.width = maxWidth
    m.wagerSummitedLabel.translation = [width + m.activityLayout.translation[0], m.activityLayout.translation[1]]
    m.top.focusKey = 0
    m.previusFocusedNode = m.collectionViewLeftButton
end sub

sub getChildWidth() as object
    width = 0
    for i = 0 to m.activityLayout.getChildCount() - 1
        width += m.activityLayout.getChild(i).width
    end for

    for i = 0 to m.activityLayout.itemSpacings.count() - 1
        width += m.activityLayout.itemSpacings[i]
    end for

    return width
end sub

sub createPointsView(dataSource)
    if IsInvalid(m.levelsLabelView) then m.levelsLabelView = m.activityContainerGroup.createChild("LevelsLabelView") 
    m.levelsLabelView.id = "levelsLabelView"
    m.levelsLabelView.opacity = 0
    m.levelsLabelView.dataSource = dataSource
    m.levelsLabelView.translation = [(getSize(1920) - getSize(280)) + ((getSize(280) - m.levelsLabelView.localboundingRect().width) / 2), (m.levelsLabelView.localboundingRect().height - getSize(40)) / 2]
end sub

function showLoadingIndicator(show)
    activityLayoutBounding = m.activityLayout.boundingRect()
    m.loadingIndicator.imageWidth = getSize(50)
    startX = (getSize(1920) - activityLayoutBounding.width + activityLayoutBounding.x - getSize(250))
    m.loadingIndicator.translationLoader = [activityLayoutBounding.x + activityLayoutBounding.width + ((startX - m.loadingIndicator.imageWidth) / 2), activityLayoutBounding.x + getSize(430) + ((activityLayoutBounding.height - getSize(50)) / 2)]

    m.loadingIndicator.visible = show

    if show
        m.loadingIndicator.control = "start"
    else
        m.loadingIndicator.bEatKeyEvents = false
        m.loadingIndicator.control = "stop"
    end if
end function
