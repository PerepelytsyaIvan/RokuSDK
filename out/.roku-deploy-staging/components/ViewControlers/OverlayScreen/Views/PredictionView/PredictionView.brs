sub init()
    m.networkLayerManager = CreateObject("roSGNode", "NetworkLayerManager")
    m.containerView = m.top.findNode("containerView")
    m.layoutView = m.top.findNode("layoutView")
    m.background = m.top.findNode("background")
    m.labelsLayoutGroup = m.top.findNode("labelsLayoutGroup")
    m.subTitle = m.top.findNode("subTitle")
    m.title = m.top.findNode("title")
    m.verticalSeparator = m.top.findNode("verticalSeparator")
    m.ptsLabel = m.top.findNode("ptsLabel")
    m.separator = m.top.findNode("separator")
    m.rankLabel = m.top.findNode("rankLabel")
    m.predictionList = m.top.findNode("predictionList")
    m.top.observeField("focusedChild", "onFocusedChild")
    configureDesign()
end sub

sub configureDesign()
    m.background.color = "#000000"

    colorViews = [m.ptsLabel, m.rankLabel, m.separator, m.verticalSeparator]

    for each view in colorViews
        view.color = m.global.design.buttonBackgroundColor
    end for

    m.ptsLabel.font = getBoldFont(25)
    m.rankLabel.font = getBoldFont(25)

    m.subTitle.font = getMediumFont(30)
    m.title.font = getMediumFont(30)
    m.title.color =  m.global.design.questionTextColor
    m.subTitle.color = m.global.design.buttonBackgroundColor
end sub

sub configureDataSource()
    m.subTitle.text = m.global.localization.sideMenuMy
    m.title.text = m.global.localization.sideMenuPredictions
    m.ptsLabel.text = m.global.userData.amount_of_credits_won.toSTR() + " pts"
    m.rankLabel.text = m.global.localization.sideMenuRank.Replace("{{ number }}", "")

    registrationToken = RegRead("registrationToken")
    if isValid(m.top.accountRoute) 
        m.networkLayerManager.observeField("loginizationResponce", "loginizationUser")
        m.networkLayerManager.callFunc("loginUser", getLoginizationUrl(), m.top.accountRoute, registrationToken)
    end if

    layoutSubviews()
end sub

sub loginizationUser(event)
    loginizationInfo = event.getData()
    RegWrite("loginizationToken", loginizationInfo.token)
    saveInGlobal("userData", loginizationInfo)

    contentNode = CreateObject("roSGNode", "ContentNode")
    for each item in loginizationInfo.predictionsResults.Items()
        ids = item.key.split("_")
        json = RegRead(ids[0])
        answer = ParseJson(json)
        rowNode = contentNode.createChild("ContentNode")
        elementNode = rowNode.createChild("ContentNode")
        elementNode.addField("item", "assocarray", false)
        elementNode.addField("itemResults", "assocarray", false)
        elementNode.itemResults = item.value
        elementNode.item = answer
    end for

    m.predictionList.content = contentNode
    m.predictionList.setFocus(true)
end sub

sub layoutSubviews()
    m.background.width = getSize(380)
    m.background.height = getSize(1080)
    m.background.translation = [(getSize(1920) - getSize(380)), 0]
    m.layoutView.translation = [(1920 - 360) + (m.layoutView.boundingRect().width / 2), 20]
    m.separator.width = 2
    m.separator.height = m.ptsLabel.boundingRect().height
    m.verticalSeparator.height = 2
    m.verticalSeparator.width = 340
    m.predictionList.translation = [(getSize(1920) - getSize(380)) + 20, m.layoutView.boundingRect().height + m.layoutView.translation[1] + 20]
end sub

sub onFocusedChild()
    if m.top.hasFocus()
        m.predictionList.setFocus(true)
    end if
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    result = false

    if not press then return result

    return result
end function