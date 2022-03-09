sub init()
    m.focusedInterpolator = m.top.findNode("focusedInterpolator")
    m.itemComponentGroup = m.top.findNode("itemComponentGroup")
    m.focusPoster = m.top.findNode("focusPoster")
    m.ratingLayout = m.top.findNode("ratingLayout")
end sub

sub configureDataSource()
    countStar = m.top.itemContent.componentDataSource.title.toInt()

    for i = 0 to countStar - 1
        star = m.ratingLayout.createChild("Poster")
        star.width = getSize(30)
        star.height = getSize(30)
        star.uri = getImageWithName(m.global.design.fullStarIcon)
    end for
    m.ratingLayout.itemSpacings = [getSize(5)]
    layoutSubviews()
end sub

sub onChangePercentFocus(event)
    percent = event.getData()
    m.focusedInterpolator.fraction = percent
end sub

sub layoutSubviews()
    boundingRectLayout = m.ratingLayout.localBoundingRect()
    m.focusPoster.width = boundingRectLayout.width + getSize(20)
    boundingRectLocal = m.itemComponentGroup.localBoundingRect()
    m.focusPoster.height = m.top.height
    m.ratingLayout.translation = [getSize(10) , (m.top.height - boundingRectLayout.height) / 2]
    m.top.widthElement = boundingRectLocal.width
    m.top.heightElement = getSize(60)
end sub
