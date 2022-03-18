sub init()
    initView()
    initProperties()
    configureObservers()
    configureDesign()
end sub

sub configureDataSource()
    m.showCollectionTimer.duration = 0.4
    m.isShowAnswer = false
    m.hidingInterpolator.isShow = true
    m.isDataAnswer = false
    m.scrollingArrowGroup.visible = false

    if m.translationInterpolator.isShow 
        hideActivity()
        m.showActivityTimer.control = "start"
        return
    end if

    m.questionLabel.width = 0
    if m.top.dataSource.questiontype = "injectWiki"
        m.questionLabel.text = m.top.dataSource.content
    else
        m.questionLabel.text = m.top.dataSource.question
    end if

    if isValid(m.top.dataSource.answers)
        m.collectionView.visible = m.top.dataSource.answers.count() > 0
        m.collectionView.opacity = 1

        if IsValid(m.top.dataSource.answers) and m.top.dataSource.answers.count() > 0
            if isValid(m.top.dataSource)
                configureCollectionFor(m.top.dataSource.questionType)
                m.collectionView.dataSource = m.top.dataSource.answers
                m.collectionView.setFocus(true)
            end if
        else
            m.collectionViewLeftButton.setFocus(true)
        end if
    else
        m.collectionView.visible = false
        m.collectionView.opacity = 1
        m.collectionViewLeftButton.setFocus(true)
    end if

    dataSourceLeftButton = [{ "title": "Account", "itemComponent": "TextItemComponent" }, { "title": "Close", "itemComponent": "TextItemComponent" }]
    m.collectionViewLeftButton.dataSource = dataSourceLeftButton
    m.timeForHideView = m.top.dataSource.timeForHiding
    m.scrollingArrowGroup.visible = m.collectionView.sizeMask[0] < m.collectionView.boundingRect().width
   
    configureLabel(m.timeForHideView)
    layoutViews()
    showActivity()
end sub

sub configureAnswer()
    m.isShowAnswer = false
    m.hidingInterpolator.isShow = true
    m.isDataAnswer = true
    if m.translationInterpolator.isShow 
        hideActivity()
        m.showActivityTimer.control = "start"
        return
    end if

    m.questionLabel.text = m.top.dataAnswer.question

    if isValid(m.top.dataAnswer.answers)
        m.collectionView.visible = m.top.dataAnswer.answers.count() > 0
        m.collectionView.opacity = 1

        if IsValid(m.top.dataAnswer) and m.top.dataAnswer.answers.count() > 0
            if isValid(m.top.dataAnswer)
                configureCollectionAnswerFor(m.top.dataAnswer.questionType)
                m.top.dataSourceAnswer = m.top.dataAnswer
            end if
        end if
    end if

    dataSourceLeftButton = [{ "title": "Account", "itemComponent": "TextItemComponent" }, { "title": "Close", "itemComponent": "TextItemComponent" }]
    m.collectionViewLeftButton.dataSource = dataSourceLeftButton
    m.timeForHideView = m.top.dataAnswer.timeForHiding
    layoutViews()
    layoutViewsAnswer(m.top.dataAnswer.questionType)
    showActivity()
    m.isDataAnswer = false
end sub

sub configureAnswerDataSource(item = invalid)
    m.isShowAnswer = true
    m.hidingTimeInterpolator.key = [0,1]
    
    m.scrollingArrowGroup.visible = false

    if isValid(m.top.dataSourceAnswer)
        m.collectionView.visible = m.top.dataSourceAnswer.answers.count() > 0
    end if

    if m.isDataAnswer
        m.showCollectionTimer.duration = 0.01
        m.hidingAnimation.duration = 0.01
    else 
        m.showCollectionTimer.duration = 0.4
        m.hidingAnimation.duration = 0.3
    end if

    if isValid(m.top.dataSource) and m.top.dataSource.questiontype = "predictionWager"
        m.isShowAnswer = false
        m.collectionView.setFocus(true)
    end if

    if IsValid(m.top.dataSourceAnswer)
        createPointsView(m.top.dataSourceAnswer)
        m.collectionViewLeftButton.setFocus(true)
        m.hidingTimeInterpolator.fieldToInterp = m.levelsLabelView.id + ".opacity"

        if isValid(m.top.dataSourceAnswer.closepostinteraction) and m.top.dataSourceAnswer.closepostinteraction and isInvalid(m.item)
            m.timeForHideView = 6
        else if isValid(m.top.dataSourceAnswer.closepostinteraction) and not m.top.dataSourceAnswer.closepostinteraction and isInvalid(m.item)
            m.timeForHideView = 10000000
        end if
    end if

    if m.isShowCollection
        m.hidingInterpolator.fieldToInterp = m.collectionView.id + ".opacity"
        m.hidingTimeInterpolator.fieldToInterp = m.timeGroup.id + ".opacity"
        showCollectionView()
        m.isShowCollection = false
        return
    end if


    if isValid(m.item)
        m.activityContainerGroup.removeChild(m.predicationSubmitView)
        m.predicationSubmitView = invalid
        m.hidingTimeInterpolator.key = []
        createPredictionSubmitView(m.item)
 
        if m.hidingInterpolator.isShow 
            m.hidingTimeInterpolator.fieldToInterp = ""
            m.hidingInterpolator.fieldToInterp = m.collectionView.id + ".opacity"
            hideCollectionView()
            m.showCollectionTimer.control = "start"
            return
        end if

        m.hidingInterpolator.fieldToInterp = m.predicationSubmitView.id + ".opacity"
        if IsValid(m.levelsLabelView)
            m.hidingTimeInterpolator.fieldToInterp = ""
        end if
        showLoadingIndicator(false)
        showCollectionView()
        m.item = invalid
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

    if isValid(m.top.dataSourceAnswer) and m.top.dataSourceAnswer.questionType = "injectQuiz"
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
    layoutViewsAnswer(m.top.dataSourceAnswer.questionType)
    m.scrollingArrowGroup.visible = m.collectionView.sizeMask[0] < m.collectionView.boundingRect().width
    showCollectionView()
end sub

sub showActivity()
    m.hidingTimer.control = "start"
    m.translationInterpolator.keyValue = [m.activityContainerGroup.translation, [m.activityContainerGroup.translation[0], m.activityContainerGroup.translation[1] - m.backgroundActivity.height]]
    m.translationInterpolator.isShow = true
    m.translationAnimation.control = "start"
    m.hidingAnimation.control = "finish"
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
    if m.isDataAnswer
        configureAnswer()
    else
        configureDataSource()
    end if
end sub

sub showCollectionAfterTimer()
    m.showCollectionTimer.control = "stop"
    configureAnswerDataSource()
end sub

sub changeTime()
    if isInvalid(m.timeForHideView) then m.timeForHideView = 10
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
    if m.isShowAnswer then return
    if m.top.dataSource.questionType = "predictionWager"
        m.item = item
        configureAnswerDataSource(m.item)
        m.collectionView.setFocus(true)
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
    m.isShowAnswer = false
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

    if not press then return result

    if key = "left" and m.collectionViewLeftButton.hasFocus()
        if IsValid(m.predicationSubmitView) and m.predicationSubmitView.opacity = 1
            m.predicationSubmitView.setFocus(true)
        else
            maxWidth = getSize(1920) - m.activityLayout.boundingRect().width - m.activityLayout.translation[0] - getSize(360)

            if not m.isShowAnswer or m.collectionView.boundingRect().width > maxWidth
                if IsValid(m.top.dataSource) and m.top.dataSource.questiontype = "injectWiki" and m.questionLabel.width > 560
                    return true
                else if m.collectionView.opacity <> 0
                    m.collectionView.setFocus(true)
                end if
            end if
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