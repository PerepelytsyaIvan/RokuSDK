sub init()
    m.titleLabel = m.top.findNode("titleLabel")
    m.iconElement = m.top.findNode("iconElement")
end sub

sub configureDataSource()
    m.titleLabel.font = getMediumFont(20)
    m.titleLabel.text = m.top.dataSource.title
    m.iconElement.uri = m.top.dataSource.image
    if IsValid(m.top.dataSource.fontSize)
        m.titleLabel.font = getRegularFont(m.top.dataSource.fontSize)
    end if
    layoutSubview()
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

    m.top.width = widthElement
    m.top.height = heightElement
end sub