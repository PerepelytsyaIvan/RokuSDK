sub init()
    m.titleLabel = m.top.findNode("titleLabel")
end sub

sub configureDataSource()
    m.titleLabel.font = getRegularFont(getSize(25))
    m.titleLabel.color = m.global.design.questionTextColor
    m.titleLabel.text = m.top.dataSource.title
    layoutSubviews()
end sub

sub layoutSubviews()
    m.titleLabel.width = m.titleLabel.boundingRect().width + 10
    m.top.width = m.titleLabel.width
    m.top.height = m.titleLabel.boundingRect().height
end sub