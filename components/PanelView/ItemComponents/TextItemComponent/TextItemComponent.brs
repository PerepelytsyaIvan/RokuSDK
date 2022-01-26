sub init()
    initView()
end sub

sub initView()
    m.titleLabel = m.top.findNode("titleLabel")
    m.separator = m.top.findNode("separator")
end sub

sub OnItemContentChanged()
    itemContent = m.top.itemContent
    m.titleLabel.font = getRegularFont(20)
    m.titleLabel.text = itemContent.title
    m.separator.visible = itemContent.isSelected 
    if not itemContent.isSelected 
        m.titleLabel.horizAlign="left"
        m.titleLabel.translation = [10, 5]
    end if
    layoutSubviews()
end sub

sub itemFocusChanged()

end sub

sub layoutSubviews()
    m.titleLabel.width = m.top.width - 10
    m.titleLabel.height = m.top.height - 10
    m.separator.height = m.top.height
    m.separator.translation = [m.top.width - 2.5, 0]
end sub