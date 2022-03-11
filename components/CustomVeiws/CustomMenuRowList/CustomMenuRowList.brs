sub init()
    m.focusedPoster = m.top.findNode("focusedPoster")
    m.imageCell = m.top.findNode("imageCell")
    m.focusedAnimation = m.top.findNode("focusedAnimation")
    m.focusedInterpolator = m.top.findNode("focusedInterpolator")
end sub

sub onChangeFocus()
    if m.top.isFocused
        m.focusedInterpolator.keyValue = [0, 1]
        m.focusedAnimation.control = "start"
    else
        m.focusedInterpolator.keyValue = [1, 0]
        m.focusedAnimation.control = "start"
    end if
end sub

sub layoutSubviews()
    m.imageCell.translation = [37, 15]
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    result = false
    if not press then return result

    if key = "right" and not m.top.isOpenMenu
        result = true
    end if
    return result
end function