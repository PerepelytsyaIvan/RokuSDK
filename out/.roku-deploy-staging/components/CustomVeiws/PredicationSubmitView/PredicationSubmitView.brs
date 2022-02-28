sub init()
    m.top.opacity = 0
    m.top.id = "PredicationSubmitView"
    m.collectionView = m.top.findNode("collectionView")
    m.containerView = m.top.findNode("containerView")
    m.posterCell = m.top.findNode("posterCell")
    m.titleLabel = m.top.findNode("titleLabel")
    m.counterLabel = m.top.findNode("counterLabel")
    m.separator = m.top.findNode("separator")
    m.animationView = m.top.findNode("animationView")
    m.animationInterpolator = m.top.findNode("animationInterpolator")
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
    { imageName: "down", itemComponent: "ArrowItemComponent" },
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
    m.posterCell.width = 60
    m.posterCell.height = 60
    m.posterCell.translation = [0, boundingRectCollection.x + ((boundingRectCollection.height - m.posterCell.height) / 2)]
    m.titleLabel.translation = [m.posterCell.translation[0] + m.posterCell.width + 20, 0]
    labelBoundingRect = m.titleLabel.boundingRect()
    m.counterLabel.translation = [m.titleLabel.translation[0] + labelBoundingRect.width, 0]
    m.counterLabel.width = 80 + 72
    counterLabelBoundingRect = m.counterLabel.boundingRect()
    m.containerView.translation = [0, (m.separator.height - boundingRectCollection.height) / 2]
    m.collectionView.translation = [m.counterLabel.translation[0] + counterLabelBoundingRect.width + 20, 0]
    if IsValid(m.collectionView.elements)
        m.separator.translation = [m.collectionView.translation[0] + m.collectionView.horizontalSpacing + m.collectionView.elements[0].width - 10, 0]
    end if
end sub

function showView(isShow)
    if isShow
        m.animationInterpolator.keyValue = [0.0, 1.0]
    else
        m.animationInterpolator.keyValue = [1.0, 0.0]
    end if
    m.animationView.control = "start"
end function

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
        m.count--
    end if

    points = (m.top.dataSource.points.toFloat() * m.count)
    reward = (m.top.dataSource.reward.toFloat() * m.top.dataSource.points.toFloat()) * m.count
    m.wager = reward.toStr()
    return points.toStr() + "/" + reward.toStr()
end sub


