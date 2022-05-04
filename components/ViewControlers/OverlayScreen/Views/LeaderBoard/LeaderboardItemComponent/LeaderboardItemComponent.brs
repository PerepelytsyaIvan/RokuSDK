sub init()
    m.containterView = m.top.findNode("containterView")
    m.numberLabel = m.top.findNode("numberLabel")
    m.guestPoster = m.top.findNode("guestPoster")
    m.nameLabel = m.top.findNode("nameLabel")
    m.pointsLabel = m.top.findNode("pointsLabel")
    m.background = m.top.findNode("background")
    m.colorInterpolator = m.top.findNode("colorInterpolator")
end sub

sub configureUI()
    m.numberLabel.font = getMediumFont(getSize(20))
    m.nameLabel.font = getMediumFont(getSize(20))
    m.pointsLabel.font = getMediumFont(getSize(20))
    m.pointsLabel.color = m.global.design.buttonBackgroundColor
end sub

sub itemFocused()
    m.colorInterpolator.fraction = m.top.rowFocusPercent
    if not m.top.rowListHasFocus then m.colorInterpolator.fraction = 0
end sub

sub configureDataSource()
    configureUI()
    content = m.top.itemContent
    m.numberLabel.text = content.rank
    m.guestPoster.uri = getImageWithName(content.item.thumbnail)
    m.nameLabel.text = content.item.name
    m.pointsLabel.text = content.item.amount_of_credits_won.toStr()
    layoutSubviews()
end sub

sub layoutSubviews()
    m.background.width = m.top.width
    m.background.height = m.top.height
    m.numberLabel.translation = [getSize(20), 0]
    m.numberLabel.height = m.top.height
    m.numberLabel.width = getSize(30)

    m.guestPoster.width = getSize(40)
    m.guestPoster.height = getSize(40)
    m.guestPoster.translation = [m.numberLabel.translation[0] + m.numberLabel.width + getSize(10), (m.top.height - m.guestPoster.height) / 2]

    m.nameLabel.height = m.top.height
    m.nameLabel.width = getSize(190)
    m.nameLabel.translation = [m.guestPoster.translation[0] + m.guestPoster.width + getSize(20), 0]

    m.pointsLabel.width = getSize(80)
    m.pointsLabel.height = m.top.height
    m.pointsLabel.translation = [m.nameLabel.width + m.nameLabel.translation[0] + getSize(20), 0]
end sub