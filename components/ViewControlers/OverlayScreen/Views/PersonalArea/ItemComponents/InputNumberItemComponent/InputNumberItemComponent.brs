sub init()
    m.codeLabel = m.top.findNode("codeLabel")
    m.background = m.top.findNode("background")
    m.focusCell = m.top.findNode("focusCell")
    m.indicator = m.top.findNode("indicator")
    m.editBoxGroup = m.top.findNode("editBoxGroup")
    m.animation = m.top.findNode("animation")
end sub

sub configureDataSource()
    m.codeLabel.font = getRegularFont(25)
    m.codeLabel.text = m.top.itemContent.item.code
    m.animation.control = "stop"

    if isValid(m.top.itemContent.item.selected)
        if m.top.itemContent.item.selected then m.animation.control = "start"
        m.indicator.visible = m.top.itemContent.item.selected
    else
        m.indicator.visible = false
    end if
    
    layoutSubviews()
end sub

sub itemFocused()
    m.background.opacity = 1 - m.top.rowFocusPercent
    if not m.top.rowListHasFocus
        m.background.opacity = 1
    end if
end sub

sub layoutSubviews()
    posters = [m.background, m.focusCell]

    for each poster in posters
        poster.width = m.top.width
        poster.height = m.top.height
    end for

    m.editBoxGroup.translation = [20, m.top.height / 2]
    m.codeLabel.height = m.top.height
    m.codeLabel.width = m.codeLabel.localBoundingRect().width
    m.indicator.width = 1.5
    m.indicator.height = 30
end sub