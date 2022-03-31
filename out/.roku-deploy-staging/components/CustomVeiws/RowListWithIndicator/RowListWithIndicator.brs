sub init()
    m.timer = configureTimer(0.1, true)
    m.timer.observeField("fire", "onChangeTime")
    m.top.observeField("currFocusRow", "oncurrFocusRow")
    m.count = 0
end sub

sub oncurrFocusRow()
    ? m.top.currFocusRow
end sub

sub onChangeTime()
    m.count += 0.1
    ? m.count
    ? "сг" m.top.currFocusRow
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    ? "RowListWithIndicator ---> onKeyEvent(key: "key", press: "press")"
   
end function