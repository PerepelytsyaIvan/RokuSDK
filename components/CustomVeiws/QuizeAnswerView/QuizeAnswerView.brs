sub init()
    m.layoutGroup = m.top.findNode("layoutGroup")
    m.layoutGroupWrongAnswer = m.top.findNode("layoutGroupWrongAnswer")
    m.layoutGroupAnswer = m.top.findNode("layoutGroupAnswer")
    m.imageCellWrongAnswer = m.top.findNode("imageCellWrongAnswer")  
    m.wrongAnswerLabel = m.top.findNode("wrongAnswerLabel")
    m.imageCellRightAnswer = m.top.findNode("imageCellRightAnswer")
    m.rightAnswerLabel = m.top.findNode("rightAnswerLabel")

    m.infoLabel = m.top.findNode("infoLabel")
end sub

sub configureDataSource()
    dataSource = m.top.dataSource
    for each item in dataSource.answers
            if isValid(item.answersending) and isValid(item.isCorrectAnswer) and item.answersending and item.isCorrectAnswer
                m.layoutGroupAnswer.removeChild(m.layoutGroupWrongAnswer)
                m.rightAnswerLabel.text = item.answer
                m.imageCellRightAnswer.uri = "pkg:/images/rightAnwer.png"
                m.infoLabel.text = m.global.localization.triviaRightAnswerNote.Replace("{{ point }}", "\n+"+ m.top.dataSource.expointsgiven).Replace("\n", chr(10))
            else if isValid(item.answersending) and isValid(item.isCorrectAnswer) and item.answersending and not item.isCorrectAnswer
                m.layoutGroupAnswer.insertChild(m.layoutGroupWrongAnswer, 0)
                m.wrongAnswerLabel.text = item.answer
                m.imageCellWrongAnswer.uri = "pkg:/images/wrongAnswer.png"
                m.infoLabel.text = (m.global.localization.triviaWrongAnswerNoteOne + "\n" + m.global.localization.triviaWrongAnswerNoteTwo).Replace("\n", chr(10))
                for each answer in dataSource.answers
                    if answer.isCorrectAnswer
                        m.rightAnswerLabel.text = answer.answer
                        m.imageCellRightAnswer.uri = "pkg:/images/rightAnwer.png"
                    end if
                end for
            end if
    end for
    layoutView()
end sub

sub layoutView()
    m.wrongAnswerLabel.color = m.global.design.wrongAnswerTextColor
    m.rightAnswerLabel.color = m.global.design.rightAnswerTextColor

    m.layoutGroup.itemSpacings = [getSize(200)]
    m.layoutGroup.translation = getSizeMaskGroupWith([0, 30])

    images = [m.imageCellRightAnswer, m.imageCellWrongAnswer]

    for each image in images
        image.width = getSize(35)
        image.height = getSize(35)
    end for

    labels = [m.rightAnswerLabel, m.wrongAnswerLabel]
    m.infoLabel.font = getMediumFont(getSize(35))

    for each label in labels
        label.height = getSize(40)
        label.font = getBoldFont(getSize(35))
    end for

    m.infoLabel.height = getSize(100)
end sub