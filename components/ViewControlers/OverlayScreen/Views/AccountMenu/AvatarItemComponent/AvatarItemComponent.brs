sub init()
    m.profileImage = m.top.findNode("profileImage")
    m.profileFocus = m.top.findNode("profileFocus")
    m.background = m.top.findNode("background")
end sub

sub configureDataSource()
    m.profileImage.uri = m.top.itemContent.image
    layoutSubviews()
end sub

' sub itemFocused()
'     m.profileFocus.opacity = m.top.focusPercent

'     if m.top.itemHasFocus
'         m.profileFocus.opacity = 1
'     else
'         m.profileFocus.opacity = m.top.focusPercent
'     end if
' end sub


' sub itemRowFocused()
'     m.profileFocus.opacity = m.top.rowFocusPercent
' end sub


sub layoutSubviews()
    m.profileImage.width = getSize(60)
    m.profileImage.height = getSize(60)
    m.background.width = getSize(100)
    m.background.height = getSize(100)
    m.profileImage.translation = [(m.background.width - m.profileImage.width) / 2, (m.background.height - m.profileImage.height) / 2]
end sub