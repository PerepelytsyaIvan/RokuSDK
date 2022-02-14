function getDesignModel(data) as object
    designModel = {
        "backgrounImage" : getImageWithName(data.designs.backgroundImage)
        "logoImage" : getImageWithName(data.designs.logoImage),
        "questionTextColor" : data.designs.character.textColor,
        "buttonBackgroundColor" : data.designs.defaultButton.backgroundColor
    }

    return designModel
end function

function getEventInfo(data) as object
    return configureEventInfoPolls(data)
end function

sub configureEventInfoPolls(data) as object
    clockData = data.clocks[0]

    eventModel = {
        isShowView : false
    }

    for each item in data.polls
        if item.id = clockData.id
            storageModel = getStorageAnswer(item.id)

            if isValid(storageModel) then return storageModel

            eventModel.showAnswerView = false
            eventModel.isShowView = true
            eventModel.idEvent = item.id
            eventModel.question = item.question
            eventModel.questionType = item.questionType
            eventModel.answers = item.answers
            eventModel.clockData = clockData
            eventModel.timeForHiding = clockData.timeToStay
        end if
    end for

    return eventModel
end sub

function getEventInfoWithSocket(data, eventType = invalid) as object
    eventModel = {
        isShowView : true
    }

    if isValid(eventType) then messageType = eventType
    if isInvalid(eventType) then messageType = data.messageType

    if messageType = "injectPoll"
        if data.poll.questionType = "prediction"
            data.messageType = "prediction"
            return getEventInfoWithSocket(data)
        end if
        storageModel = getStorageAnswer(data.poll.id)
        if isValid(storageModel) then return storageModel

        eventModel.showAnswerView = false
        eventModel.isShowView = true
        eventModel.idEvent = data.poll.id
        eventModel.question = data.poll.question
        eventModel.questionType = data.poll.questionType
        eventModel.answers = data.poll.answers
        eventModel.timeForHiding = data.timeToStay
    else if messageType = "injectRating"
        storageModel = getStorageAnswer(data.rating.id)
        if isValid(storageModel) then return storageModel

        eventModel.showAnswerView = false
        eventModel.isShowView = true
        eventModel.idEvent = data.rating.id
        eventModel.question = data.rating.name
        eventModel.questionType = data.messageType
        eventModel.answers = data.rating.answers
        eventModel.emptyIcon = data.rating.emptyIcon
        eventModel.halfIcon = data.rating.halfIcon
        eventModel.icon = data.rating.icon
        eventModel.averageRate = data.rating.averageRate
        eventModel.timeForHiding = data.timeToStay
    else if messageType = "prediction"
        storageModel = getStorageAnswer(data.poll.id)
        if isValid(storageModel) then return storageModel

        eventModel.showAnswerView = false
        eventModel.isShowView = true
        eventModel.idEvent = data.poll.id
        eventModel.question = data.poll.question
        eventModel.questionType = data.poll.questionType
        eventModel.answers = data.poll.answers
        eventModel.timeForHiding = data.timeToStay
    else if messageType = "injectQuiz"
        storageModel = getStorageAnswer(data.id)
        if isValid(storageModel) then return storageModel

        eventModel.showAnswerView = false
        eventModel.isShowView = true
        eventModel.idEvent = data.id
        eventModel.question = data.question
        eventModel.questionType = "injectQuiz"
        eventModel.answers = data.answers
        eventModel.timeForHiding = 30
    end if

    return eventModel
end function

sub getStorageAnswer(id) as object
    storageModel = RegRead(id)
    if isValid(storageModel)
        storageModel = ParseJson(storageModel)
        storageModel.showAnswerView = true
        return storageModel
    end if
    return invalid
end sub

function getAnswers(answer, eventModel, responceServer)
    if eventModel.questiontype = "injectQuiz"
        eventModel.expointsGiven = responceServer.answer.expoints_given.toStr()
        eventModel.isCorrectAnswer = responceServer.answer.isCorrect
        eventModel.answerSending = true
        for each item in eventModel.answers
            item.isCorrectAnswer = responceServer.answer.correctAnswer.answer = item.answer
        end for
    else
        totals = 0
        for each item in eventModel.answers
            if item.answer = answer.answer
                item.totals += 1
                item.answerSending = true
            end if
            totals += item.totals
        end for
    
        for each answer in eventModel.answers
            if IsValid(answer.totals)
                answer.percent = (answer.totals / totals) * 100
            end if
        end for
    end if

    return eventModel
end function
