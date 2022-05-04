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
        label.font = getMediumFont(getSize(25))
    end for

    for each label in labelsNumber
        label.font = getBoldFont(getSize(30))
    end for

    m.levelLabel.text = m.global.localization.generalOverlayLevel
    m.countLevelLabel.text = m.global.userLevel.toStr()
    m.countPointsLabel.text = m.global.userPoints.toStr()
    m.pointsLabel.text = m.global.localization.generalOverlayPoint
  
    layoutSubviews()
end sub

sub layoutSubviews()
    m.pointsLabel.width = 0
    m.countPointsLabel.width = 0
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