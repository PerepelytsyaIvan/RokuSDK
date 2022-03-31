sub init()
    m.containterView = m.top.findNode("containterView")
    m.numberLabel = m.top.findNode("numberLabel")
    m.guestPoster = m.top.findNode("guestPoster")
    m.nameLabel = m.top.findNode("nameLabel")
    m.pointsLabel = m.top.findNode("pointsLabel")
    m.background = m.top.findNode("background")
    m.focusCell = m.top.findNode("focusCell")
end sub

sub configureUI()
    m.numberLabel.font = getMediumFont(20)
    m.nameLabel.font = getMediumFont(20)
    m.pointsLabel.font = getMediumFont(20)
    m.pointsLabel.color = m.global.design.buttonBackgroundColor
end sub

sub itemFocused()
    m.background.opacity = 1 - m.top.rowFocusPercent
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
    m.focusCell.width = m.top.width
    m.focusCell.height = m.top.height
    m.numberLabel.translation = [20, 0]
    m.numberLabel.height = m.top.height
    m.numberLabel.width = 30

    m.guestPoster.width = 40
    m.guestPoster.height = 40
    m.guestPoster.translation = [m.numberLabel.translation[0] + m.numberLabel.width + 10, (m.top.height - m.guestPoster.height) / 2]

    m.nameLabel.height = m.top.height
    m.nameLabel.width = 190
    m.nameLabel.translation = [m.guestPoster.translation[0] + m.guestPoster.width + 20, 0]

    m.pointsLabel.width = 80
    m.pointsLabel.height = m.top.height
    m.pointsLabel.translation = [m.nameLabel.width + m.nameLabel.translation[0] + 20, 0]
end sub