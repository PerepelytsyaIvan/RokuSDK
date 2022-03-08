sub init()
    m.EventModelProperties = {
        idEvent: "id"
        question: ["question", "name"]
        closePostInteraction: "close_post_interaction"
        questionType: ["questionType", "messageType"]
        answers: "answers"
        timeForHiding: "timeToStay"
        type: "type"
        averageRate: "averageRate"
        optionsNumber: "optionsNumber"
        icon: "icon"
        halfIcon: "halfIcon"
        emptyIcon: "emptyIcon"
        buttonText: "actionBtnText"
        categoryId: "categoryId"
        currency: "currency"
        description: "description"
        image: "image"
        name: "name"
        price: "price"
        qrCodeImage: "qrcodeimage"
        userId: "user_id"
    }

    m.eventModelKey = {"injectPoll": "poll", "injectRating": "rating", "prediction": "poll", "injectQuiz": "", "predictionWager": "poll", "injectWiki": "wiki", "injectProduct": "product"}
end sub

function getDesignModel(data) as object
    designModel = {
        "backgrounImage": getImageWithName(data.designs.backgroundImage)
        "logoImage": getImageWithName(data.designs.logoImage),
        "questionTextColor": data.designs.character.textColor,
        "buttonBackgroundColor": data.designs.defaultButton.backgroundColor,
        "wrongAnswerTextColor": data.designs.wrongAnswerTextColor,
        "rightAnswerTextColor": data.designs.rightAnswerTextColor,
        "emptyStarIcon": data.designs.ratingEmptyIcon,
        "fullStarIcon": data.designs.ratingFullIcon,
        "halfStarIcon": data.designs.ratingHalfIcon,
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
        isShowView: false
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
                item.itemComponent = "ActivityButtonWithImage"
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
        isShowView: false
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
            for each item in eventModel.answers
                item.itemComponent = "ActivityButtonWithImage"
            end for
            eventModel.clockData = clockData
            eventModel.timeForHiding = clockData.timeToStay
        end if
    end for

    return eventModel
end sub


sub getEventInfoRatings(data) as object
    clockData = data.clocks[0]

    eventModel = {
        isShowView: false
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
                answers.push({ title: i.toStr(), itemComponent: "RatingItemComponents" })
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
    answers = [{ "answerSending": true, "image": item.correctAnswer.image, "answer": item.correctAnswer.answer }]

    for each incorrectAnswer in item.incorrectAnswers
        answer = { "answerSending": false, "image": incorrectAnswer.image, "answer": incorrectAnswer.answer }
        answers.Push(answer)
    end for

    return answers
end sub

function getEventInfoWithSocket(data, eventType = invalid, timeToStay = 30) as object
    eventModel = {
        isShowView: true
    }

    if isValid(eventType) then messageType = eventType
    if isInvalid(eventType) then messageType = data.messageType

    if messageType = "injectPoll"
        if data.poll.questionType = "prediction"
            data.messageType = "prediction"
            messageType = "prediction"
            if data.poll.is_wager
                data.messageType = "predictionWager"
                messageType = "predictionWager"
            end if
        end if
    end if

    if data.DoesExist(m.eventModelKey[messageType])
        storageModel = getStorageAnswer(data[m.eventModelKey[messageType]].id)
        if isValid(storageModel)
            storageModel.timeForHiding = data.timeToStay
            ' return storageModel
        end if
    end if


    if messageType = "injectPoll"
        eventModel = getDataForModel(data, m.eventModelKey[messageType], false, true)
        eventModel.answers = getItemComponentName(eventModel.answers, "ActivityButtonWithImage")
    else if messageType = "injectRating"
        eventModel = getDataForModel(data, "rating", false, true)
        answers = []
        count = data.rating.optionsnumber.toInt()
        for i = count to 1 step -1
            answers.push({ title: i.toStr(), itemComponent: "RatingItemComponents" })
        end for
        eventModel.answers = answers
    else if messageType = "prediction"
        eventModel = getDataForModel(data, m.eventModelKey[messageType], false, true)
        eventModel.answers = getItemComponentName(eventModel.answers, "PredictionItemComponent")
    else if messageType = "injectQuiz"
        eventModel = getDataForModel(data, m.eventModelKey[messageType], false, true, "injectQuiz")
        eventModel.answers = getItemComponentName(eventModel.answers, "ActivityButtonWithImage")
    else if messageType = "predictionWager"
        eventModel = getDataForModel(data, m.eventModelKey[messageType], false, true, "predictionWager")

        for each answer in eventModel.answers
            answer.points = data.poll.expoints
            answer.itemComponent = "ActivityButtonWithImage"
        end for
    else if messageType = "injectWiki"
        eventModel = getDataForModel(data, m.eventModelKey[messageType], false, true, "injectWiki")
    else if messageType = "injectProduct"
        eventModel = getDataForModel(data, m.eventModelKey[messageType], false, true, "injectProduct")
        eventModel.itemComponent = "ActivityButton"
    end if

    if isInvalid(eventModel.timeForHiding) then eventModel.timeForHiding = timeToStay

    return eventModel
end function

sub getItemComponentName(answers, name) as object
    for each item in answers
        item.itemComponent = name
    end for

    return answers
end sub

sub onLoadStatusLibraryChanged(event)
    state = event.getData()
   
end sub

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
            item.answerSending = responceServer.answer.answer = item.answer
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

    if IsValid(responceServer.answer.userLevel) then eventModel.level = responceServer.answer.userLevel.level
    eventModel.expoints = responceServer.answer.expoints_given
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
    if IsValid(responce)
        if IsValid(responce.answer.userLevel)
            model.level = responce.answer.userLevel.level
            model.expoints = responce.answer.expoints_given
        end if
    end if
    return model
end function

function getAnswerWagerPrediction(model, responce) as object
    for each answer in model.answers
        if answer.answer = responce.answer.answer
            answer.answerSending = true
            answer.text = "Wager summited for " + responce.answer.answer
        end if
    end for

    if IsValid(responce.answer.userLevel)
        model.level = responce.answer.userLevel.level
        model.expoints = responce.answer.expoints_given
    end if
    return model
end function

sub getDataForModel(data, keyEvent, isShowAnswer, isShowView, questionType = invalid) as object
    eventData = {}

    for each item in m.EventModelProperties.Items()
        if Type(item.Value) = "roArray"
            for each value in item.Value
                if data.DoesExist(keyEvent)
                    if data[keyEvent].DoesExist(value) then eventData[item.key] = data[keyEvent][value]
                end if

                if data.DoesExist(value) then eventData[item.key] = data[value]
            end for
        else
            if data.DoesExist(keyEvent) then eventData[item.key] = data[keyEvent][item.Value]
            if data.DoesExist(item.Value) then eventData[item.key] = data[item.Value]
        end if
    end for

    eventData["showAnswerView"] = isShowAnswer
    eventData["isShowView"] = isShowView

    if IsValid(questionType) then eventData.questionType = questionType

    return eventData
end sub