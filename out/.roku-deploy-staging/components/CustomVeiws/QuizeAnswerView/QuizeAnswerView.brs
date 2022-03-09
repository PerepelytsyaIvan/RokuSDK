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
    for each item in dataSource
            if item.answersending and item.isCorrectAnswer
                m.layoutGroupAnswer.removeChild(m.layoutGroupWrongAnswer)
                m.rightAnswerLabel.text = item.answer
                m.imageCellRightAnswer.uri = "pkg:/images/rightAnwer.png"
                m.infoLabel.text = "AWESOME! \n+250 pts for the correct answer".Replace("\n", chr(10))
            else if item.answersending and not item.isCorrectAnswer
                m.layoutGroupAnswer.insertChild(m.layoutGroupWrongAnswer, 0)
                m.wrongAnswerLabel.text = item.answer
                m.imageCellWrongAnswer.uri = "pkg:/images/wrongAnswer.png"
                m.infoLabel.text = "Wrong answer \nBetter luck next time".Replace("\n", chr(10))
                for each answer in dataSource
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