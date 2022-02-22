sub init()
    m.itemComponentGroup = m.top.findNode("itemComponentGroup")
    m.ratingPoster = m.top.findNode("ratingPoster")
    m.titleLabel = m.top.findNode("titleLabel")
end sub

sub configureDataSource()
    m.titleLabel.font = getBoldFont(25)
    m.titleLabel.text = m.top.dataSource.title
    m.ratingPoster.uri = m.top.dataSource.image
    layoutSubviews()
end sub

sub onChangePercentFocus(event)
    percent = event.getData()
end sub

sub layoutSubviews()
    if m.titleLabel.text = "AVG"
        m.ratingPoster.translation = [m.titleLabel.localBoundingRect().width + 15, 0]
    else if m.titleLabel.text <> ""
        m.titleLabel.translation = [m.ratingPoster.width + 15, 2.5]
    end if
    m.titleLabel.height = 40
    boundingRectLocal = m.itemComponentGroup.localBoundingRect()
    m.top.width = boundingRectLocal.width
    m.top.height = 40
end sub
