sub init()
    m.buttonBackground = m.top.findNode("buttonBackground")
    m.iconButton = m.top.findNode("iconButton")
    m.focusButton = m.top.findNode("focusButton")
    m.animation = m.top.findNode("animation")
    m.interpolator = m.top.findNode("interpolator")
    m.interpolator.addField("isFocused", "bool", false)
    m.focusButton.blendColor = m.global.design.buttonBackgroundColor
    layoutSubview()
end sub

sub layoutSubview()
    m.buttonBackground.width = getSize(50)
    m.buttonBackground.height = getSize(30)
    m.iconButton.width = getSize(22)
    m.iconButton.height = getSize(15)
    m.focusButton.width = getSize(50)
    m.focusButton.height = getSize(30)
    m.iconButton.translation= [getSize(14), getSize(7.5)] 
end sub

function setFocusButton(focused)
    if m.top.isFocused
        m.top.setFocus(true)
        m.interpolator.isFocused = true
        m.interpolator.keyValue = [0, 1]
        m.animation.control = "start"
    else
        m.interpolator.isFocused = false
        m.interpolator.keyValue = [1, 0]
        m.animation.control = "start"
    end if
end function

function onKeyEvent(key as string, press as boolean) as boolean
    result = false
    if not press then return result

    if key = "OK"
        m.top.selectButton = true
        result = true
    end if
    return result
end function