sub init()
    initView()
end sub

sub initView()
    m.titleLabel = m.top.findNode("titleLabel")
    m.percentLabelLabel = m.top.findNode("percentLabelLabel")
    m.layoutGroup = m.top.findNode("layoutGroup")
    m.imageCell = m.top.findNode("imageCell")
end sub

sub configureDataSource()
    m.titleLabel.font = getBoldFont(getSize(25))
    m.percentLabelLabel.font = getBoldFont(getSize(25))
    m.percentLabelLabel.text = m.top.dataSource.percent
    m.titleLabel.text =  m.top.dataSource.answer
    m.imageCell.uri = getImageWithName(m.top.dataSource.image)
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
    m.titleLabel.width = m.titleLabel.boundingRect().width
    m.percentLabelLabel.width = m.percentLabelLabel.boundingRect().width
    m.layoutGroup.itemSpacings = [getSize(2)]

    if m.imageCell.uri <> getImageWithName("")
        m.imageCell.width = getSize(40)
        m.imageCell.height = getSize(40)
        m.imageCell.translation = [getSize(10), (m.top.localBoundingRect().height - m.imageCell.height) / 2]
        m.layoutGroup.translation = [getSize(65), 0]
    end if

    m.top.width = m.top.localBoundingRect().width + getSize(20)
    m.top.height = m.top.localBoundingRect().height
end sub