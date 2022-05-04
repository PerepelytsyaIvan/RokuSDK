sub init()
    m.title = m.top.findNode("title")
end sub

sub configureDataSource()
    m.title.font = getRegularFont(getSize(23))
    m.title.text = m.top.itemContent.title
    layoutSubviews()
end sub

sub layoutSubviews()
    m.title.width = m.top.width
    m.title.height = m.top.height
end sub