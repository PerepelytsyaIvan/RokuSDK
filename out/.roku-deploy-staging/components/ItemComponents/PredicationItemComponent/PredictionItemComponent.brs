sub init()
    initView()
end sub

sub initView()
    m.containerView = m.top.findNode("containerView")
    m.pointsImage = m.top.findNode("pointsImage")
    m.pointLabel = m.top.findNode("pointLabel")
    m.posterCell = m.top.findNode("posterCell")
    m.titleLabel = m.top.findNode("titleLabel")
end sub

sub configureDataSource()
    m.titleLabel.font = getBoldFont(getSize(30))
    m.pointLabel.font = getMediumFont(getSize(20))
    m.pointLabel.color = m.global.design.questionTextColor
    m.titleLabel.color = m.global.design.questionTextColor
    m.titleLabel.text = m.top.dataSource.answer
    m.pointLabel.text = m.top.dataSource.reward
    m.posterCell.uri = getImageWithName(m.top.dataSource.image)
    m.pointsImage.uri = "pkg:/images/predictionIcon.png"
    layoutSubviews()
end sub

sub layoutSubviews()
    m.pointsImage.width = getSize(60)
    m.pointsImage.height = getSize(60)
    m.pointLabel.width = getSize(50)
    m.pointLabel.height = getSize(50)
    m.pointLabel.translation = [getSize(5), getSize(5)]

    m.containerView.itemSpacings = [getSize(5)]

    if m.posterCell.uri <> getImageWithName("")
        m.posterCell.width = getSize(30)
        m.posterCell.height = getSize(30)
        m.containerView.itemSpacings = [getSize(10)]
    end if

    m.titleLabel.width = m.titleLabel.boundingRect().width
    m.titleLabel.height = getSize(80)

    m.containerView.translation = [0, getSize(60) / 2]

    boundingRect = m.containerView.boundingRect()
    m.top.width = m.containerView.boundingRect().width + getSize(10)
    m.top.height = getSize(60)
end sub
