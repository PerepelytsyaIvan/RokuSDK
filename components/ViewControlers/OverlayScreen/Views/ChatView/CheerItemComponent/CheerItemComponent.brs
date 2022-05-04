sub init()
    m.posterCell = m.top.findNode("posterCell")
    m.focusPoster = m.top.findNode("focusPoster")
end sub

sub configureDataSource()
    m.posterCell.uri = m.top.itemContent.image
    m.focusPoster.blendColor = m.global.design.buttonBackgroundColor
end sub

sub itemFocused()
    m.focusPoster.opacity = m.top.focusPercent
    if not m.top.gridHasFocus then m.focusPoster.opacity = 0
end sub

sub layoutSubviews()
    m.posterCell.width = m.top.width
    m.posterCell.height = m.top.height
    m.focusPoster.width = m.top.width
    m.focusPoster.height = m.top.height
end sub