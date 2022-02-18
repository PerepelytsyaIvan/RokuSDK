function getDesignModel(data) as object
    designModel = {
        "backgrounImage" : getImageWithName(data.designs.backgroundImage)
        "logoImage" : getImageWithName(data.designs.logoImage),
        "questionTextColor" : data.designs.character.textColor,
        "buttonBackgroundColor" : data.designs.defaultButton.backgroundColor,
        "wrongAnswerTextColor" : data.designs.wrongAnswerTextColor,
        "rightAnswerTextColor" : data.designs.rightAnswerTextColor,
        "emptyStarIcon" : data.designs.ratingEmptyIcon,
        "fullStarIcon" : data.designs.ratingFullIcon,
        "halfStarIcon" : data.designs.ratingHalfIcon,
    }

    return designModel
end function

function getEventInfo(data) as object
    trivia = getEventInfoTrivias(data)
    poll = configureEventInfoPolls(data)
    rating = getEventInfoRatings(data)
    if IsValid(trivia.question)
        return trivia
    else if IsValid(rating.question)
        return rating
    else if isValid(poll.question)
        return poll
    end if
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
            for each item in eventModel.answers
                item.itemComponent = "PredictionWagerItemComponent"
            end for
            eventModel.clockData = clockData
            eventModel.timeForHiding = clockData.timeToStay
        end if
    end for

    return eventModel
end sub

sub getEventInfoTrivias(data) as object
    clockData = data.clocks[0]

    eventModel = {
        isShowView : false
    }

    for each item in data.trivias
        if item.id = clockData.id
            storageModel = getStorageAnswer(item.id)

            if isValid(storageModel) then return storageModel

            eventModel.showAnswerView = false
            eventModel.isShowView = true
            eventModel.idEvent = item.id
            eventModel.question = item.question
            eventModel.questionType = "injectQuiz"
            eventModel.answers = getAnswerWithTrivias(item)
            eventModel.clockData = clockData
            eventModel.timeForHiding = clockData.timeToStay
        end if
    end for

    return eventModel
end sub


sub getEventInfoRatings(data) as object
    clockData = data.clocks[0]

    eventModel = {
        isShowView : false
    }

    for each item in data.ratings
        if item.id = clockData.id
            storageModel = getStorageAnswer(item.id)
            if isValid(storageModel) then return storageModel
            eventModel.showAnswerView = false
            eventModel.isShowView = true
            eventModel.idEvent = item.id
            eventModel.question = item.name
            eventModel.emptyIcon = ""
            eventModel.halfIcon = ""
            answers = []
            count = data.rating.optionsnumber.toInt()
            for i = count to 1 step -1
                answers.push({title: i.toStr(), itemComponent: "RatingItemComponents"})
            end for
            eventModel.answers = answers
            eventModel.averageRate = item.averageRate
            eventModel.questionType = "injectRating"
            eventModel.clockData = clockData
            eventModel.timeForHiding = clockData.timeToStay
        end if
    end for

    return eventModel
end sub

sub getAnswerWithTrivias(item) as object
    answers = [{"answerSending": true, "image": item.correctAnswer.image, "answer": item.correctAnswer.answer}]

    for each incorrectAnswer in item.incorrectAnswers
        answer = {"answerSending": false, "image": incorrectAnswer.image, "answer": incorrectAnswer.answer}
        answers.Push(answer)
    end for

    return answers
end sub

function getEventInfoWithSocket(data, eventType = invalid, timeToStay = 30) as object
    eventModel = {
        isShowView : true
    }

    if isValid(eventType) then messageType = eventType
    if isInvalid(eventType) then messageType = data.messageType

STOP
    if messageType = "injectPoll"
        if data.poll.questionType = "prediction"
            if data.poll.is_wager
                data.messageType = "predictionWager"
            else
                data.messageType = "prediction"
            end if
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
        for each item in eventModel.answers
            item.itemComponent = "PredictionWagerItemComponent"
        end for
    else if messageType = "injectRating"
        storageModel = getStorageAnswer(data.rating.id)
        if isValid(storageModel) then return storageModel

        eventModel.showAnswerView = false
        eventModel.isShowView = true
        eventModel.idEvent = data.rating.id
        eventModel.question = data.rating.name
        eventModel.questionType = data.messageType
        answers = []
        count = data.rating.optionsnumber.toInt()
        for i = count to 1 step -1
            answers.push({title: i.toStr(), itemComponent: "RatingItemComponents"})
        end for

        eventModel.answers = answers
        eventModel.emptyIcon = data.rating.emptyIcon
        eventModel.halfIcon = data.rating.halfIcon
        eventModel.icon = data.rating.icon
        eventModel.optionsNumber = data.rating.optionsNumber
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
        for each item in eventModel.answers
            item.itemComponent = "PredictionItemComponent"
        end for
    else if messageType = "injectQuiz"
        storageModel = getStorageAnswer(data.id)
        if isValid(storageModel) then return storageModel
        eventModel.showAnswerView = false
        eventModel.isShowView = true
        eventModel.idEvent = data.id
        eventModel.question = data.question
        eventModel.questionType = "injectQuiz"
        eventModel.answers = data.answers
        eventModel.timeForHiding = timeToStay
        for each item in eventModel.answers
            item.itemComponent = "PredictionWagerItemComponent"
        end for
    else if messageType = "predictionWager"
        storageModel = getStorageAnswer(data.poll.id)
        if isValid(storageModel) then return storageModel
        eventModel.showAnswerView = false
        eventModel.isShowView = true
        eventModel.idEvent = data.poll.id
        eventModel.question = data.poll.question
        eventModel.questionType = "predictionWager"
        eventModel.answers = data.poll.answers
        for each answer in eventModel.answers
            answer.points = data.poll.expoints
            answer.itemComponent = "PredictionWagerItemComponent"
        end for
        eventModel.timeForHiding = data.timeToStay
    else if messageType = "injectWiki"
        storageModel = getStorageAnswer(data)
        if isValid(storageModel) then return storageModel
        eventModel.showAnswerView = false
        eventModel.isShowView = true
        eventModel.idEvent = data.wiki.id
        eventModel.question = data.wiki.name
        eventModel.questionType = "injectWiki"
        eventModel.timeForHiding = data.timeToStay
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
            if isInvalid(item.totals) then item.totals = 0
            if item.answer = answer.answer
                item.totals += 1
                item.answerSending = true
            end if
            
            totals += item.totals
        end for
    
        for each answer in eventModel.answers
            if IsValid(answer.totals)
                answer.percent = getPercent((answer.totals / totals) * 100)
            end if
        end for
    end if

    for each item in eventModel.answers
        item.itemComponent = "AnswerItemComponent"
    end for

    return eventModel
end function

function getAnswerModelForRatings(model, responce) as object
    answers = []
    countStars = model.optionsnumber.toInt() - 1
    starsAnswer = model.averagerate
    for i = 0 to countStars
        answer = {}
        answer.title = ""
        answer.itemComponent = "SomeRatingStarItemComponent"
        if i = 0 then answer.title = "AVG"
        if i = countStars then answer.title = model.averagerate.toStr().Mid(0, 4)
        if starsAnswer >= 1
            answer.image = getImageWithName(m.global.design.fullStarIcon)
        else if starsAnswer > 1 and starsAnswer > 0
            answer.image = getImageWithName(m.global.design.halfStarIcon)
        else 
            answer.image = getImageWithName(m.global.design.emptyStarIcon)
        end if
        answers.push(answer)
        starsAnswer -= 1
    end for
    model.answers = answers
    return model
end function

function getAnswerWagerPrediction(model, responce) as object
    for each answer in model.answers
        if answer.answer = responce.answer.answer
            answer.answerSending = true
            answer.text = "Wager summited for " + responce.answer.answer
        end if
    end for

    return model
end function