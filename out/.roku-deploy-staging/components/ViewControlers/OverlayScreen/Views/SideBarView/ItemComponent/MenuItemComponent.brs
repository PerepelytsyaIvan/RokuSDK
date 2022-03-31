sub init()
    m.unfocusedPoster = m.top.findNode("unfocusedPoster")
    m.focusedPoster = m.top.findNode("focusedPoster")
    m.imageCell = m.top.findNode("imageCell")

    m.titleGroup = m.top.findNode("titleGroup")
    m.maskTitle = m.top.findNode("maskTitle")
    m.title = m.top.findNode("title")
    m.colorInterpolator = m.top.findNode("colorInterpolator")
end sub

sub configureDataSource()
    itemContent = m.top.itemContent
    m.title.font = getBoldFont(12)
    m.imageCell.uri = itemContent.image
    m.title.text = itemContent.title
    if itemContent.title = ""
        m.titleGroup.visible = false
    end if
    layoutSubviews()
end sub

sub itemFocused()
    focusPercent = m.top.focusPercent
    m.focusedPoster.opacity = m.top.focusPercent
    m.titleGroup.opacity = m.top.focusPercent
    m.colorInterpolator.fraction = m.top.focusPercent
    if not m.top.rowListHasFocus
        m.focusedPoster.opacity = 0
        m.titleGroup.opacity = 0
        m.colorInterpolator.fraction = 0
    end if
end sub 

sub layoutSubviews()
    imageArray = [m.unfocusedPoster, m.focusedPoster]

    for each image in imageArray
        image.width = m.top.width
        image.height = m.top.width
    end for

    m.imageCell.width = m.top.width - getSize(35)
    m.imageCell.height = m.top.width - getSize(35)
    m.imageCell.translation = [(m.top.width - m.imageCell.height) / 2, (m.top.width - m.imageCell.height) / 2]

    if m.imageCell.uri = "pkg:/images/prediction.png"
        m.imageCell.translation = [m.imageCell.translation[0], m.imageCell.translation[1] - 5]
        m.imageCell.height = m.imageCell.height + 10
    end if

    if isInvalid(m.top.itemContent) then return
    if m.top.itemContent.image = "pkg:/images/dotsSideBar.png"
        m.imageCell.height = m.top.width - getSize(35)
        m.imageCell.width = getSize(6)
        m.imageCell.translation = [getSize(37), m.imageCell.translation[1]]
        m.unfocusedPoster.visible = false
    else if m.top.itemContent.image = "pkg:/images/closeSideBar.png"
        m.imageCell.height = m.top.width - getSize(45)
        m.imageCell.width =  m.top.width - getSize(45)
        m.imageCell.translation = [getSize(35),  (m.top.width - m.imageCell.height) / 2]
        m.unfocusedPoster.visible = false
    end if

    m.title.width = m.title.boundingRect().width
    m.title.height = 10
    m.maskTitle.width = m.title.width + 6
    m.maskTitle.height = m.title.height + 4
    m.title.translation = [3, 2]
    m.titleGroup.translation = [(m.top.width - m.maskTitle.width) / 2, m.unfocusedPoster.height + 10]
end sub