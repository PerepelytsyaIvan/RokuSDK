sub init()
    m.titleLabel = m.top.findNode("titleLabel")
    m.focusElement = m.top.findNode("focusElement")
    m.iconElement = m.top.findNode("iconElement")
end sub

sub configureDataSource()
    m.titleLabel.font = getMediumFont(20)
    m.titleLabel.text = m.top.dataSource.title
    m.iconElement.uri = m.top.dataSource.image
    layoutSubview()
end sub

sub onChangePercentFocus()
    if m.top.percentFocus > 0.2
        m.focusElement.opacity = m.top.percentFocus
    else
        m.focusElement.opacity = 0
    end if
end sub

sub layoutSubview()
    m.titleLabel.width = m.top.dataSource.width
    m.titleLabel.height = m.top.dataSource.height
    m.iconElement.height = 20
    m.iconElement.width = 30
    m.iconElement.translation = [(m.top.dataSource.height - 30) / 2,  (m.top.dataSource.height - 20) / 2]
    topBoundingRect = m.top.boundingRect()

    widthElement = m.top.dataSource.width + topBoundingRect.x
    heightElement = topBoundingRect.height + (topBoundingRect.y * 2)

    if m.top.dataSource.title = "0"
        m.focusElement.width = 40
        m.focusElement.height = 40
        m.focusElement.translation = [(widthElement - m.focusElement.width) / 2, 0]
    else
        m.focusElement.width = widthElement
        m.focusElement.height = heightElement
    end if

    m.top.width = widthElement
    m.top.height = heightElement
end sub