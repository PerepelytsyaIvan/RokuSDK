sub init()
    m.containerView = m.top.findNode("containerView")
    m.posterCell = m.top.findNode("posterCell")
    m.titleLabel = m.top.findNode("titleLabel")
end sub

sub configureDataSource()
    dataSource = m.top.itemContent.componentDataSource
    m.titleLabel.font = getBoldFont(getSize(30))
    m.titleLabel.text = dataSource.answer
    m.titleLabel.color = m.global.design.questionTextColor
    m.posterCell.uri = getImageWithName(dataSource.image)
    if isValid(dataSource.buttonText) then m.titleLabel.text = dataSource.buttonText
    layoutSabvies()
end sub

sub onChangePercentFocus(event)
    percentFocus = event.getData()
end sub

sub layoutSabvies()
    m.posterCell.width = getSize(40)
    m.posterCell.height = getSize(40) 
    m.posterCell.translation = [0, 0]
    m.containerView.translation = getSizeMaskGroupWith([15, 30])
    m.containerView.itemSpacings = [getSize(15)]
    if m.posterCell.uri = getImageWithName("")
        m.containerView.translation = getSizeMaskGroupWith([0, 30])
        m.posterCell.width = 0
    end if
    
    containerViewRect = m.containerView.boundingRect()
    boundingRect = m.titleLabel.boundingRect()
    m.titleLabel.width = boundingRect.width + getSize(15)
    m.titleLabel.height = getSize(60)
    topBoundingRect = m.top.boundingRect()
    m.top.widthElement = topBoundingRect.width + topBoundingRect.x
    m.top.heightElement = getSize(60)
end sub
