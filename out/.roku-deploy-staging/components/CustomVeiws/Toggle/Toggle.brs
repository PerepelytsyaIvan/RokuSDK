sub init()
    initSubviews()
end sub

sub initSubviews()
    m.thumb = m.top.findNode("thumb")
    m.background = m.top.findNode("back")
    m.toggleAnimation = m.top.findNode("toggleAnimation")
    m.thumbColorIntrp = m.top.findNode("thumbColorIntrp")
    m.thumbTranslationIntrp = m.top.findNode("thumbTranslationIntrp")    
end sub

    

sub valueChanged(event)    
    value = event.getData()
    m.toggleAnimation.control = "finish"

    if value
        m.thumbColorIntrp.keyValue = ["0xCED2D5FF", "#BE2270ff"]
        m.thumbTranslationIntrp.keyValue = [[0,3], [30, 3]]
    else
        m.thumbColorIntrp.keyValue = ["#BE2270ff", "0xCED2D5FF"]
        m.thumbTranslationIntrp.keyValue = [[30,3], [0, 3]]
    end if
    m.toggleAnimation.control = "start"
end sub
