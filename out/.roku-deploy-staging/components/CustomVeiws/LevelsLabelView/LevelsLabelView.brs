sub init()
    m.levelLabel = m.top.findNode("levelLabel")
    m.countLevelLabel = m.top.findNode("countLevelLabel")
    m.pointsLabel = m.top.findNode("pointsLabel")
    m.countPointsLabel = m.top.findNode("countPointsLabel")
    m.LabelAnimation = m.top.findNode("LabelAnimation")
    m.LabelInterpolator = m.top.findNode("LabelInterpolator")
end sub

sub configureDataSource()
    dataSource = m.top.dataSource

    labels = [m.levelLabel, m.countLevelLabel, m.pointsLabel, m.countPointsLabel]

    for each label in labels
        label.font = getMediumFont(25)
    end for

    m.levelLabel.text = "Level"
    m.pointsLabel.text = "Points"
    if IsValid(dataSource.level) and IsValid(dataSource.level) 
        m.countLevelLabel.text = dataSource.level.toStr()
        m.countPointsLabel.text = dataSource.expoints.toStr()
    end if
    layoutSubviews()
end sub

function animate(isShow)
    if isShow
        if m.LabelInterpolator.keyValue[0] = 0 then return invalid
        m.LabelInterpolator.keyValue = [0, 1]
    else
        if m.LabelInterpolator.keyValue[1] = 0 then return invalid
        m.LabelInterpolator.keyValue = [1, 0]
    end if

    m.LabelAnimation.control = "start"
end function

sub layoutSubviews()
    boundingPoint = m.pointsLabel.boundingRect()
    boundingCountPoint = m.countPointsLabel.boundingRect()

    if boundingPoint.width > boundingCountPoint.width
        m.countPointsLabel.width = boundingPoint.width
        m.pointsLabel.width = boundingPoint.width
    else
        m.pointsLabel.width = boundingCountPoint.width
        m.countPointsLabel.width = boundingCountPoint.width
    end if

    m.countLevelLabel.width = m.levelLabel.boundingRect().width
end sub