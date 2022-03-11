sub init()
    m.unfocusedPoster = m.top.findNode("unfocusedPoster")
    m.focusedPoster = m.top.findNode("focusedPoster")
    m.imageCell = m.top.findNode("imageCell")
end sub

sub configureDataSource()
    itemContent = m.top.itemContent
    m.imageCell.uri = itemContent.image
    layoutSubviews()
end sub

sub itemFocused()
    focusPercent = m.top.focusPercent
    m.focusedPoster.opacity = m.top.focusPercent

    if not m.top.rowListHasFocus
        m.focusedPoster.opacity = 0
    end if
end sub 

sub layoutSubviews()
    imageArray = [m.unfocusedPoster, m.focusedPoster]

    for each image in imageArray
        image.width = m.top.width
        image.height = m.top.height
    end for

    if IsValid(m.top.width)
        m.imageCell.width = m.top.width - getSize(35)
    end if

    if IsValid(m.top.height)
        m.imageCell.height = m.top.height - getSize(35)
        m.imageCell.translation = [(m.top.height - m.imageCell.height) / 2, (m.top.height - m.imageCell.height) / 2]
    end if

    if isInvalid(m.top.itemContent) then return
    if m.top.itemContent.image = "pkg:/images/dotsSideBar.png"
        m.imageCell.height = m.top.height - getSize(35)
        m.imageCell.width = getSize(6)
        m.imageCell.translation = [getSize(37), m.imageCell.translation[1]]
        m.unfocusedPoster.visible = false
    else if m.top.itemContent.image = "pkg:/images/closeSideBar.png"
        m.imageCell.height = m.top.height - getSize(45)
        m.imageCell.width =  m.top.height - getSize(45)
        m.imageCell.translation = [getSize(35),  (m.top.height - m.imageCell.height) / 2]
        m.unfocusedPoster.visible = false
    end if
end sub