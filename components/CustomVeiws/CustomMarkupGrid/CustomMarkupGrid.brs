sub init()
    m.baseGroup = m.top.findNode("baseGroup")
    m.focus = m.top.findNode("focus")

    m.translationAnimation = m.top.findNode("translationAnimation")
    m.translationInterpolator = m.top.findNode("translationInterpolator")
    m.widthInterpolator = m.top.findNode("widthInterpolator")
    m.heightInterpolator = m.top.findNode("heightInterpolator")

    m.moveRowAnimation = m.top.findNode("moveRowAnimation")
    m.moveRowInterpolator = m.top.findNode("moveRowInterpolator")

    m.opacityFocus = m.top.findNode("opacityFocus")
    m.opacityFocusInterpolator = m.top.findNode("opacityFocusInterpolator")

    m.widthInterpolatorFocus = m.top.findNode("widthInterpolatorFocus")
    m.heightInterpolatorFocus = m.top.findNode("heightInterpolatorFocus")

    m.indexPath = [0, 0]
    m.translationInterpolator.observeField("fraction", "changeFractionFocus")
    m.opacityFocusInterpolator.observeField("fraction", "changeFractionFocusOpacity")
    m.top.observeField("focusedChild", "onFocusedChild")
end sub

sub onFocusedChild()
    if m.top.hasFocus() and m.opacityFocusInterpolator.keyValue[0] <> 0.0
        m.opacityFocusInterpolator.keyValue = [0.0, 1.0]
        m.opacityFocus.control = "start"
    else if not m.top.hasFocus() and m.opacityFocusInterpolator.keyValue[0] = 0.0
        m.opacityFocusInterpolator.keyValue = [1.0, 0.0]
        m.opacityFocus.control = "start"
    end if
end sub

sub changeFractionFocusOpacity(event)
    fraction = event.getData()
    if m.top.hasFocus()
        m.currentElement.percentFocus = fraction
    else
        m.currentElement.percentFocus = 1 - fraction
    end if
end sub


sub changeFractionFocus(event)
    fraction = event.getData()

    if not m.top.hasFocus() then return
    m.currentElement.percentFocus = fraction

    if isValid(m.previusFocusedElement)
        m.previusFocusedElement.percentFocus = 1 - fraction
    end if
end sub

sub reloadCollection()
    m.moveRowInterpolator.keyValue = []
    m.moveRowInterpolator.fieldToInterp = ""
    m.widthInterpolator.keyValue = []
    m.heightInterpolator.keyValue = []
    m.opacityFocusInterpolator.keyValue = []
    m.translationInterpolator.keyValue = []
    m.indexPath = [0, 0]
end sub

sub configureDataSource()
    m.baseGroup.removeChildrenIndex(100, 0)
    reloadCollection()

    if m.top.dataSource = invalid then return
    dataSource = m.top.dataSource
    elements = []
    collectionElements = []
    count = 0
    countRow = 0
    for each item in dataSource
        count++
        if calculateWidthRow(elements, getNextWidthItem(item))
            countRow++
            layoutGroupRow = m.baseGroup.CreateChild("Group")
            layoutGroupRow.id = countRow.toStr()
            layoutGroupRow.translation = getTranslation()
            elements = []
            if elements.count() > 0
                collectionElements.append(elements)
            end if
        end if

        element = layoutGroupRow.CreateChild(item.itemComponent)
        element.dataSource = item
        element.addField("focusTranslation", "array", false)
        element.id = count.toStr()
        element.focusTranslation = getTranslation()
        element.translation = [element.focusTranslation[0], 0]
        elements.Push(element)
    end for
    if elements.count() > 0
        collectionElements.append(elements)
    end if
    m.top.elements = collectionElements

    setFocusElement()
end sub

sub getNextWidthItem(item) as object
    element = CreateObject("roSGNode", item.itemComponent)
    element.dataSource = item
    return element.width
end sub

sub setFocusElement()
    element = m.baseGroup.getChild(m.indexPath[0]).getChild(m.indexPath[1])
    m.currentElement = element
    m.translationInterpolator.keyValue = [[0, 0], element.focusTranslation]
    m.widthInterpolator.keyValue = [0, element.width]
    m.heightInterpolator.keyValue = [0, element.height]
    m.translationAnimation.control = "start"
end sub

sub getTranslation() as object
    endRow = m.baseGroup.getChild(m.baseGroup.getChildCount() - 1)
    previusRow = m.baseGroup.getChild(m.baseGroup.getChildCount() - 2)
    previusElement = endRow.getChild(endRow.getChildCount() - 2)

    if isValid(previusRow)
        translationY = previusRow.translation[1] + m.top.itemSpacing + previusRow.getChild(0).height
    else
        translationY = 0
    end if

    if isValid(previusElement)
        translationX = previusElement.translation[0] + previusElement.width + m.top.itemSpacing
    else
        translationX = 0
    end if
    return [translationX, translationY]
end sub

sub calculateWidthRow(elements, nextWidth) as boolean
    totalWidth = 0
    for each element in elements
        totalWidth += element.width
    end for

    if (totalWidth + nextWidth) > m.top.widthLayoutView
        return true
    else if totalWidth = 0
        return true
    else
        return false
    end if
end sub

sub moveFocus(key) as object
    result = true
    if key = "right"
        m.indexPath[1] += 1
    else if key = "left"
        m.indexPath[1] -= 1
    else if key = "down"
        m.indexPath[0] += 1
    else if key = "up"
        m.indexPath[0] -= 1
    else
        result = false
    end if

    validateIndexPath()

    if not result then return result
    m.previusFocusedElement = m.currentElement

    element = m.baseGroup.getChild(m.indexPath[0]).getChild(m.indexPath[1])

    if isInvalid(element) then return false

    if isValid(m.previusFocusedElement)
        if m.previusFocusedElement.id = element.id
            return false
        end if
    end if

    if key = "right"
        configureAnimationRow()
    else if key = "left"
        configureAnimationLeft()
    else if key = "down"
        configureAnimationDown()
    else if key = "up"
        configureAnimationUp()
    end if
    return result
end sub

sub configureFocusElement(newTrRow, element, key)
    if key = "right"
        translationX = m.currentElement.translation[0] + (m.currentElement.width + m.top.itemSpacing)
        if IsValid(newTrRow)
            translationX = m.currentElement.translation[0] + (m.currentElement.width + m.top.itemSpacing)
            m.translationInterpolator.keyValue = [m.translationInterpolator.keyValue[1], [newTrRow + translationX, m.translationInterpolator.keyValue[1][1]]]
        else
            m.translationInterpolator.keyValue = [m.translationInterpolator.keyValue[1], [translationX, m.translationInterpolator.keyValue[1][1]]]
        end if
    else if key = "left"
        translationX = newTrRow.translation[0] + (m.currentElement.translation[0] - (element.width + m.top.itemSpacing))
        m.translationInterpolator.keyValue = [m.translationInterpolator.keyValue[1], [translationX, m.translationInterpolator.keyValue[1][1]]]
    else if key = "down"
        m.translationInterpolator.keyValue = [m.translationInterpolator.keyValue[1], [element.focusTranslation[0], element.focusTranslation[1] + newTrRow[1]]]
    else if key = "up"
        if IsInvalid(newTrRow)
            m.translationInterpolator.keyValue = [m.translationInterpolator.keyValue[1], [element.focusTranslation[0], m.translationInterpolator.keyValue[1][1] - element.height - m.top.itemSpacing]]  
        else
            m.translationInterpolator.keyValue = [m.translationInterpolator.keyValue[1], m.translationInterpolator.keyValue[1]]
        end if
    end if

    m.widthInterpolator.keyValue = [m.widthInterpolator.keyValue[1], element.width]
    m.heightInterpolator.keyValue = [m.heightInterpolator.keyValue[1], element.height]
    m.translationAnimation.control = "start"
    m.currentElement = element
end sub

sub configureAnimationLeft()
    row = m.baseGroup.getChild(m.indexPath[0])
    element = row.getChild(m.indexPath[1])
    boundingRectRow = row.boundingRect()

    translationX = element.translation[0] - row.translation[0].toStr().Replace("-", "").toInt()

    if translationX < 0
        m.moveRowInterpolator.fieldToInterp = row.id + ".translation"
        differenceTranslation = ((element.focusTranslation[0] - m.top.sizeMask[0]) + element.width) + row.translation[0]
        newTranslation = [row.translation[0] - differenceTranslation, row.translation[1]]
        m.moveRowInterpolator.keyValue = [m.moveRowInterpolator.keyValue[1], [(row.translation[0] - translationX), row.translation[1]]]
        configureFocusElement({ translation: m.moveRowInterpolator.keyValue[1] }, element, "left")
        m.moveRowAnimation.control = "start"
    else
        configureFocusElement(row, element, "left")
    end if
end sub

sub configureAnimationDown()
    row = m.baseGroup.getChild(m.indexPath[0])
    element = row.getChild(m.indexPath[1])
    boundingRectRow = row.boundingRect()

    if row.translation[1] > m.top.sizeMask[1]
        m.moveRowInterpolator.fieldToInterp = "baseGroup.translation"
        m.moveRowInterpolator.keyValue = [m.baseGroup.translation, [m.baseGroup.translation[0], m.top.sizeMask[1] - (row.translation[1] + element.height)]]
        configureFocusElement(m.moveRowInterpolator.keyValue[1], element, "down")
        m.moveRowAnimation.control = "start"
    else
        configureFocusElement(m.baseGroup.translation, element, "down")
    end if
end sub

sub configureAnimationUp()
    row = m.baseGroup.getChild(m.indexPath[0])
    element = row.getChild(m.indexPath[1])
    boundingRectRow = row.boundingRect()

    if m.baseGroup.translation[1] < 0 and m.translationInterpolator.keyValue[1][1] < element.height
        m.moveRowInterpolator.fieldToInterp = "baseGroup.translation"
        m.moveRowInterpolator.keyValue = [m.moveRowInterpolator.keyValue[1], [m.baseGroup.translation[0], m.baseGroup.translation[1] + element.height + m.top.itemSpacing]]
        configureFocusElement(m.moveRowInterpolator.keyValue[1], element, "up")
        m.moveRowAnimation.control = "start"
    else
        configureFocusElement(invalid, element, "up")
    end if
end sub

sub configureAnimationRow() as boolean
    row = m.baseGroup.getChild(m.indexPath[0])
    element = row.getChild(m.indexPath[1])
    boundingRectRow = row.boundingRect()

    if (element.translation[0] + element.width) > m.top.sizeMask[0]
        m.moveRowInterpolator.fieldToInterp = row.id + ".translation"
        differenceTranslation = ((element.focusTranslation[0] - m.top.sizeMask[0]) + element.width) + row.translation[0]
        newTranslation = [row.translation[0] - differenceTranslation, row.translation[1]]
        m.moveRowInterpolator.keyValue = [row.translation, newTranslation]
        configureFocusElement(newTranslation[0], element, "right")
        m.moveRowAnimation.control = "start"
    else
        configureFocusElement(invalid, element, "right")
    end if
end sub

sub validateIndexPath()
    if m.indexPath[0] >= m.baseGroup.getChildCount()
        m.indexPath[0] = m.baseGroup.getChildCount() - 1
    else if m.indexPath[0] < 0
        m.indexPath[0] = 0
    end if

    elementsCount = m.baseGroup.getChild(m.indexPath[0]).getChildCount()
    if m.indexPath[1] >= elementsCount
        m.indexPath[1] = elementsCount - 1
    else if m.indexPath[1] < 0
        m.indexPath[1] = 0
    end if
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    result = false
    if press
        m.translationAnimation.control = "finish"
        result = moveFocus(key)

        if key = "OK"
            m.top.item = m.baseGroup.getChild(m.indexPath[0]).getChild(m.indexPath[1]).dataSource
            result = true
        end if
    end if
    return result
end function