sub init()
    initView()
end sub

sub initView()
    m.titleLabel = m.top.findNode("titleLabel")
    m.posterCell = m.top.findNode("posterCell")
    m.pointLabel = m.top.findNode("pointLabel")
    m.ptsLabel = m.top.findNode("ptsLabel")
    m.itemComponentGroup = m.top.findNode("itemComponentGroup")
end sub

sub configureDataSource()
    itemContent = m.top.dataSource
    m.titleLabel.font = getBoldFont(25)
    m.pointLabel.font = getRegularFont(15)
    m.ptsLabel.font = getRegularFont(15)
    m.titleLabel.color = m.global.design.questionTextColor
    m.titleLabel.text = itemContent.answer
    if isValid(itemContent.image)
        m.posterCell.uri = "pkg:/images/predictionIcon.png"
    end if
    m.pointLabel.text = itemContent.reward
    m.ptsLabel.text = "pts"
    layoutSubviews()
end sub

sub layoutSubviews()
    m.titleLabel.width = m.titleLabel.boundingRect().width
    m.titleLabel.height = 60
    m.posterCell.translation = [0,0]
    m.posterCell.width = 60
    m.posterCell.height = 60
    m.titleLabel.translation = [m.posterCell.width + 10, 0]

    m.pointLabel.width = 60 - 8
    m.pointLabel.translation = [4, 13]
    m.ptsLabel.width = 60 - 8
    m.ptsLabel.translation = [4, m.pointLabel.boundingRect().height + 5]
    boundingRectLocal = m.itemComponentGroup.localBoundingRect()
    m.top.width = boundingRectLocal.width
    m.top.height = boundingRectLocal.height
end sub