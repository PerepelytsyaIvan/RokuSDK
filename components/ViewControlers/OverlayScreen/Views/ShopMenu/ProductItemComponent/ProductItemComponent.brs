sub init()
    m.background = m.top.findNode("background")
    m.productImage = m.top.findNode("productImage")
    m.maskGroup = m.top.findNode("maskGroup")
    m.titleLabel = m.top.findNode("titleLabel")
    m.descriptionLabel = m.top.findNode("descriptionLabel")
    m.productGroup = m.top.findNode("productGroup")
end sub

sub configureDataSource()
    itemContent = m.top.itemContent
    m.titleLabel.font = getMediumFont(getSize(20))
    m.descriptionLabel.font = getRegularFont(getSize(15))
    m.titleLabel.color = m.global.design.questionTextColor
    m.descriptionLabel.color = m.global.design.questionTextColor
    m.titleLabel.text = itemContent.item.name
    m.descriptionLabel.text = itemContent.item.description
    m.productImage.uri = getImageWithName(itemContent.item.image)
    layoutSubview()
end sub

sub layoutSubview()
    m.background.width = m.top.width
    m.background.height = m.top.height
    m.maskGroup.maskSize = [getSize(100), m.top.height]
    m.productImage.width = m.top.height
    m.productImage.height = m.top.height
    m.descriptionLabel.width = m.top.width - m.productImage.width - getSize(13)
    m.titleLabel.width = m.top.width - m.productImage.width - getSize(13)
    m.titleLabel.height = getSize(30)
end sub