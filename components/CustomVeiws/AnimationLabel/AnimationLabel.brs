sub init()
    m.LabelAnimation = m.top.findNode("LabelAnimation")
    m.LabelInterpolator = m.top.findNode("LabelInterpolator")
end sub

function animate(isShow)
    if isShow
        if m.LabelInterpolator.keyValue[0] = 0 then return invalid
        m.LabelInterpolator.keyValue = [0, 1]
    else
        if m.LabelInterpolator.keyValue[1] = 0 then return invalid
        m.LabelInterpolator.keyValue = [1, 0]
    end if

    m.LabelAnimation.control = "start"
end function