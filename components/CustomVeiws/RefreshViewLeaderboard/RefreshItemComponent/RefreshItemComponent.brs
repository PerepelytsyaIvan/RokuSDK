sub init()
    m.background = m.top.findNode("background")
    m.containerLayout = m.top.findNode("containerLayout")
    m.busySpinner = m.top.findNode("busySpinner")
    m.nameLabel = m.top.findNode("nameLabel")
    m.colorInterpolator = m.top.findNode("colorInterpolator")
end sub

sub configureDataSource()
    m.nameLabel.font = getMediumFont(getSize(20))
    m.busySpinner.poster.uri = m.top.itemContent.image

    m.nameLabel.text = m.top.itemContent.title
    if m.top.itemContent.isStartRefresh
        m.busySpinner.control = "start"
    else
        m.busySpinner.control = "stop" 
    end if
    layoutSubview()
end sub

sub itemFocused()
    m.colorInterpolator.fraction = m.top.rowFocusPercent
    if not m.top.rowListHasFocus then m.colorInterpolator.fraction = 0
end sub

sub layoutSubview()
    m.background.width = m.top.width
    m.background.height = m.top.height
    m.busySpinner.poster.width = getSize(45)
    m.busySpinner.poster.height = getSize(45)
    m.containerLayout.translation = [m.top.width / 2, m.top.height / 2]
end sub