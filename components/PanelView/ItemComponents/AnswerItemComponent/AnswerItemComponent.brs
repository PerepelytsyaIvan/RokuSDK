sub init()
    initView()
end sub

sub initView()
    m.titleLabel = m.top.findNode("titleLabel")
    m.percentLabelLabel = m.top.findNode("percentLabelLabel")
end sub

sub OnItemContentChanged()
    itemContent = m.top.itemContent
    m.titleLabel.font = getBoldFont(25)
    m.percentLabelLabel.font = getBoldFont(25)
    m.percentLabelLabel.text = itemContent.percent
    m.titleLabel.text = itemContent.title

    if itemContent.answerSending 
        m.titleLabel.color = "#01da31"
        m.percentLabelLabel.color = "#01da31"
    else
        m.titleLabel.color = "#cc0000"
        m.percentLabelLabel.color = "#cc0000"
    end if
    layoutSubviews()
end sub

sub layoutSubviews()
    m.titleLabel.width = m.top.width 
    m.percentLabelLabel.width = m.top.width 
end sub