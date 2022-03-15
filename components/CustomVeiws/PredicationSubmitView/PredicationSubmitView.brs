sub init()
    m.top.setFocus(true)
    m.top.id = "PredicationSubmitView"
    m.collectionView = m.top.findNode("collectionView")
    m.containerView = m.top.findNode("containerView")
    m.posterCell = m.top.findNode("posterCell")
    m.titleLabel = m.top.findNode("titleLabel")
    m.counterLabel = m.top.findNode("counterLabel")
    m.separator = m.top.findNode("separator")
    m.top.observeField("focusedChild", "onFocusedChild")
    configureUI()
    m.collectionView.observeField("item", "didSelecetItem")
    m.previusReward = 0
    m.previusPoints = 0
    m.count = 0
end sub

sub onFocusedChild()
    if m.top.hasFocus()
        m.collectionView.setFocus(true)
    end if
end sub

sub configureDataSource()
    m.titleLabel.text = m.top.dataSource.answer
    m.posterCell.uri = getImageWithName(m.top.dataSource.image)
    reward = m.top.dataSource.reward
    m.previusReward = 0
    m.previusPoints = 0
    m.counterLabel.text = getForrmaterStringWithPoints("up", true)
    dataSource = [{ imageName: "top", itemComponent: "ArrowItemComponent" },
    { title: "SUBMIT", itemComponent: "SubmitTextItemComponent" },
    { imageName: "down", itemComponent: "ArrowItemComponent", "newSection" : true},
    { title: "Back", itemComponent: "SubmitTextItemComponent" }]
    m.collectionView.dataSource = dataSource
    m.collectionView.setFocus(true)
    layoutSubwview()
end sub

sub configureUI()
    m.titleLabel.color = m.global.design.questionTextColor
    m.counterLabel.color = m.global.design.questionTextColor
    m.titleLabel.font = getBoldFont(25)
    m.counterLabel.font = getBoldFont(25)
end sub

sub layoutSubwview()
    boundingRectCollection = m.collectionView.boundingRect()
    m.titleLabel.height = boundingRectCollection.height
    m.counterLabel.height = boundingRectCollection.height
    m.posterCell.width = getSize(60)
    m.posterCell.height = getSize(60)
    labelBoundingRect = m.titleLabel.boundingRect()
    m.counterLabel.width = getSize(80) + getSize(72)
    counterLabelBoundingRect = m.counterLabel.boundingRect()
    m.containerView.translation = [0, m.collectionView.boundingRect().height / 2]
    m.containerView.itemSpacings = [getSize(15), getSize(40), getSize(20)]
    if IsValid(m.collectionView.elements)
        m.separator.translation = [m.containerView.boundingRect().width - m.collectionView.elements[1].width - getSize(30), 0]
    end if
    m.separator.height = getSize(80)
    m.separator.width = getSize(1)
end sub

sub didSelecetItem(event)
    item = event.getData()
    isSelectOnArrow = IsValid(item.imagename)

    if isSelectOnArrow
        if item.imagename = "top"
            m.counterLabel.text = getForrmaterStringWithPoints("up")
        else
            if m.previusPoints <> m.top.dataSource.points.toFloat()
                m.counterLabel.text = getForrmaterStringWithPoints("down")
            end if
        end if
    else 
        if item.title = "Back"
            m.top.pressBack = true
        else
            m.top.itemParam = {"wager": m.wager, "answer" : m.titleLabel.text}
        end if
    end if
end sub

sub getForrmaterStringWithPoints(direction = "up", start = false) as string
    if direction = "up"
        m.count++
    else if direction = "down"
        if m.count > 1
            m.count--
        end if
    end if

    points = (m.top.dataSource.points.toFloat() * m.count)
    reward = (m.top.dataSource.reward.toFloat() * m.top.dataSource.points.toFloat()) * m.count
    m.wager = reward.toStr()
    return points.toStr() + "/" + reward.toStr()
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    result = false

    if not press then return result

    if key = "up" 
        result = true
    end if
    return result
end function