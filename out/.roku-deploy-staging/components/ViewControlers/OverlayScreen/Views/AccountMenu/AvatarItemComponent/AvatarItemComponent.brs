sub init()
    m.profileImage = m.top.findNode("profileImage")
    m.profileFocus = m.top.findNode("profileFocus")
    m.background = m.top.findNode("background")
    m.selectFocus = m.top.findNode("selectFocus")
end sub

sub configureDataSource()
    m.profileImage.uri = m.top.itemContent.image
    m.profileFocus.visible = m.top.itemContent.isSelectItem
    layoutSubviews()
end sub

sub itemFocused()
    m.selectFocus.opacity = m.top.focusPercent
    if not m.top.rowListHasFocus then m.selectFocus.opacity = 0
end sub

sub layoutSubviews()
    m.profileImage.width = getSize(60)
    m.profileImage.height = getSize(60)
    m.background.width = getSize(100)
    m.background.height = getSize(100)
    m.profileImage.translation = [(m.background.width - m.profileImage.width) / 2, (m.background.height - m.profileImage.height) / 2]
    m.profileFocus.width = getSize(100)
    m.profileFocus.height = getSize(100)
end sub