sub init()
    m.focusedInterpolator = m.top.findNode("focusedInterpolator")
    m.itemComponentGroup = m.top.findNode("itemComponentGroup")
    m.focusPoster = m.top.findNode("focusPoster")
    m.ratingLayout = m.top.findNode("ratingLayout")
end sub

sub configureDataSource()
    countStar = m.top.dataSource.title.toInt()

    for i = 0 to countStar - 1
        star = m.ratingLayout.createChild("Poster")
        star.width = 25
        star.height = 25
        star.uri = getImageWithName(m.global.design.fullStarIcon)
    end for

    layoutSubviews()
end sub

sub onChangePercentFocus(event)
    percent = event.getData()
    m.focusedInterpolator.fraction = percent
end sub

sub layoutSubviews()
    boundingRectLayout = m.ratingLayout.localBoundingRect()
    m.focusPoster.width = boundingRectLayout.width + 20
    boundingRectLocal = m.itemComponentGroup.localBoundingRect()
    m.top.width = boundingRectLocal.width
    m.top.height = 40
    m.focusPoster.height = m.top.height
    m.ratingLayout.translation = [10 , (m.top.height - boundingRectLayout.height) / 2]
end sub
