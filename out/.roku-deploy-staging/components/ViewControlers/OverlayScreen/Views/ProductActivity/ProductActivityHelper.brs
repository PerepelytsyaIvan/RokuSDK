sub initView()
    m.activityLayout = m.top.findNode("activityLayout")
    m.activityContainerGroup = m.top.findNode("activityContainerGroup")
    m.centralViewsLayout = m.top.findNode("centralViewsLayout")
    m.timeGroup = m.top.findNode("timeGroup")
    m.priceGroup = m.top.findNode("priceGroup")

    m.backgroundActivity = m.top.findNode("backgroundActivity")
    m.logoActivity = m.top.findNode("logoActivity")
    m.productImage = m.top.findNode("productImage")

    m.questionLabel = m.top.findNode("questionLabel")
    m.priceLabel = m.top.findNode("priceLabel")
    m.timeLabel = m.top.findNode("timeLabel")
    m.unitTime = m.top.findNode("unitTime")
    m.discountLabel = m.top.findNode("discountLabel")

    m.collectionView = m.top.findNode("collectionView")
    m.collectionViewLeftButton = m.top.findNode("collectionViewLeftButton")

    m.separatorL = m.top.findNode("separatorL")
    m.separatorR = m.top.findNode("separatorR")

    m.translationAnimation = m.top.findNode("translationAnimation")
    m.translationInterpolator = m.top.findNode("translationInterpolator")

    m.hidingAnimation = m.top.findNode("hidingAnimation")
    m.hidingInterpolator = m.top.findNode("hidingInterpolator")

    m.numberLabel = m.top.findNode("numberLabel")

    m.collectionWithLabelGroup = m.top.findNode("collectionWithLabelGroup")
end sub

sub configureObservers()
    m.collectionView.observeField("item", "didSelectButton")
    m.collectionViewLeftButton.observeField("item", "didSelectButtonLeft")
    m.top.observeField("focusedChild", "onChangeFocusedChild")
end sub

sub layoutViews()
    if m.questionLabel.boundingRect().width > getSize(800) 
        m.questionLabel.width = getSize(800)
    else
        m.questionLabel.width = m.questionLabel.boundingRect().width
    end if

    m.discountLabel.width = m.discountLabel.boundingRect().width
    if m.discountLabel.width > 20
        m.priceGroup.addItemSpacingAfterChild = true
        m.priceGroup.itemSpacings = [5]
        m.priceLabel.width = m.discountLabel.width
    else
        m.priceGroup.addItemSpacingAfterChild = false
        m.priceGroup.itemSpacings = [-20]
        m.priceLabel.width = m.priceLabel.boundingRect().width
    end if

    m.activityContainerGroup.translation = getSizeMaskGroupWith([0, 1080])

    m.backgroundActivity.width = getSize(1920)
    m.backgroundActivity.height = getSize(150)
    m.questionLabel.height = getSize(80)
    m.priceGroup.translation = [m.priceGroup.boundingRect().width / 2, m.priceGroup.boundingRect().height / 2]
    m.unitTime.height = m.timeLabel.boundingRect().height - 5
    m.collectionWithLabelGroup.itemSpacings = [0]
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
    m.centralViewsLayout.translation = [(getWidthScreen() - getSize(360)) - m.centralViewsLayout.localBoundingRect().width, 90]
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
    m.numberLabel.font = getRegularFont(0)
    m.discountLabel.font = getRegularFont(20)
end sub

sub configureLabel(seconds)
    hidingTime = gmdate(seconds)
    array = hidingTime.split("m")
    if array.count() = 2
        m.timeLabel.text = array[0] + "m"
        m.unitTime.text = array[1]
    else
        m.timeLabel.text = array[0]
        m.unitTime.text = "sec"
    end if
    m.timeGroup.translation = [(getSize(1920) - getSize(260)) + ((getSize(260) - m.timeGroup.localboundingRect().width) / 2), (m.timeGroup.localboundingRect().height - getSize(30)) / 2]
end sub

sub createPersonalArea(dataSource)
    hideActivity()
    if isInvalid(m.personalArea) then m.personalArea = m.top.createChild("PersonalArea")
    m.personalArea.id = "personalArea"
    m.personalArea.opacity = 0
    m.personalArea.accountRoute = m.top.accountRoute
    m.personalArea.dataSource = dataSource
    m.personalArea.setFocus(true)
    m.personalArea.observeField("pressBackButton", "didSelectBackButton")
    m.hidingInterpolator.fieldToInterp = m.personalArea.id + ".opacity"
    m.hidingInterpolator.keyValue = [0, 1]
    m.hidingAnimation.control = "start"
end sub

sub hidingPersonalArea()
    m.hidingInterpolator.keyValue = [1, 0]
    m.hidingAnimation.control = "start"
end sub