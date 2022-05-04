sub init()
    m.unfocusedPoster = m.top.findNode("unfocusedPoster")
    m.imageCell = m.top.findNode("imageCell")
    m.colorInterpolatorFocus = m.top.findNode("colorInterpolatorFocus")
    m.titleGroup = m.top.findNode("titleGroup")
    m.maskTitle = m.top.findNode("maskTitle")
    m.title = m.top.findNode("title")
    m.colorInterpolator = m.top.findNode("colorInterpolator")
    m.colorInterpolatorMask = m.top.findNode("colorInterpolatorMask")
    m.colorInterpolatorTitle = m.top.findNode("colorInterpolatorTitle")
end sub

sub configureDataSource()
    itemContent = m.top.itemContent
    m.title.font = getBoldFont(getSize(16))
    m.imageCell.uri = itemContent.image
    m.imageCell.width = itemContent.iconWidth
    m.imageCell.height = itemContent.iconHeight
    m.title.text = itemContent.title
    if itemContent.title = ""
        m.titleGroup.visible = false
    end if
    layoutSubviews()
end sub

sub itemFocused()
    focusPercent = m.top.focusPercent
    m.colorInterpolatorFocus.fraction = m.top.focusPercent 
    m.colorInterpolator.fraction = m.top.focusPercent
    m.colorInterpolatorMask.fraction = m.top.focusPercent
    m.colorInterpolatorTitle.fraction = m.top.focusPercent
    if not m.top.rowListHasFocus
        m.colorInterpolatorFocus.fraction = 0
        m.colorInterpolator.fraction = 0
        m.colorInterpolatorMask.fraction = 0
        m.colorInterpolatorTitle.fraction = 0   
    end if
end sub 

sub layoutSubviews()
    imageArray = [m.unfocusedPoster]

    for each image in imageArray
        image.width = m.top.width
        image.height = m.top.width
    end for

    m.imageCell.translation = [(m.top.width - m.imageCell.width) / 2, ((m.top.width - m.imageCell.height) / 2)]

    if isInvalid(m.top.itemContent) then return
    ' if m.top.itemContent.image = "pkg:/images/dotsSideBar.png"
    '     m.imageCell.height = getSize(30)
    '     m.imageCell.width = getSize(6)
    '     m.imageCell.translation = [getSize(50), (m.top.width - m.imageCell.height) / 2]
    ' else if m.top.itemContent.image = "pkg:/images/closeSideBar.png"
    '     m.imageCell.height = getSize(20)
    '     m.imageCell.width =  getSize(20)
    '     m.imageCell.translation = [getSize(50),  (m.top.width - m.imageCell.height) / 2]
    ' end if

    m.title.width = m.title.boundingRect().width
    m.title.height = getSize(10)
    m.maskTitle.width = m.title.width + getSize(10)
    m.maskTitle.height = m.title.height + getSize(10)
    m.title.translation = [getSize(5), getSize(5)]
    m.titleGroup.translation = [(m.top.width - m.maskTitle.width) / 2, m.unfocusedPoster.height + getSize(10)]
end sub