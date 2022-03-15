sub init()
    m.background = m.top.findNode("background")
    m.productGroup = m.top.findNode("productGroup")
    m.subTitle = m.top.findNode("subTitle")
    m.title = m.top.findNode("title")
    m.productList = m.top.findNode("productList")
    m.separator = m.top.findNode("separator")
    configureDesign()
end sub

sub configureDataSource()
    dataSource = m.top.dataSource
    m.subTitle.text = "MY"
    m.title.text = "ACCOUNT"

    contentNode = CreateObject("roSGNode", "ContentNode")
    for each item in dataSource
        rowContent = contentNode.createChild("ContentNode")
        itemContent = rowContent.createChild("ContentNode")
        itemContent.addField("item", "assocarray", false)
        itemContent.item = item
    end for

    m.productList.content = contentNode
    layoutSubviews()
end sub

sub configureDesign()
    m.subTitle.font = getMediumFont(30)
    m.title.font = getMediumFont(30)
    m.title.color = m.global.design.questionTextColor
    m.subTitle.color = m.global.design.buttonBackgroundColor
    m.background.color = "#454545"
end sub

sub layoutSubviews()
    m.background.width = getSize(400)
    m.background.height = getSize(1080)
    m.background.translation = [(getSize(1920) - getSize(400)), 0]
    m.productGroup.translation = [(getSize(1920) - getSize(400)) + (400 / 2), 0]
    m.separator.width = 340
    m.separator.height = 1
end sub