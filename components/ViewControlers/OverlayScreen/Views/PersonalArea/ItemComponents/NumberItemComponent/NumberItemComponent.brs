sub init()
    m.countryLabel = m.top.findNode("countryLabel")
    m.codeLabel = m.top.findNode("codeLabel")
    m.background = m.top.findNode("background")
    m.focusCell = m.top.findNode("focusCell")
end sub

sub configureDataSource()
    m.countryLabel.font = getRegularFont(25)
    m.codeLabel.font = getRegularFont(25)
    m.codeLabel.text = m.top.itemContent.item.code
    m.countryLabel.text = m.top.itemContent.item.country
    layoutSubviews()
end sub

sub itemFocused()
    m.background.opacity = 1 - m.top.rowFocusPercent
    if not m.top.rowListHasFocus
        m.background.opacity = 1
    end if
end sub

sub layoutSubviews()
    posters = [m.background, m.focusCell]

    for each poster in posters
        poster.width = m.top.width
        poster.height = m.top.height
    end for

    m.codeLabel.translation = [20, 0]
    m.codeLabel.height = m.top.height
    m.countryLabel.height = m.top.height
    m.countryLabel.translation = [m.codeLabel.translation[0] + m.codeLabel.width + 10, 0]
    if isValid(m.top.itemContent) 
        if IsValid(m.top.itemContent.item.isNumberPhone)
            m.codeLabel.width = m.top.width
        end if
    end if
end sub