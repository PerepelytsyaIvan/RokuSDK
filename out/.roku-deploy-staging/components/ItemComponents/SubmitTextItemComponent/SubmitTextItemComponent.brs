sub init()
    m.titleLabel = m.top.findNode("titleLabel")
end sub

sub configureDataSource()
    m.titleLabel.font = getRegularFont(20)
    m.titleLabel.color = m.global.design.questionTextColor
    m.titleLabel.text = m.top.dataSource.title
    m.top.width = m.titleLabel.width
    m.top.height = m.titleLabel.height
end sub