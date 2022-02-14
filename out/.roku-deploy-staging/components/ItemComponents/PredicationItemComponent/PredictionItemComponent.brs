sub init()
    initView()
end sub

sub initView()
    m.titleLabel = m.top.findNode("titleLabel")
    m.posterCell = m.top.findNode("posterCell")
    m.posterUnfocused = m.top.findNode("posterUnfocused")
    m.posterFocused = m.top.findNode("posterFocused")
    m.pointLabel = m.top.findNode("pointLabel")
    m.ptsLabel = m.top.findNode("ptsLabel")
end sub

sub OnItemContentChanged()
    itemContent = m.top.itemContent
    m.titleLabel.font = getBoldFont(25)
    m.pointLabel.font = getRegularFont(15)
    m.ptsLabel.font = getRegularFont(15)
    m.titleLabel.text = itemContent.title
    if isValid(itemContent.iconUri)
        m.posterCell.uri = itemContent.iconUri
    end if
    m.pointLabel.text = itemContent.reward
    m.ptsLabel.text = "pts"
    layoutSubviews()
end sub

sub OnItemFocusChanged(event)
    m.posterFocused.opacity = m.top.focusPercent
end sub

sub layoutSubviews()
    m.titleLabel.width = m.top.width - 60 - 10
    m.titleLabel.height = m.top.height
    m.titleLabel.translation = [60, 0]
    m.posterCell.translation = [0,0]
    m.posterCell.width = m.top.height
    m.posterCell.height = m.top.height
    m.posterUnfocused.translation = [m.top.height / 2, 3]
    m.posterFocused.translation = [m.top.height / 2, 3]
    m.posterFocused.width = m.top.width - (m.top.height / 2)
    m.posterUnfocused.width = m.top.width - (m.top.height / 2)
    m.posterFocused.height = m.top.height - 6
    m.posterUnfocused.height = m.top.height - 6
    m.pointLabel.width = m.top.height - 8
    m.pointLabel.translation = [4, 13]
    m.ptsLabel.width = m.top.height - 8
    m.ptsLabel.translation = [4, m.pointLabel.boundingRect().height + 5]
end sub