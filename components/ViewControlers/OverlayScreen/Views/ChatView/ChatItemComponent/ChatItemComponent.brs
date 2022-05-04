sub init()
    m.posterCell = m.top.findNode("posterCell")
    m.username = m.top.findNode("username")
    m.username.font = getRegularFont(getSize(20))
    m.emojiContainer = m.top.findNode("emojiContainer")
    m.maskGroup = m.top.findNode("maskGroup")
end sub

sub configureDataSource()
    itemContent = m.top.itemContent
    m.username.text = itemContent.item.username + ":"
    m.posterCell.uri = getImageWithName(itemContent.item.avatar)

    for each item in itemContent.emojies
        poster = m.emojiContainer.createChild("Poster")
        poster.uri = getImageWithName(item.thumbnail)
        poster.width = getSize(55)
        poster.height = getSize(55)
    end for
    layoutSubviews()
end sub

sub itemFocused()
end sub

sub layoutSubviews()
    m.posterCell.width = getSize(35)
    m.posterCell.height = getSize(35)
    m.maskGroup.maskSize = [getSize(35), getSize(35)]
    m.username.height = m.posterCell.height
    if m.username.boundingrect().width > m.top.width
        m.username.width = m.top.width
    end if
    
    if m.top.height = getSize(55)
        m.username.vertAlign = "center"
        m.maskGroup.translation = [0, (m.top.height - m.posterCell.height) + ((m.top.height - m.posterCell.height) / 2)]
        m.username.translation = [m.posterCell.width + getSize(15), m.maskGroup.translation[1]]
        m.emojiContainer.translation = [m.username.translation[0] + m.username.boundingrect().width + getSize(10), 0]
    else
        m.username.vertAlign = "center"
        m.username.translation = [m.posterCell.width + getSize(15), 0]
        m.emojiContainer.translation = [m.username.translation[0], m.username.height]
    end if
end sub