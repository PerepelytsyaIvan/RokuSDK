sub init()
    initView()
    initProperties()
    configureObservers()
    configureDesign()
end sub

sub configureDataSource()
    m.hidingInterpolator.isShow = true

    if m.translationInterpolator.isShow 
        hideActivity()
        m.showActivityTimer.control = "start"
        return
    end if
    m.questionLabel.text = m.top.dataSource.question

    if isValid(m.top.dataSource.answers)
        m.collectionView.visible = m.top.dataSource.answers.count() > 0
        m.collectionView.opacity = 1

        if IsValid(m.top.dataSource.answers) and m.top.dataSource.answers.count() > 0
            configureCollectionFor(m.top.dataSource.questionType)
            m.collectionView.dataSource = m.top.dataSource.answers
            m.collectionView.setFocus(true)
        end if
    end if

    dataSourceLeftButton = [{ "title": "Account", "itemComponent": "TextItemComponent" }, { "title": "Close", "itemComponent": "TextItemComponent" }]
    m.collectionViewLeftButton.dataSource = dataSourceLeftButton
    m.timeForHideView = m.top.dataSource.timeForHiding
    configureLabel(m.timeForHideView)
    layoutViews()
    showActivity()
end sub

sub configureAnswerDataSource(item = invalid)

    if IsValid(m.top.dataSourceAnswer)
        createPointsView(m.top.dataSourceAnswer)
        m.collectionViewLeftButton.setFocus(true)
        m.hidingTimeInterpolator.fieldToInterp = m.levelsLabelView.id + ".opacity"
    end if

    if m.isShowCollection
        m.hidingInterpolator.fieldToInterp = m.collectionView.id + ".opacity"
        m.hidingTimeInterpolator.fieldToInterp = m.timeGroup.id + ".opacity"
        showCollectionView()
        m.isShowCollection = false
        return
    end if

    if IsValid(m.top.dataSourceAnswer)
        if m.top.dataSourceAnswer.questionType = "predictionWager"
            configureWagerAnswer(m.top.dataSourceAnswer)

            if m.hidingInterpolator.isShow 
                m.hidingTimeInterpolator.fieldToInterp = m.timeGroup.id + ".opacity"
                hideCollectionView()
                m.showCollectionTimer.control = "start"
                return
            end if

            m.hidingTimeInterpolator.fieldToInterp = m.levelsLabelView.id + ".opacity"
            m.hidingInterpolator.fieldToInterp = m.wagerSummitedLabel.id + ".opacity"
            showLoadingIndicator(false)
            showCollectionView()
            return
        end if
    end if

    if isValid(m.item)
        m.activityContainerGroup.removeChild(m.predicationSubmitView)
        m.predicationSubmitView = invalid
        createPredictionSubmitView(m.item)

        if m.hidingInterpolator.isShow 
            m.hidingTimeInterpolator.fieldToInterp = m.timeGroup.id + ".opacity"
            m.hidingInterpolator.fieldToInterp = m.collectionView.id + ".opacity"
            hideCollectionView()
            m.showCollectionTimer.control = "start"
            return
        end if

        m.hidingInterpolator.fieldToInterp = m.predicationSubmitView.id + ".opacity"
        if IsValid(m.levelsLabelView)
            m.hidingTimeInterpolator.fieldToInterp = m.levelsLabelView.id + ".opacity"
        end if
        showLoadingIndicator(false)
        showCollectionView()
        m.item = invalid
        return
    end if

    if m.top.dataSourceAnswer.questionType = "injectQuiz"
        createQuizView(m.top.dataSourceAnswer.answers)

        if m.hidingInterpolator.isShow 
            m.hidingInterpolator.fieldToInterp = m.collectionView.id + ".opacity"
            m.hidingTimeInterpolator.fieldToInterp = m.timeGroup.id + ".opacity"
            hideCollectionView()
            m.showCollectionTimer.control = "start"
            return
        end if

        m.hidingInterpolator.fieldToInterp = m.quizeAnswerView.id + ".opacity"
        m.hidingTimeInterpolator.fieldToInterp = m.levelsLabelView.id + ".opacity"
        showLoadingIndicator(false)
        showCollectionView()
        return
    end if

    if m.hidingInterpolator.isShow 
        m.hidingInterpolator.fieldToInterp = m.collectionView.id + ".opacity"
        m.hidingTimeInterpolator.fieldToInterp = m.timeGroup.id + ".opacity"
        hideCollectionView()
        m.showCollectionTimer.control = "start"
        return
    end if

    configureCollectionAnswerFor(m.top.dataSourceAnswer.questionType)
    m.collectionView.dataSource = m.top.dataSourceAnswer.answers
    m.collectionViewLeftButton.setFocus(true)
    layoutViewsAnswer()
    showCollectionView()
end sub

sub showActivity()
    m.hidingTimer.control = "start"
    m.translationInterpolator.keyValue = [m.activityContainerGroup.translation, [m.activityContainerGroup.translation[0], m.activityContainerGroup.translation[1] - m.backgroundActivity.height]]
    m.translationInterpolator.isShow = true
    m.translationAnimation.control = "start"
end sub

sub hideActivity()
    m.translationInterpolator.keyValue = [m.activityContainerGroup.translation, [m.activityContainerGroup.translation[0], m.activityContainerGroup.translation[1] + m.backgroundActivity.height]]
    m.translationInterpolator.isShow = false
    m.translationAnimation.control = "start"
end sub

sub changeStateAnimation(event)
    state = event.getData()

    if state <> "stopped" then return

    if m.translationInterpolator.isShow then return
    if not m.hidingInterpolator.isShow then return
    hideCollectionView()
    m.hidingAnimation.control = "finish"
    m.hidingInterpolator.fieldToInterp = m.collectionView.id + ".opacity"
    m.hidingTimeInterpolator.fieldToInterp = m.timeGroup.id + ".opacity"
    showCollectionView()
    m.hidingAnimation.control = "finish"
end sub

sub hideCollectionView()
    showLoadingIndicator(true)
    m.hidingInterpolator.isShow = false
    m.hidingInterpolator.keyValue = [1, 0]
    if IsValid(m.levelsLabelView)
        m.hidingTimeInterpolator.keyValue = [1, 0]
    end if
    m.hidingAnimation.control = "start"
end sub

sub showCollectionView()
    m.hidingInterpolator.isShow = true
    m.hidingInterpolator.keyValue = [0, 1]
    if IsValid(m.levelsLabelView)
        m.hidingTimeInterpolator.keyValue = [0, 1]
    end if
    m.hidingAnimation.control = "start"
    showLoadingIndicator(false)
end sub

sub showActifityAfterTimer()
    m.translationInterpolator.isShow = false
    m.showActivityTimer.control = "stop"
    configureDataSource()
end sub

sub showCollectionAfterTimer()
    m.showCollectionTimer.control = "stop"
    configureAnswerDataSource()
end sub

sub changeTime()
    if m.timeForHideView > 0
        m.timeForHideView -= 1
        configureLabel(m.timeForHideView)
    else
        m.hidingTimer.control = "stop"
        hideActivity()
    end if
end sub

sub didSelectButton(event)
    item = event.getData()

    if m.top.dataSource.questionType = "predictionWager"
        m.item = item
        configureAnswerDataSource(m.item)
    else
        m.top.selectedAnswer = item
    end if
end sub

sub didSelectButtonLeft(event)
    item = event.getData()

    if item.title = "Close"
        hideActivity()
    end if
end sub

sub didSelectBackButton()
    m.isShowCollection = true
    hideCollectionView()
    m.collectionView.setFocus(true)
    m.showCollectionTimer.control = "start"
end sub

sub didSelectButtonSubmit(event)
    infoParam = event.getData()
    showLoadingIndicator(true)
    m.top.selectedAnswer = infoParam
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    result = false
    ? "function onKeyEvent("key"), "press") as boolean"
    if not press then return result

    if key = "left" and m.collectionViewLeftButton.hasFocus()
        if IsValid(m.predicationSubmitView) and m.predicationSubmitView.opacity = 1
            m.predicationSubmitView.setFocus(true)
        else
            m.collectionView.setFocus(true)
        end if
        result = true
    else if key = "right" and m.collectionView.hasFocus()
        m.collectionViewLeftButton.setFocus(true)
        result = true
    else if isValid(m.predicationSubmitView)
        if key = "right" and m.predicationSubmitView.opacity = 1
            m.collectionViewLeftButton.setFocus(true)
            result = true
        end if
    end if
    return result
end function