sub init()
    m.containerView = m.top.findNode("containerView")
    m.posterCell = m.top.findNode("posterCell")
    m.titleLabel = m.top.findNode("titleLabel")
end sub

sub configureDataSource()
    dataSource = m.top.dataSource
    m.titleLabel.font = getBoldFont(25)
    m.titleLabel.text = dataSource.answer
    m.titleLabel.color = m.global.design.questionTextColor
    if isValid(dataSource.buttonText) then m.titleLabel.text = dataSource.buttonText
    if dataSource.image <> ""
        m.posterCell.uri = getImageWithName(dataSource.image)
        m.posterCell.width = 35
        m.posterCell.height = 35
    else
        m.containerView.translation = [0, m.containerView.translation[1]]
    end if
    layoutSabvies()
end sub

sub onChangePercentFocus(event)
    percentFocus = event.getData()
end sub

sub layoutSabvies()
    containerViewRect = m.containerView.boundingRect()
    boundingRect = m.titleLabel.boundingRect()
    m.titleLabel.width = boundingRect.width + 15
    topBoundingRect = m.top.boundingRect()
    m.top.width = topBoundingRect.width + topBoundingRect.x
    m.top.height = topBoundingRect.height + (topBoundingRect.y * 2)
end sub
