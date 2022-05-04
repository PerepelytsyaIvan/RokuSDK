sub init()
    m.sendSmileMask = m.top.findNode("sendSmileMask")
    m.sendSmilePoster = m.top.findNode("sendSmilePoster")
    layoutSubview()
end sub

sub layoutSubview()
    m.sendSmileMask.width = getSize(70)
    m.sendSmileMask.height = getSize(65)

    m.sendSmilePoster.width = getSize(60)
    m.sendSmilePoster.height = getSize(55)
end sub
