sub init()
    m.levelLabel = m.top.findNode("levelLabel")
    m.countLevelLabel = m.top.findNode("countLevelLabel")
    m.pointsLabel = m.top.findNode("pointsLabel")
    m.countPointsLabel = m.top.findNode("countPointsLabel")
    m.levelGroup = m.top.findNode("levelGroup")
    m.levelLabelGroup = m.top.findNode("levelLabelGroup")
    m.pointsLabelGroup = m.top.findNode("pointsLabelGroup")
end sub

sub configureDataSource()
    dataSource = m.top.dataSource

    labels = [m.levelLabel, m.pointsLabel]
    labelsNumber = [m.countLevelLabel, m.countPointsLabel]

    for each label in labels
        label.font = getMediumFont(25)
    end for

    for each label in labelsNumber
        label.font = getBoldFont(30)
    end for

    m.levelLabel.text = "Level"
    m.pointsLabel.text = "Points"
    if IsValid(dataSource.level) and IsValid(dataSource.level) 
        m.countLevelLabel.text = dataSource.level.toStr()
        m.countPointsLabel.text = dataSource.expoints.toStr()
    end if
    layoutSubviews()
end sub

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

    m.levelGroup.itemSpacings = [getSize(50)]
    m.pointsLabelGroup.itemSpacings = [getSize(5)]
    m.levelLabelGroup.itemSpacings = [getSize(5)]
    m.countLevelLabel.width = m.levelLabel.boundingRect().width
end sub