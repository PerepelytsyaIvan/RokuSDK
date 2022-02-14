sub init()
    initView()
end sub

sub initView()
    m.titleLabel = m.top.findNode("titleLabel")
    m.posterCell = m.top.findNode("posterCell")
end sub

sub OnItemContentChanged()
    itemContent = m.top.itemContent
    m.titleLabel.font = getBoldFont(25)
    m.titleLabel.text = itemContent.title
    if isValid(itemContent.iconUri)
        m.posterCell.uri = itemContent.iconUri
    end if

    layoutSubviews()
end sub

sub layoutSubviews()
    if isValid(m.top.itemContent)
        if isValid(m.top.itemContent.iconUri)
            m.posterCell.width = 34
            m.posterCell.height = 34
            m.titleLabel.width = m.top.width - 40
            m.titleLabel.translation = [45, m.titleLabel.translation[1]]
            m.titleLabel.horizAlign = "left"
        end if
    else
        m.titleLabel.width = m.top.width - 10
    end if

    m.titleLabel.height = m.top.height - 10
end sub