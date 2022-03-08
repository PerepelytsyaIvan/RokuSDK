sub init()
    m.titleLabel = m.top.findNode("titleLabel")
    m.separator = m.top.findNode("separator")
    m.itemComponentGroup = m.top.findNode("itemComponentGroup")
    m.layoutGroup = m.top.findNode("layoutGroup")
end sub

sub configureDataSource()
    itemContent = m.top.dataSource
    m.titleLabel.font = getRegularFont(getSize(25))
    m.titleLabel.text = itemContent.title
    m.titleLabel.color = m.global.design.questionTextColor
    m.separator.color = m.global.design.questionTextColor
    m.separator.visible = m.top.dataSource.title = "Account"
    layoutSubviews()
end sub

sub layoutSubviews()
    m.titleLabel.width = m.titleLabel.localBoundingRect().width
    m.titleLabel.height = getSize(30)
    if m.separator.visible 
        m.separator.height = getSize(30)
        m.separator.width = getSize(2)
    end if
    boundingRectLocal = m.layoutGroup.localBoundingRect()
    m.top.width = m.titleLabel.width + 10
    m.top.height = getSize(30)
end sub
