sub init()
    m.top.setFocus(true)
    m.loadingIndicator = m.top.findNode("loadingProgress")
    m.networkLayerManager = CreateObject("roSGNode", "NetworkLayerManager")
    m.background = m.top.findNode("background")
    m.leaderList = m.top.findNode("leaderList")
    m.layoutGroup = m.top.findNode("layoutGroup")
    m.guestPoster = m.top.findNode("guestPoster")
    m.titleLabel = m.top.findNode("titleLabel")
    m.ptsLabel = m.top.findNode("ptsLabel")
    m.separator = m.top.findNode("separator")
    m.rankLabel = m.top.findNode("rankLabel")
    m.labelsLayoutGroup = m.top.findNode("labelsLayoutGroup")
    m.subTitle = m.top.findNode("subTitle")
    m.title = m.top.findNode("title")
    m.vertSeparator = m.top.findNode("vertSeparator")
    m.sectionGroup = m.top.findNode("sectionGroup")
    m.rankSectionLabel = m.top.findNode("rankSectionLabel")
    m.nameSectionLabel = m.top.findNode("nameSectionLabel")
    m.pointSectionLabel = m.top.findNode("pointSectionLabel")
    m.refreshView = m.top.findNode("refreshView")
    m.top.observeField("focusedChild", "onFocusedChild")
    m.refreshView.observeField("startRefresh", "reloadData")
    configureDesign()
end sub

sub onFocusedChild()
    if m.top.hasFocus()
        m.top.focusKey = m.top.focusKey
    end if
end sub

sub configureDesign()
    m.background.color = "#000000"
    m.titleLabel.color = "#ffffff"

    colorViews = [m.ptsLabel, m.rankLabel, m.separator, m.vertSeparator]

    for each view in colorViews
        view.color = m.global.design.buttonBackgroundColor
    end for

    m.titleLabel.font = getBoldFont(getSize(25))
    m.ptsLabel.font = getBoldFont(getSize(25))
    m.rankLabel.font = getBoldFont(getSize(25))

    m.subTitle.font = getMediumFont(getSize(30))
    m.title.font = getMediumFont(getSize(30))
    m.title.color =  m.global.design.questionTextColor
    m.subTitle.color = m.global.design.buttonBackgroundColor

    m.nameSectionLabel.font = getBoldFont(getSize(20))
    m.rankSectionLabel.font = getBoldFont(getSize(20))
    m.pointSectionLabel.font = getBoldFont(getSize(20))
end sub

sub configureDataSource()
    showLoadingIndicator(true)
    m.networkLayerManager.callFunc("getLeaders", getLeadersUrl(), m.top.accountRoute)
    m.networkLayerManager.observeField("leadersResponce", "onResponceLeaders")
    m.ptsLabel.text = m.global.localization.predictionsNumberPts.Replace("{{ point }}", m.global.userPoints.toStr())
    m.rankLabel.text = m.global.localization.sideMenuRank.Replace("{{ number }}", "-")
    m.titleLabel.text = m.global.userData.name
    m.guestPoster.uri = "pkg:/images/defaultAvatar.png"
    m.subTitle.text = m.global.localization.sideMenuMy
    m.title.text = m.global.localization.sideMenuLeaderboard
    m.rankSectionLabel.text = m.global.localization.sideMenuLabelRank
    m.nameSectionLabel.text = m.global.localization.sideMenuLabelName
    m.pointSectionLabel.text = m.global.localization.sideMenuLabelPoints
    m.top.focusKey = 0
    layoutSubviews()
end sub

sub onResponceLeaders(event)
    data = event.getData()
    count = 0
    contentNode = CreateObject("roSGNode", "ContentNode")
    arrayData = sortArray(data.testings, "amount_of_credits_won", false)

    for each item in arrayData
        count ++
        if item.name = m.global.userData.name then m.rankLabel.text = m.global.localization.sideMenuRank.Replace("{{ number }}", count.toStr())
        rowContent = contentNode.createChild("ContentNode")
        elementContent = rowContent.createChild("ContentNode")
        elementContent.addField("item", "assocarray", false)
        elementContent.addField("rank", "string", false)
        elementContent.rank = count.toStr()
        elementContent.item = item
    end for
    m.leaderList.content = contentNode
    showLoadingIndicator(false)
    m.refreshView.endRefresh = true
end sub

sub reloadData()
    m.leaderList.content = invalid
    m.networkLayerManager.callFunc("getLeaders", getLeadersUrl(), m.top.accountRoute)
end sub

sub layoutSubviews()
    m.background.width = getSize(505)
    m.background.height = getSize(1080)
    m.background.translation = [(getSize(1920) - getSize(500)), 0]

    m.leaderList.itemSize = [getSize(430), getSize(60)]
    m.leaderList.rowItemSize = [getSize(430), getSize(60)]
    m.guestPoster.width = getSize(100)
    m.guestPoster.height = getSize(100)
    m.labelsLayoutGroup.translation = [(getSize(1920) - getSize(500)) + ((getSize(500) - m.labelsLayoutGroup.boundingRect().width) / 2), getSize(30)]
    m.layoutGroup.translation = [(getSize(1920) - getSize(500)) + getSize(20), m.labelsLayoutGroup.translation[1] + m.labelsLayoutGroup.boundingRect().height + getSize(70)]
    m.leaderList.translation = [m.background.translation[0] + ((m.background.width - m.leaderList.itemSize[0]) / 2), m.layoutGroup.boundingRect().height + m.layoutGroup.translation[1] + getSize(110)]
    m.separator.width = getSize(2)
    m.separator.height = m.rankLabel.boundingRect().height
    m.vertSeparator.width = getSize(430)
    m.vertSeparator.height = getSize(2)
    m.vertSeparator.translation = [(getSize(1920) - getSize(500)) + getSize(30), getSize(200)]
    m.sectionGroup.translation = [(getSize(1920) - getSize(500)) + getSize(30), getSize(310)]
    m.refreshView.translation = [m.leaderList.translation[0], m.vertSeparator.translation[1] + m.vertSeparator.height + getSize(20)]
    m.rankSectionLabel.translation = [5, 0]
    m.nameSectionLabel.translation = [getSize(125), 0]
    m.pointSectionLabel.translation = [getSize(430) - m.pointSectionLabel.boundingRect().width - getSize(20), 0]
end sub

function showLoadingIndicator(show)
    m.loadingIndicator.visible = show
    if show
        m.loadingIndicator.setFocus(true)
        m.loadingIndicator.control = "start"
    else
        m.top.focusKey = m.top.focusKey
        m.loadingIndicator.bEatKeyEvents = false
        m.loadingIndicator.control = "stop"
    end if
end function

sub updateFocus()
    if m.top.focusKey = 0
        m.leaderList.setFocus(true)
    else if m.top.focusKey = 1
        m.refreshView.setFocus(true)
    end if
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    result = false

    if not press then return result

    if key = "down"
        if m.top.focusKey = 1
            m.top.focusKey = 0
            result = true
        end if
    else if key = "up" and m.top.focusKey = 0
        m.top.focusKey = 1
        result = true
    end if
    return result
end function