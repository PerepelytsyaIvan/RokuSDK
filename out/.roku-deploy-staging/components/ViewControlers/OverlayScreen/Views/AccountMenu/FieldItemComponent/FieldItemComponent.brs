sub init()
    m.background = m.top.findNode("background")
    m.title = m.top.findNode("title")
    m.focusPoster = m.top.findNode("focusPoster")
    m.textLabel = m.top.findNode("textLabel")
    m.errorLabel = m.top.findNode("errorLabel")
end sub

sub configureDataSource()
    m.title.text = m.top.itemContent.title
    m.textLabel.text = m.top.itemContent.description
    m.title.font = getRegularFont(getSize(18))
    m.textLabel.font = getRegularFont(getSize(25))
    m.errorLabel.font = getRegularFont(getSize(14))
    m.errorLabel.text = m.top.itemContent.error
    m.errorLabel.color = m.global.design.wrongAnswerTextColor
    layoutSubviews()
end sub

sub itemFocused()
    if m.top.rowListHasFocus
        m.focusPoster.opacity = m.top.rowFocusPercent
    else
        m.focusPoster.opacity = 0
    end if
end sub

sub layoutSubviews()
    images = [m.background, m.focusPoster]
    m.textLabel.translation = [getSize(10), getSize(45)]
    m.textLabel.width = m.top.width - getSize(20)
    m.textLabel.height = m.top.height - getSize(65)
    for each image in images
        image.translation = [0, getSize(45)]
        image.width = m.top.width
        image.height = m.top.height - getSize(65)
    end for
    m.errorLabel.width = m.background.width
    m.errorLabel.height = getSize(15)
    m.title.translation = [getSize(0), getSize(10)]
    m.errorLabel.translation = [m.background.translation[0] + getSize(4), m.focusPoster.translation[1] + getSize(3) + m.focusPoster.height]
end sub