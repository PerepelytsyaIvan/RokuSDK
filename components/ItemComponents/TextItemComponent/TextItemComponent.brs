sub init()
    m.titleLabel = m.top.findNode("titleLabel")
    m.separator = m.top.findNode("separator")
    m.itemComponentGroup = m.top.findNode("itemComponentGroup")
    m.layoutGroup = m.top.findNode("layoutGroup")
end sub

sub configureDataSource()
    itemContent = m.top.dataSource
    m.titleLabel.font = getRegularFont(20)
    m.titleLabel.text = itemContent.title
    m.titleLabel.color = m.global.design.questionTextColor
    m.separator.color = m.global.design.questionTextColor
    m.separator.visible = m.top.dataSource.title = "Account"
    layoutSubviews()
end sub

sub layoutSubviews()
    m.titleLabel.width = m.titleLabel.localBoundingRect().width
    m.titleLabel.height = 20
    if m.separator.visible 
        m.separator.height = 20
        m.separator.width = 2
    end if
    boundingRectLocal = m.layoutGroup.localBoundingRect()
    m.top.width = boundingRectLocal.width
    m.top.height = 20
end sub