sub init()
    initView()
    configureDesign()

    m.hidingTimer = configureTimer(1, true)
    m.showActivityTimer = configureTimer(0.5, false)

    m.showActivityTimer.observeField("fire", "showActifityAfterTimer")
    m.hidingTimer.observeField("fire", "changeTime")
    m.translationInterpolator.addField("isShow", "boolean", false)
    m.timeForHideView = 0
end sub

sub configureDataSource()
    if m.translationInterpolator.isShow 
        hideActivity()
        m.showActivityTimer.control = "start"
        return
    end if
    m.questionLabel.text = m.top.dataSource.question
    m.priceLabel.text = m.top.dataSource.price
    m.productImage.uri = getImageWithName(m.top.dataSource.image)
    m.collectionView.dataSource = [m.top.dataSource]

    dataSourceLeftButton = [{ "title": "Account", "itemComponent": "TextItemComponent" }, { "title": "Close", "itemComponent": "TextItemComponent" }]
    m.collectionViewLeftButton.dataSource = dataSourceLeftButton
    m.timeForHideView = m.top.dataSource.timeForHiding
    configureLabel(m.timeForHideView)
    m.collectionView.setFocus(true)
    layoutViews()
    showActivity()
end sub

sub showActivity()
    if m.translationInterpolator.isShow
        hideActivity()
        m.showActivityTimer.control = "start"
        return
    end if
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

sub showActifityAfterTimer()
    m.translationInterpolator.isShow = false
    m.showActivityTimer.control = "stop"
    configureDataSource()
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

function onKeyEvent(key as string, press as boolean) as boolean
    result = false

    if not press then return result

    if key = "left" and m.collectionViewLeftButton.hasFocus()
        m.collectionView.setFocus(true)
        result = true
    else if key = "right" and m.collectionView.hasFocus()
        m.collectionViewLeftButton.setFocus(true)
        result = true
    end if
    return result
end function