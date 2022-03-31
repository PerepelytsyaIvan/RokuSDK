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
    m.top.observeField("focusedChild", "onFocusedChild")
    configureDesign()
end sub

sub onFocusedChild()
    if m.top.hasFocus()
        m.leaderList.setFocus(true)
    end if
end sub

sub configureDesign()
    m.background.color = "#000000"
    m.titleLabel.color = "#ffffff"

    colorViews = [m.ptsLabel, m.rankLabel, m.separator, m.vertSeparator]

    for each view in colorViews
        view.color = m.global.design.buttonBackgroundColor
    end for

    m.titleLabel.font = getBoldFont(25)
    m.ptsLabel.font = getBoldFont(25)
    m.rankLabel.font = getBoldFont(25)

    m.subTitle.font = getMediumFont(30)
    m.title.font = getMediumFont(30)
    m.title.color =  m.global.design.questionTextColor
    m.subTitle.color = m.global.design.buttonBackgroundColor

    m.nameSectionLabel.font = getBoldFont(20)
    m.rankSectionLabel.font = getBoldFont(20)
    m.pointSectionLabel.font = getBoldFont(20)
end sub

sub configureDataSource()
    m.networkLayerManager.callFunc("getLeaders", getLeadersUrl(), m.top.accountRoute)
    m.networkLayerManager.observeField("leadersResponce", "onResponceLeaders")
    m.ptsLabel.text = m.global.localization.predictionsNumberPts.Replace("{{ point }}", "130")
    m.rankLabel.text = m.global.localization.sideMenuRank.Replace("{{ number }}", "100")
    m.titleLabel.text = m.global.userData.name
    m.guestPoster.uri = "pkg:/images/defaultAvatar.png"
    m.subTitle.text = m.global.localization.sideMenuMy
    m.title.text = m.global.localization.sideMenuLeaderboard
    m.rankSectionLabel.text = m.global.localization.sideMenuLabelRank
    m.nameSectionLabel.text = m.global.localization.sideMenuLabelName
    m.pointSectionLabel.text = m.global.localization.sideMenuLabelPoints
    showLoadingIndicator(true)
    layoutSubviews()
end sub

sub onResponceLeaders(event)
    data = event.getData()
    count = 0
    contentNode = CreateObject("roSGNode", "ContentNode")
    for each item in data.testings
        count ++
        rowContent = contentNode.createChild("ContentNode")
        elementContent = rowContent.createChild("ContentNode")
        elementContent.addField("item", "assocarray", false)
        elementContent.addField("rank", "string", false)
        elementContent.rank = count.toStr()
        elementContent.item = item
    end for
    m.leaderList.content = contentNode
    m.leaderList.setFocus(true)
    layoutSubviews()
    showLoadingIndicator(false)
end sub

sub layoutSubviews()
    m.background.width = getSize(500)
    m.background.height = getSize(1080)
    m.background.translation = [(getSize(1920) - getSize(500)), 0]
    m.guestPoster.width = 100
    m.guestPoster.height = 100
    m.labelsLayoutGroup.translation = [(getSize(1920) - getSize(500)) + ((500 - m.labelsLayoutGroup.boundingRect().width) / 2), getSize(30)]
    m.layoutGroup.translation = [(getSize(1920) - getSize(500)) + 20, m.labelsLayoutGroup.translation[1] + m.labelsLayoutGroup.boundingRect().height + 70]
    m.leaderList.translation = [m.background.translation[0] + ((m.background.width - m.leaderList.boundingRect().width) / 2), m.layoutGroup.boundingRect().height + m.layoutGroup.translation[1] + 30]
    m.separator.width = 2
    m.separator.height = m.rankLabel.boundingRect().height
    m.vertSeparator.width = 430
    m.vertSeparator.height = 2
    m.vertSeparator.translation = [(getSize(1920) - getSize(500)) + 30, 200]
    m.sectionGroup.translation = [(getSize(1920) - getSize(500)) + 30, 220]
    m.rankSectionLabel.translation = [5, 0]
    m.nameSectionLabel.translation = [125, 0]
    m.loadingIndicator.translation = [700, 0]   
    m.loadingIndicator.imageWidth = getSize(50)
    m.pointSectionLabel.translation = [430 - m.pointSectionLabel.boundingRect().width - 20, 0]
end sub

function showLoadingIndicator(show)
    m.loadingIndicator.visible = show
    if show
        m.loadingIndicator.control = "start"
    else
        m.loadingIndicator.bEatKeyEvents = false
        m.loadingIndicator.control = "stop"
    end if
end function

function onKeyEvent(key as string, press as boolean) as boolean
    result = false

    if not press then return result

    if key = "down"
        result = true
    end if
    return result
end function