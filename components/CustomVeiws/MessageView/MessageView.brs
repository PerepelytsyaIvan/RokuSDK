sub init() 
    m.autoScrollGroup = m.top.findNode("autoScrollGroup")
    m.translationAnimation = m.top.findNode("translationAnimation")
    m.iterpolator = m.top.findNode("iterpolator")
    m.iterpolatorVisible = m.top.findNode("iterpolatorVisible")
end sub

sub configureDataSource()
    elementContent = m.top.dataSource
    view = m.autoScrollGroup.createChild("ChatItemComponent")
    view.id = m.autoScrollGroup.getChildCount().toStr()
    view.itemContent = elementContent
    width = getWidthForText(elementContent.item.username, getRegularFont(20))
    if elementContent.emojies.count() = 1 and width < 270
        view.width = 355
        view.height = 55
    else
        view.width = 355
        view.height = 80
    end if

    m.iterpolatorVisible.fieldToInterp = view.id + ".opacity"

    boundingRect = m.autoScrollGroup.boundingRect()

    if boundingRect.height > m.top.height
        view.opacity = 0
        configureAutoScroll()
    end if
end sub

sub configureAutoScroll()
    m.translationAnimation.control = "finish"
    translationY = m.top.height - m.autoScrollGroup.boundingRect().height
    m.iterpolator.keyValue = [m.iterpolator.keyValue[1], [m.iterpolator.keyValue[1][0], translationY]]
    m.translationAnimation.control = "start"
end sub