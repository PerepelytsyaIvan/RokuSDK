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
    m.top.width = m.titleLabel.boundingRect().width
    m.top.height = m.titleLabel.boundingRect().height
end sub