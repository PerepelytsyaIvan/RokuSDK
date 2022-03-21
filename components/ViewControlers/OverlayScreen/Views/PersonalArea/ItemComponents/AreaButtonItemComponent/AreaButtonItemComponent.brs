sub init()
    m.titleLabel = m.top.findNode("titleLabel")
end sub

sub configureDataSource()
    dataSource = m.top.itemContent
    m.titleLabel.font = getBoldFont(getSize(30))
    m.titleLabel.text = dataSource.title
    m.titleLabel.color = m.global.design.questionTextColor
    layoutSabvies()
end sub

sub onChangePercentFocus(event)
    percentFocus = event.getData()
end sub

sub layoutSabvies()
    boundingRect = m.titleLabel.boundingRect()
    m.titleLabel.translation = [20, 0]
    m.titleLabel.width = boundingRect.width + getSize(60)
    m.titleLabel.height = m.top.height
end sub
