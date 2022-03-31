sub init()
    m.top.setFocus(true)
    m.switchGroup = m.top.findNode("switchGroup")

    m.focus = m.top.findNode("focus")

    m.titleLabel = m.top.findNode("titleLabel")
    m.backgroundSwitch = m.top.findNode("backgroundSwitch")
    m.circleSwitch = m.top.findNode("circleSwitch")
    m.animationSwitch = m.top.findNode("animationSwitch")
    m.interpolatorTranslation = m.top.findNode("interpolatorTranslation")
    m.thumbColorIntrp = m.top.findNode("thumbColorIntrp")
    m.titleLabel.font = getRegularFont(20)

    m.focus.blendColor = m.global.design.buttonBackgroundColor
end sub

sub includeSwitch()
    if m.top.isOn
        m.interpolatorTranslation.keyValue = [m.circleSwitch.translation, [m.backgroundSwitch.width - m.circleSwitch.width - 3, 3]]
        m.thumbColorIntrp.keyValue = ["#39383Dff", "#40B729ff"]
    else
        m.interpolatorTranslation.keyValue = [m.circleSwitch.translation, [3, 3]]
        m.thumbColorIntrp.keyValue = ["#40B729ff", "#39383Dff"]
    end if

    m.animationSwitch.control = "start"
end sub

sub focusedSwitch()
    m.focus.visible = m.top.focus
end sub

sub layoutSubview()
    m.backgroundSwitch.width = m.top.width
    m.backgroundSwitch.height = m.top.height
    m.circleSwitch.translation = [3, 3]
    m.circleSwitch.width = m.top.height - 6
    m.circleSwitch.height = m.circleSwitch.width
    m.focus.height = m.top.height + 20
    m.titleLabel.height = m.top.height
    m.titleLabel.translation = [10, 10]
    m.switchGroup.translation = [m.titleLabel.boundingRect().width + 30, 10]
    m.focus.width = m.top.boundingRect().width + 20
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    result = false
    if not press then return true

    if key = "OK"
        m.top.isOn = not m.top.isOn
        result = true
    end if
    return result
end function