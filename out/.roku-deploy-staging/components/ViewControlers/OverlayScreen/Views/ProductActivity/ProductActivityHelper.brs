sub initView()
    m.activityLayout = m.top.findNode("activityLayout")
    m.activityContainerGroup = m.top.findNode("activityContainerGroup")
    m.centralViewsLayout = m.top.findNode("centralViewsLayout")
    m.timeGroup = m.top.findNode("timeGroup")

    m.backgroundActivity = m.top.findNode("backgroundActivity")
    m.logoActivity = m.top.findNode("logoActivity")
    m.productImage = m.top.findNode("productImage")

    m.questionLabel = m.top.findNode("questionLabel")
    m.priceLabel = m.top.findNode("priceLabel")
    m.timeLabel = m.top.findNode("timeLabel")
    m.unitTime = m.top.findNode("unitTime")

    m.collectionView = m.top.findNode("collectionView")
    m.collectionViewLeftButton = m.top.findNode("collectionViewLeftButton")

    m.separatorL = m.top.findNode("separatorL")
    m.separatorR = m.top.findNode("separatorR")

    m.translationAnimation = m.top.findNode("translationAnimation")
    m.translationInterpolator = m.top.findNode("translationInterpolator")
end sub

sub layoutViews()
    if m.questionLabel.boundingRect().width > getSize(800) 
        m.questionLabel.width = getSize(800)
    else
        m.questionLabel.width = m.questionLabel.boundingRect().width
    end if

    m.priceLabel.width = m.priceLabel.boundingRect().width

    m.activityContainerGroup.translation = getSizeMaskGroupWith([0, 1080])

    m.backgroundActivity.width = getSize(1920)
    m.backgroundActivity.height = getSize(150)
    m.questionLabel.height = getSize(80)
    m.priceLabel.height = getSize(80)
    m.unitTime.height = m.timeLabel.boundingRect().height - 5
    array = [m.logoActivity, m.productImage]
    arraySeparator = [m.separatorL, m.separatorR]

    for each separator in arraySeparator
        separator.width = getSize(2)
        separator.height = getSize(80)
    end for

    for each item in array
        item.width = getSize(80)
        item.height = getSize(80)
    end for

    m.activityLayout.translation = getSizeMaskGroupWith([50, 50])
    m.centralViewsLayout.translation = [(getWidthScreen() - getSize(360)) - m.centralViewsLayout.localBoundingRect().width, m.activityLayout.translation[1]]
    m.collectionViewLeftButton.translation = [(getWidthScreen() - getSize(250)) + (getSize(250) - m.collectionViewLeftButton.localBoundingRect().width) / 2, getSize(112)]

    if m.productImage.uri = getImageWithName("")
        m.productImage.width = 0
    end if
end sub

sub configureDesign()
    m.questionLabel.color = m.global.design.questionTextColor
    m.priceLabel.color = m.global.design.questionTextColor
    m.logoActivity.uri = m.global.design.logoImage
    m.backgroundActivity.uri = m.global.design.backgrounImage
    m.questionLabel.font = getBoldFont(getSize(30))
    m.priceLabel.font = getBoldFont(getSize(30))
    m.timeLabel.font = getBoldFont(getSize(60))
    m.unitTime.font = getMediumFont(getSize(40))
end sub

sub configureLabel(seconds)
    time = getTime(seconds)
    m.timeLabel.text = time[0]
    m.unitTime.text = time[1]
    m.timeGroup.translation = [(getSize(1920) - getSize(260)) + ((getSize(260) - m.timeGroup.localboundingRect().width) / 2), (m.timeGroup.localboundingRect().height - getSize(30)) / 2]
end sub