sub init()
    m.rating = m.top.findNode("rating")
    m.focusedAnimation = m.top.findNode("focusedAnimation")
    m.focusedColor = m.top.findNode("focusedColor")

    m.focused = m.top.findNode("focused")
end sub

sub OnItemContentChanged()
    m.rating.uri = "pkg:/images/iconStar" + m.top.title + ".png"
    m.top.observeField("focusedChild", "onFocusedChild")
    layoutSubviews()
end sub

sub layoutSubviews()
    m.rating.width = m.rating.height * m.top.title.toInt()
    m.focused.width = m.top.width
    m.focused.height = m.top.height
STOP
    m.rating.translation = [10 ,(m.top.height - m.rating.height) / 2]
end sub

sub setFocusView()
    if m.top.focused
        m.focused.uri = "pkg:/images/ratingFocus.png"
    else
        m.focused.uri = "pkg:/images/ratingUfocus.png"
    end if
end sub
