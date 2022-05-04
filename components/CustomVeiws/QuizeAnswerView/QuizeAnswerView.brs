sub init()
    m.layoutGroup = m.top.findNode("layoutGroup")
    m.layoutGroupWrongAnswer = m.top.findNode("layoutGroupWrongAnswer")
    m.layoutGroupAnswer = m.top.findNode("layoutGroupAnswer")
    m.imageCellWrongAnswer = m.top.findNode("imageCellWrongAnswer")  
    m.wrongAnswerLabel = m.top.findNode("wrongAnswerLabel")
    m.imageCellRightAnswer = m.top.findNode("imageCellRightAnswer")
    m.rightAnswerLabel = m.top.findNode("rightAnswerLabel")
    m.infoLabel = m.top.findNode("infoLabel")
    configureDesign()
end sub

sub configureDesign()
    font = getMediumFont(getSize(35))
    m.wrongAnswerLabel.font = font
    m.wrongAnswerLabel.color = m.global.design.wrongAnswerTextColor

    m.infoLabel.drawingStyles = {
        "DunamicColor": {
            "fontSize": font.size
            "fontUri": font.uri
            "color": m.global.design.buttonBackgroundColor
        }

        "default": {
            "fontSize": font.size
            "fontUri": font.uri
            "color": "#ffffff"
        }
    }
end sub

sub configureDataSource()
    dataSource = m.top.dataSource
    for each item in dataSource.answers
            if isValid(item.answersending) and isValid(item.isCorrectAnswer) and item.answersending and item.isCorrectAnswer
                m.layoutGroupAnswer.removeChild(m.layoutGroupWrongAnswer)
                m.rightAnswerLabel.text = item.answer
                m.imageCellRightAnswer.uri = getImageWithName(m.global.design.rightAnswerLogo)
                text = (m.global.localization.triviaRightAnswerNoteOne + "\n" + "<DunamicColor>+" + m.top.dataSource.expointsgiven + " pts" + "</DunamicColor> " + m.global.localization.triviaRightAnswerNote3).Replace("\n", chr(10))
                m.infoLabel.text = text
            else if isValid(item.answersending) and isValid(item.isCorrectAnswer) and item.answersending and not item.isCorrectAnswer
                m.layoutGroupAnswer.insertChild(m.layoutGroupWrongAnswer, 0)
                m.wrongAnswerLabel.text = item.answer
                m.imageCellWrongAnswer.uri =  getImageWithName(m.global.design.wrongAnswerLogo)
                m.infoLabel.text = (m.global.localization.triviaWrongAnswerNoteOne + "\n" + m.global.localization.triviaWrongAnswerNoteTwo).Replace("\n", chr(10))
                for each answer in dataSource.answers
                    if answer.isCorrectAnswer
                        m.rightAnswerLabel.text = answer.answer
                        m.imageCellRightAnswer.uri = getImageWithName(m.global.design.rightAnswerLogo)
                    end if
                end for
            end if
    end for
    layoutView()
end sub

sub layoutView()
    m.layoutGroup.itemSpacings = [getSize(200)]
    m.layoutGroup.translation = getSizeMaskGroupWith([0, 30])

    images = [m.imageCellRightAnswer, m.imageCellWrongAnswer]

    for each image in images
        image.width = getSize(35)
        image.height = getSize(35)
    end for

    labels = [m.rightAnswerLabel, m.wrongAnswerLabel]

    for each label in labels
        label.height = getSize(40)
        label.font = getBoldFont(getSize(35))
    end for

    m.infoLabel.height = getSize(100)
end sub