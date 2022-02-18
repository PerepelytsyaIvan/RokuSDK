sub init()
    initView()
end sub

sub initView()
    m.titleLabel = m.top.findNode("titleLabel")
    m.percentLabelLabel = m.top.findNode("percentLabelLabel")
    m.layoutGroup = m.top.findNode("layoutGroup")
end sub

sub configureDataSource()
    m.titleLabel.font = getBoldFont(25)
    m.percentLabelLabel.font = getBoldFont(25)
    m.percentLabelLabel.text = m.top.dataSource.percent
    m.titleLabel.text =  m.top.dataSource.answer

    if  m.top.dataSource.answerSending 
        m.titleLabel.color = m.global.design.wrongAnswerTextColor
        m.percentLabelLabel.color = m.global.design.wrongAnswerTextColor
    else
        m.titleLabel.color = m.global.design.rightAnswerTextColor
        m.percentLabelLabel.color = m.global.design.rightAnswerTextColor
    end if
    layoutSubviews()
end sub

sub layoutSubviews()
    ' m.titleLabel.width = m.top.width 
    ' m.percentLabelLabel.width = m.top.width 
    m.titleLabel.width = m.titleLabel.boundingRect().width
    m.percentLabelLabel.width = m.percentLabelLabel.boundingRect().width
    m.top.width = m.layoutGroup.localBoundingRect().width
    m.top.height = m.layoutGroup.localBoundingRect().height
end sub