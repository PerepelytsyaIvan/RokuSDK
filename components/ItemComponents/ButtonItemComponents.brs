sub init()
    initView()
end sub

sub initView()
    m.focusCell = m.top.findNode("focusCell")
    m.unFocused = m.top.findNode("unFocused")
    m.titleLabel = m.top.findNode("titleLabel")
    m.titleColor = m.top.findNode("titleColor")
end sub

sub OnItemContentChanged()
    itemContent = m.top.itemContent
    m.titleLabel.text = itemContent.title
    layoutSubviews()
end sub

sub itemFocusChanged()
    m.focusCell.opacity = m.top.focusPercent
    m.titleColor.fraction = m.top.focusPercent
end sub

sub layoutSubviews()
    m.unFocused.width = m.top.width
    m.unFocused.height = m.top.height

    m.focusCell.width = m.top.width
    m.focusCell.height = m.top.height

    m.titleLabel.width = m.top.width - 10
    m.titleLabel.height = m.top.height - 10
end sub