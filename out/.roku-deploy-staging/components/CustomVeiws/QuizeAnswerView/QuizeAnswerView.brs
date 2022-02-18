sub init()
    m.posterFirsAnswer = m.top.findNode("posterFirsAnswer")
    m.labelFirsAnswer = m.top.findNode("labelFirsAnswer")
    m.posterSecondAnswer = m.top.findNode("posterSecondAnswer")
    m.labelSecondAnswer = m.top.findNode("labelSecondAnswer")
end sub

sub configureDataSource()
    dataSource = m.top.dataSource

    posters = [m.posterFirsAnswer, m.posterSecondAnswer]
    labels = [m.labelFirsAnswer, m.labelSecondAnswer]
    count = 0
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
end sub