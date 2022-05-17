sub init()
    initView()
end sub

sub initView()
    m.containerView = m.top.findNode("containerView")
    m.pointsImage = m.top.findNode("pointsImage")
    m.pointLabel = m.top.findNode("pointLabel")
    m.posterCell = m.top.findNode("posterCell")
    m.titleLabel = m.top.findNode("titleLabel")
    m.focusCell = m.top.findNode("focusCell")
end sub

sub configureDataSource()
    m.titleLabel.font = getBoldFont(getSize(30))
    m.pointLabel.font = getMediumFont(getSize(20))
    m.pointLabel.color = m.global.design.questionTextColor
    m.titleLabel.color = m.global.design.questionTextColor
    m.titleLabel.text = m.top.dataSource.answer
    reward = convertIntToStr(m.top.dataSource.reward)
    if reward.len() > 4
        points = roundInt(reward.toInt()).toStr() + "K"
        m.pointLabel.text = points
    else
        m.pointLabel.text = reward
    end if

    m.posterCell.uri = getImageWithName(m.top.dataSource.image)
    m.pointsImage.uri = "pkg:/images/predictionIcon.png"
    layoutSubviews()
end sub

sub roundInt(number) as object
    numberToStr = number.toStr()
    count = (numberToStr.len() \ 2)
    firsPart = numberToStr.left(count)
    secondPart = numberToStr.Right(numberToStr.len() - count)
    arrayNumber = numberToStr.split(firsPart)
    numberFloat = (firsPart + "." + secondPart).toFloat()
    math = MathUtil()
    round = math.round(numberFloat)
    return round
end sub

sub onChangePercentFocus()
    m.focusCell.opacity = m.top.percentFocus
end sub

sub layoutSubviews()
    m.pointsImage.width = getSize(60)
    m.pointsImage.height = getSize(60)
    m.pointLabel.width = getSize(50)
    m.pointLabel.height = getSize(50)
    m.pointLabel.translation = [getSize(5), getSize(5)]

    m.containerView.itemSpacings = [getSize(5)]
    m.focusCell.width = (m.containerView.boundingRect().width) - (m.pointsImage.height / 2) + getSize(10)

    if m.posterCell.uri <> getImageWithName("")
        m.posterCell.width = getSize(30)
        m.posterCell.height = getSize(30)
        m.containerView.itemSpacings = [getSize(10)]
        m.focusCell.width = (m.containerView.boundingRect().width) - (m.pointsImage.height / 2) + getSize(20)
    end if
    m.focusCell.height = m.pointsImage.height - getSize(2)
    m.focusCell.translation = [(m.pointsImage.height / 2), getSize(2)]
    m.titleLabel.width = m.titleLabel.boundingRect().width
    m.titleLabel.height = getSize(60)

    m.containerView.translation = [0, getSize(60) / 2]

    boundingRect = m.containerView.boundingRect()
    m.top.width = m.containerView.boundingRect().width 
    m.top.height = getSize(60)
end sub
