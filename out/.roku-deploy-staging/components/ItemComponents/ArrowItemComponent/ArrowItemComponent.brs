sub init()
    m.posterCell = m.top.findNode("posterCell")
    m.focusCell = m.top.findNode("focusCell")
end sub

sub configureDataSource()
    m.posterCell.uri = "pkg:/images/" + m.top.dataSource.imageName + ".png"
    m.posterCell.translation = [(getSize(40) - (m.posterCell.translation[0] + m.posterCell.width)) / 2, (getSize(30) - (m.posterCell.translation[1] + m.posterCell.height)) / 2]
    m.posterCell.blendColor = m.global.design.questionTextColor
    m.top.width = getSize(40)
    m.top.height = getSize(30)
end sub

sub onChangePercentFocus(event)
    percent = event.getData()

end sub