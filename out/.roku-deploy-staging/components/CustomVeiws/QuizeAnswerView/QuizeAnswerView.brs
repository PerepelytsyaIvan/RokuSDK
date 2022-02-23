sub init()
    m.posterFirsAnswer = m.top.findNode("posterFirsAnswer")
    m.labelFirsAnswer = m.top.findNode("labelFirsAnswer")
    m.posterSecondAnswer = m.top.findNode("posterSecondAnswer")
    m.labelSecondAnswer = m.top.findNode("labelSecondAnswer")
    m.layoutGroup = m.top.findNode("layoutGroup")
end sub

sub configureDataSource()
    dataSource = m.top.dataSource

    posters = [m.posterFirsAnswer, m.posterSecondAnswer]
    labels = [m.labelFirsAnswer, m.labelSecondAnswer]
    count = 0

    if dataSource.count() <= 1
        for each answer in dataSource
            posters[count].uri = answer.image
            labels[count].text = answer.answer
            labels[count].font = getRegularFont(23)
            if answer.iscorrectanswer
                labels[count].color = "#4EDA2B"
            else
                labels[count].color = "#FF0000"
            end if
            count ++
        end for
    else
        for each answer in dataSource
            if answer.answersending 
                m.posterSecondAnswer.uri = answer.image
                m.labelSecondAnswer.text = answer.answer
                if answer.iscorrectanswer
                    m.labelSecondAnswer.color = "#4EDA2B"
                else
                    m.labelSecondAnswer.color = "#FF0000"
                end if
            end if
        end for

        boundingRect = m.layoutGroup.boundingRect()
        m.layoutGroup.itemSpacings = [100,0,0]
        ? ""
    end if
end sub