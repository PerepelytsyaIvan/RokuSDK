sub init()
    m.itemComponentGroup = m.top.findNode("itemComponentGroup")
    m.ratingPoster = m.top.findNode("ratingPoster")
    m.titleLabel = m.top.findNode("titleLabel")
end sub

sub configureDataSource()
    m.titleLabel.font = getBoldFont(getSize(40))
    m.titleLabel.text = m.top.dataSource.title
    m.ratingPoster.uri = m.top.dataSource.image
    layoutSubviews()
end sub

sub onChangePercentFocus(event)
    percent = event.getData()
end sub

sub layoutSubviews()
    if m.titleLabel.text = "AVG"
        m.ratingPoster.translation = [m.titleLabel.localBoundingRect().width + getSize(15), 0]
    else if m.titleLabel.text <> ""
        m.titleLabel.translation = [m.ratingPoster.width + getSize(15), getSize(2.5)]
    end if
    m.titleLabel.height = getSize(40)
    boundingRectLocal = m.itemComponentGroup.localBoundingRect()
    m.top.width = boundingRectLocal.width
    m.top.height = getSize(40)
    m.ratingPoster.width = getSize(40)
    m.ratingPoster.height = getSize(40)
end sub
