sub initView()
    m.contentNodeService = CreateObject("roSGNode", "ContentNodeService")

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
end sub

sub configureObservers()
    m.collectionViewAnimation.observeField("state", "changeStateCollectionAnimation")
    m.collectionViewLeftButton.observeField("item", "onItemSelectedLeftButton")
    m.collectionView.observeField("item", "didSelectItem")
end sub

sub dependencyConnectionViews()
    m.focusable = false
    m.asShowPanel = false
    m.focusKey = 0
    m.arrayNotificationView = []
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    result = false

    if not press then return result

    if key = "left"
        if m.collectionView.visible and m.collectionViewLeftButton.hasFocus() and m.focusable and not m.predicationSubmitView.visible
            m.collectionView.setFocus(true)
            result = true
        else if m.layoutGroup.visible and m.collectionViewLeftButton.hasFocus() and m.focusable and not m.predicationSubmitView.visible
            m.layoutGroup.setFocus(true)
            result = true
        else if m.predicationSubmitView.visible
            m.predicationSubmitView.setFocus(true)
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