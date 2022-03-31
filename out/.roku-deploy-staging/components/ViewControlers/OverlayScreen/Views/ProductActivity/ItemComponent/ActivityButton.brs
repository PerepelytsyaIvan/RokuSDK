sub init()
    m.titleLabel = m.top.findNode("titleLabel")
end sub

sub configureDataSource()
    dataSource = m.top.dataSource
    m.titleLabel.font = getBoldFont(getSize(30))
    m.titleLabel.text = dataSource.answer
    m.titleLabel.color = m.global.design.questionTextColor
    if isValid(dataSource.buttonText) then m.titleLabel.text = dataSource.buttonText
    layoutSabvies()
end sub

sub onChangePercentFocus(event)
    percentFocus = event.getData()
end sub

sub layoutSabvies()
    boundingRect = m.titleLabel.boundingRect()
    m.titleLabel.translation = [20, 0]
    m.titleLabel.width = boundingRect.width + getSize(60)
    m.titleLabel.height = getSize(60)
    
    m.top.width = m.top.boundingRect().width + 40
    m.top.height = getSize(60)
end sub
