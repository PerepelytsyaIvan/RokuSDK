sub init()
    m.container = m.top.findNode("container")
end sub

sub itemFocusChanged()
    if isValid(m.child)  
        m.child.focusPercent = m.top.focusPercent
    end if
end sub

sub OnItemContentChanged(event)
    itemContent = event.getData()

    if isValid(itemContent)
        itemComponentName = itemContent.itemComponentName
        
        if isValid(m.child)
            m.container.removeChild(m.child)
            m.child = invalid
        end if

        if isValid(itemComponentName) and m.child = invalid
            m.child = m.container.createChild(itemComponentName)                      
            m.child.width = m.top.width
            m.child.height = m.top.height
        end if  

        if IsValid(m.child)
            m.child.itemContent = itemContent  
            layoutSubviews() 
        end if          
    end if
end sub

sub layoutSubviews()
    if isValid(m.child)
        m.child.width = m.top.width
        m.child.height = m.top.height                
    end if
end sub