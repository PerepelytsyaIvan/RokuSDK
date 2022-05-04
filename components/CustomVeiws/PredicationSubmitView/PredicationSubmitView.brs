sub init()
    m.top.setFocus(true)
    m.top.id = "PredicationSubmitView"
    m.rowList = m.top.findNode("rowList")
    m.containerView = m.top.findNode("containerView")
    m.posterCell = m.top.findNode("posterCell")
    m.titleLabel = m.top.findNode("titleLabel")
    m.counterLabel = m.top.findNode("counterLabel")
    m.separator = m.top.findNode("separator")
    m.focusCounter = m.top.findNode("focusCounter")
    m.topArrowPoster = m.top.findNode("topArrowPoster")
    m.downArrowPoster = m.top.findNode("downArrowPoster")
    m.top.observeField("focusedChild", "onFocusedChild")
    m.rowList.observeField("itemSelected", "didSelectItem")
    configureUI()
    m.previusReward = 0
    m.previusPoints = 0
    m.count = 0
    m.startPoints = 10
    m.isFirstOpened = true
end sub

sub onFocusedChild()
    if m.top.hasFocus()
        m.top.focusKey = m.top.focusKey
    end if
end sub

sub configureDataSource()
    m.titleLabel.text = m.top.dataSource.answer
    m.posterCell.uri = getImageWithName(m.top.dataSource.image)
    reward = m.top.dataSource.reward
    m.previusReward = 0
    m.previusPoints = 0
    m.counterLabel.text = getForrmaterStringWithPoints("up", true)

    arrayTitles = [m.global.localization.predictionsSubmit, m.global.localization.predictionsBack]
    content = CreateObject("roSGNode", "ContentNode")

    for each title in arrayTitles
        rowContent = content.createChild("ContentNode")
        elementContent = rowContent.createChild("ContentNode")
        elementContent.title = title
    end for

    m.rowList.itemSize = [getSize(100), getSize(30)]
    m.rowList.rowItemSize = [[getSize(100), getSize(30)]]
    m.rowList.itemSpacing = [0, getSize(10)]
    m.rowList.rowItemSpacing = [[0, getSize(10)]]
    m.rowList.content = content
    m.rowList.setFocus(true)
    m.top.focusKey = 0
    layoutSubwview()
end sub

sub configureUI()
    m.titleLabel.color = m.global.design.questionTextColor
    m.counterLabel.color = m.global.design.questionTextColor
    m.titleLabel.font = getBoldFont(getSize(25))
    m.counterLabel.font = getBoldFont(getSize(25))
end sub

sub layoutSubwview()
    boundingRectCollection = m.rowList.boundingRect()
    m.titleLabel.height = boundingRectCollection.height
    m.counterLabel.height = boundingRectCollection.height
    m.posterCell.width = getSize(60)
    m.posterCell.height = getSize(60)
    labelBoundingRect = m.titleLabel.boundingRect()
    if getWidthForText(m.counterLabel.text, getBoldFont(25)) > getSize(80) + getSize(70)
        m.counterLabel.width = getWidthForText(m.counterLabel.text, getBoldFont(25)) + getSize(30)
    else
        m.counterLabel.width = getSize(80) + getSize(72)
    end if
    counterLabelBoundingRect = m.counterLabel.boundingRect()
    m.containerView.translation = [0, (m.rowList.boundingRect().height / 2) - getSize(20)]
    m.containerView.itemSpacings = [getSize(15), getSize(15)]
    m.separator.translation = [m.containerView.boundingRect().width + getSize(30), 0]
    m.rowList.translation = [m.separator.translation[0] + getSize(30), getSize(10)]
    m.separator.height = getSize(80)
    m.separator.width = getSize(1)
    m.topArrowPoster.width = getSize(20)
    m.topArrowPoster.height = getSize(15)
    m.downArrowPoster.width = getSize(20)
    m.downArrowPoster.height = getSize(15)
    m.focusCounter.height = getSize(100)
    configureFocusCounter()
end sub

sub configureFocusCounter()
    widthLabel = getWidthForText(m.counterLabel.text, getBoldFont(getSize(25)))
    m.focusCounter.width = widthLabel + getSize(20)
    m.focusCounter.height = getSize(70)
    translationX = m.containerView.boundingRect().width - getSize(25) - m.focusCounter.width
    m.focusCounter.translation = [translationX, 3]
end sub

sub didSelectItem(event)
    index = event.getData()
    title = m.rowList.content.getChild(index).getChild(0).title
    if title = m.global.localization.predictionsBack
        m.top.pressBack = true
    else
        m.top.itemParam = { "wager": m.wager, "answer": m.titleLabel.text }
    end if
end sub

sub getForrmaterStringWithPoints(direction = "up", start = false) as string
    if direction = "up"
        m.count++
        if (m.top.dataSource.reward.toFloat() * m.startPoints) * m.count > m.global.userPoints
            if m.global.userPoints = 0
                if not m.isFirstOpened
                    m.top.showNotificationPoints = { isShow: "true", type: "zeroPoints" }
                end if
            else
                m.top.showNotificationPoints = { isShow: "true", type: "noPoints" }
            end if
        end if
        m.isFirstOpened = false
        if m.global.userPoints < (m.startPoints * m.count) then m.count -= 1
    else if direction = "down"
        if m.count > 1
            m.count--
        end if
    end if

    if (m.top.dataSource.reward.toFloat() * m.startPoints) * m.count > m.global.userPoints then m.count--

    points = (m.startPoints * m.count)
    reward = (m.top.dataSource.reward.toFloat() * m.startPoints) * m.count
    m.wager = reward.toStr()
    m.previusPoints = points
    return points.toStr() + "/" + reward.toStr()
end sub

sub updateFocus()
    if m.top.focusKey = 0
        m.focusCounter.visible = true
        m.rowList.setFocus(false)
        m.top.setFocus(true)
    else if m.top.focusKey = 1
        m.focusCounter.visible = false
        m.rowList.setFocus(true)
    end if
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    result = false

    if not press then return result

    if key = "up" and m.top.focusKey = 0
        m.counterLabel.text = getForrmaterStringWithPoints("up")
        layoutSubwview()
        configureFocusCounter()
        result = true
    else if key = "down" and m.top.focusKey = 0
        if m.previusPoints > m.startPoints
            m.counterLabel.text = getForrmaterStringWithPoints("down")
            layoutSubwview()
            configureFocusCounter()
        end if
        result = true
    else if key = "right" and m.top.focusKey = 0
        m.top.focusKey = 1
        result = true
    else if key = "left" and m.top.focusKey = 1
        m.top.focusKey = 0
        result = true
    else if key = "back"
        m.top.pressBack = true
        result = true
    end if
    return result
end function