sub init()
    m.imageCell = m.top.findNode("imageCell")
    m.label = m.top.findNode("label")
    m.buttonAnimation = m.top.findNode("buttonAnimation")
    m.buttonInterpolator = m.top.findNode("buttonInterpolator")
    m.buttonScaleAnimation = m.top.findNode("buttonScaleAnimation")
    m.buttonScaleInterpolator = m.top.findNode("buttonScaleInterpolator")
    configureDesign()
end sub

sub configureDesign()
    m.imageCell.uri = "pkg:/images/gradienFocusButton.9.png"
    m.label.font = getRegularFont(getSize(25))
    m.imageCell.width = getSize(130)
    m.imageCell.height = getSize(50)
    m.label.width = getSize(130)
    m.label.height = getSize(50)
    m.label.color = "#ffffff"

    m.imageCell.scaleRotateCenter = [m.imageCell.width / 2, m.imageCell.height / 2]
end sub

sub activeButton()
    if m.top.activateButton
        m.buttonInterpolator.keyValue = [0.2, 1]
    else
        m.buttonInterpolator.keyValue = [1, 0.2]
    end if
    m.buttonAnimation.control = "start"
end sub

sub setFocusButton()
    if m.top.focusButton
        m.buttonScaleInterpolator.keyValue = [[1.0, 1.0], [1.1, 1.1]]
    else
        m.buttonScaleInterpolator.keyValue = [[1.1, 1.1], [1.0, 1.0]]
    end if
    m.buttonScaleAnimation.control = "start"
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    result = false
    if not press then return result

    if key = "OK"
        m.top.selectButton = true
        result = true
    end if
    return result
end function