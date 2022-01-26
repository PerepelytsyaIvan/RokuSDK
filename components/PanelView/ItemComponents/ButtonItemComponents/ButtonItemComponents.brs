sub init()
    initView()
end sub

sub initView()
    m.titleLabel = m.top.findNode("titleLabel")
end sub

sub OnItemContentChanged()
    itemContent = m.top.itemContent
    m.titleLabel.font = getBoldFont(25)
    m.titleLabel.text = itemContent.title
    layoutSubviews()
end sub

sub itemFocusChanged()

end sub

sub layoutSubviews()
    m.titleLabel.width = m.top.width - 10
    m.titleLabel.height = m.top.height - 10
end sub