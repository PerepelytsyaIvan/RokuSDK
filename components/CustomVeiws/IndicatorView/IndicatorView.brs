sub init()
    m.animation = m.top.findNode("animation")
    m.indicatorBackground = m.top.findNode("indicatorBackground")
    m.indicator = m.top.findNode("indicator")
    m.interpolatorTranslation = m.top.findNode("interpolatorTranslation")
end sub

sub changePercentScroll()
    m.interpolatorTranslation.fraction = m.top.percent
end sub

sub layoutSubview()
    m.interpolatorTranslation.keyValue = [[0,0], [0, m.top.height - m.top.heightIndicator]]
end sub