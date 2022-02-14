sub init()
    m.rating = m.top.findNode("rating")
    m.titleLabel = m.top.findNode("titleLabel")
end sub

sub OnItemContentChanged()
    m.titleLabel.font = getBoldFont(25)
    m.rating.uri = m.top.image

    if m.top.title <> ""
        m.titleLabel.text = m.top.title
        m.titleLabel.translation = [40, 2]         
        if m.top.title = "AVG"
            m.rating.translation = [40, 0]         
        end if
    end if
    layoutSubviews()
end sub

sub layoutSubviews()
    m.rating.width = m.top.height 
    m.rating.height = m.top.height 
    m.titleLabel.height = m.top.height
end sub

