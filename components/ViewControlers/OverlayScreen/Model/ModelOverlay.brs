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
        "rightAnswerLogo": data.designs.rightAnswerLogo,
        "wrongAnswerLogo": data.designs.wrongAnswerLogo
    }
    return designModel
end function



function getLocaliztion(data) as object
    jsonLocalization = ParseJson(data.languages)
    ? jsonLocalization
    localization = {}
    for each item in LocalizationEnum().Items()
        localization[item.key] = jsonLocalization[item.value]
    end for
    return localization
end function

function getEventInfo(data) as object
    activities = []
    for each clock in data.clocks
        trivia = getEventInfoTrivias(data, clock)
        poll = configureEventInfoPolls(data, clock)
        rating = getEventInfoRatings(data, clock)
        wiki = configureEventInfoWiki(data, clock)
        prediction = configureEventInfoPrediction(data, clock)
        products = configureEventInfoProducts(data, clock)
        predictionWager = configureEventInfoPredictionWager(data, clock)

        if IsValid(trivia.question)
            trivia.isShowing = invalid
            activities.push(trivia)
        else if IsValid(rating.question)
            rating.isShowing = invalid
            activities.push(rating)
        else if isValid(poll.question)
            poll.isShowing = invalid
            activities.push(poll)
        else if IsValid(wiki.content)
            wiki.isShowing = invalid
            activities.push(wiki)
        else if isValid(prediction.question)
            prediction.isShowing = invalid
            activities.push(prediction)
        else if isValid(products.question)
            products.isShowing = invalid
            activities.push(products)
        else if isValid(predictionWager.question)
            predictionWager.isShowing = invalid
            activities.push(predictionWager)
        end if
    end for

    return activities
end function

sub configureEventInfoWiki(data, clockData) as object
    eventModel = {
        isShowView: false
    }

    for each item in data.wikis
        id = convertIntToStr(clockData.id)
        if item.id = id
            storageModel = getStorageAnswer(item.id)

            if isValid(storageModel)
                storageModel.clockData = clockData
                return storageModel
            end if
            eventModel = getDataForModel(item, "injectWiki", false, true, "injectWiki")
            eventModel.clockData = clockData
            eventModel.timeForHiding = clockData.timeToStay
            if isValid(clockData.feedbackTime)
                eventModel.feedbackTime = convertStrToInt(clockData.feedbackTime) 
            end if

            if isValid(clockData.close_post_interaction)
                eventModel.closepostinteraction = clockData.close_post_interaction
            end if
        end if
    end for

    return eventModel
end sub

sub configureEventInfoPredictionWager(data, clockData) as object
    eventModel = {
        isShowView: false
    }

    for each item in data.products
        id = convertIntToStr(clockData.id)
        if item.id = id
            storageModel = getStorageAnswer(item.id)
            if isValid(storageModel)
                storageModel.clockData = clockData
                return storageModel
            end if

            eventModel = getDataForModel(item, "predictionWager", false, true, "predictionWager")

            for each answer in eventModel.answers
                answer.points = data.poll.expoints
                answer.itemComponent = "ActivityButtonWithImage"
            end for
            if isValid(clockData.feedbackTime)
                eventModel.feedbackTime = convertStrToInt(clockData.feedbackTime) 
            end if

            if isValid(clockData.close_post_interaction)
                eventModel.closepostinteraction = clockData.close_post_interaction
            end if
        end if
    end for

    return eventModel
end sub

sub configureEventInfoProducts(data, clockData) as object
    eventModel = {
        isShowView: false
    }

    for each item in data.products
        id = convertIntToStr(clockData.id)
        if item.id = id
            storageModel = getStorageAnswer(item.id)

            if isValid(storageModel)
                storageModel.clockData = clockData
                return storageModel
            end if

            eventModel = getDataForModel(item, "Products", false, true, "injectProduct")
            eventModel.itemComponent = "ActivityButton"
            eventModel.clockData = clockData
            eventModel.timeForHiding = clockData.timeToStay

            if isValid(clockData.feedbackTime)
                eventModel.feedbackTime = convertStrToInt(clockData.feedbackTime) 
            end if

            if isValid(clockData.close_post_interaction)
                eventModel.closepostinteraction = clockData.close_post_interaction
            end if
        end if
    end for

    return eventModel
end sub

sub configureEventInfoPrediction(data, clockData) as object
    eventModel = {
        isShowView: false
    }

    for each item in data.predictions
        id = convertIntToStr(clockData.id)
        if item.id = id
            storageModel = getStorageAnswer(item.id)

            if isValid(storageModel)
                storageModel.clockData = clockData
                return storageModel
            end if

            eventModel = getDataForModel(item, "predictions", false, true)
            eventModel.answers = getItemComponentName(eventModel.answers, "PredictionItemComponent")
            eventModel.clockData = clockData
            eventModel.timeForHiding = clockData.timeToStay

            if isValid(clockData.feedbackTime)
                eventModel.feedbackTime = convertStrToInt(clockData.feedbackTime) 
            end if

            if isValid(clockData.close_post_interaction)
                eventModel.closepostinteraction = clockData.close_post_interaction
            end if
        end if
    end for

    return eventModel
end sub


sub configureEventInfoPolls(data, clockData) as object
    eventModel = {
        isShowView: false
    }

    for each item in data.polls
        id = convertIntToStr(clockData.id)
        if item.id = id
            storageModel = getStorageAnswer(item.id)

            if isValid(storageModel)
                storageModel.clockData = clockData
                return storageModel
            end if

            eventModel = getDataForModel(item, "poll", false, true)
            eventModel.answers = getItemComponentName(eventModel.answers, "ActivityButtonWithImage")
            eventModel.clockData = clockData
            eventModel.timeForHiding = clockData.timeToStay

            if isValid(clockData.feedbackTime)
                eventModel.feedbackTime = convertStrToInt(clockData.feedbackTime) 
            end if

            if isValid(clockData.close_post_interaction)
                eventModel.closepostinteraction = clockData.close_post_interaction
            end if
        end if
    end for

    return eventModel
end sub

sub getEventInfoTrivias(data, clockData) as object

    eventModel = {
        isShowView: false
    }

    for each item in data.trivias
        id = convertIntToStr(clockData.id)
        if item.id = id
            storageModel = getStorageAnswer(item.id)
            if isValid(storageModel)
                storageModel.clockData = clockData
                return storageModel
            end if
            eventModel = getDataForModel(item, "injectQuiz", false, true, "injectQuiz")
            eventModel.answers = getItemComponentName(eventModel.answers, "ActivityButtonWithImage")
            eventModel.clockData = clockData
            eventModel.timeForHiding = clockData.timeToStay
            for each answer in eventModel.answers
                if answer.answer = item.correctAnswer.answer
                    answer.iscorrectanswer = true
                end if
            end for
            if isValid(clockData.feedbackTime)
                eventModel.feedbackTime = convertStrToInt(clockData.feedbackTime) 
            end if

            if isValid(item.correctAnswer)
                item.correctAnswer.itemComponent = "ActivityButtonWithImage"
                eventModel.answers.push(item.correctAnswer)
            end if

            if isValid(clockData.close_post_interaction)
                eventModel.closepostinteraction = clockData.close_post_interaction
            end if
        end if
    end for

    return eventModel
end sub


sub getEventInfoRatings(data, clockData) as object
    eventModel = {
        isShowView: false
    }

    for each item in data.ratings
        id = convertIntToStr(clockData.id)
        if item.id = id
            storageModel = getStorageAnswer(item.id)
            if isValid(storageModel)
                storageModel.clockData = clockData
                return storageModel
            end if
            eventModel = getDataForModel(item, "rating", false, true)
            answers = []
            if isValid(data.rating) then count = data.rating.optionsnumber.toInt()
            if isValid(item.optionsnumber) then count = item.optionsnumber.toInt()
            for i = count to 1 step -1
                answers.push({ title: i.toStr(), itemComponent: "RatingItemComponents" })
            end for
            eventModel.answers = answers
            eventModel.clockData = clockData
            eventModel.timeForHiding = clockData.timeToStay
            eventModel.questionType = "injectRating"

            if isValid(clockData.feedbackTime)
                eventModel.feedbackTime = convertStrToInt(clockData.feedbackTime) 
            end if

            if isValid(clockData.close_post_interaction)
                eventModel.closepostinteraction = clockData.close_post_interaction
            end if
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

    if data.DoesExist(EventKeyEnum()[messageType]) or eventType = "injectQuiz"
        if eventType = "injectQuiz"
            storageModel = getStorageAnswer(data.id)
        else
            storageModel = getStorageAnswer(data[EventKeyEnum()[messageType]].id)
        end if

        if isValid(storageModel)
            storageModel.timeForHiding = data.timeToStay
            if isValid(data.feedbackTime) then storageModel.feedbacktime = data.feedbackTime
            return storageModel
        end if
    end if

    if messageType = "injectPoll"
        eventModel = getDataForModel(data, EventKeyEnum()[messageType], false, true)
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
        eventModel = getDataForModel(data, EventKeyEnum()[messageType], false, true)
        eventModel.answers = getItemComponentName(eventModel.answers, "PredictionItemComponent")
    else if messageType = "injectQuiz"
        eventModel = getDataForModel(data, EventKeyEnum()[messageType], false, true, "injectQuiz")
        eventModel.answers = getItemComponentName(eventModel.answers, "ActivityButtonWithImage")
    else if messageType = "predictionWager"
        eventModel = getDataForModel(data, EventKeyEnum()[messageType], false, true, "predictionWager")

        for each answer in eventModel.answers
            answer.points = data.poll.expoints
            answer.itemComponent = "ActivityButtonWithImage"
        end for
    else if messageType = "injectWiki"
        eventModel = getDataForModel(data, EventKeyEnum()[messageType], false, true, "injectWiki")
    else if messageType = "injectProduct"
        eventModel = getDataForModel(data, EventKeyEnum()[messageType], false, true, "injectProduct")
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
    storageModel = RegRead(id, "Activity")
    if isValid(storageModel)
        storageModel = ParseJson(storageModel)
        storageModel.showAnswerView = true
        return storageModel
    end if
    return invalid
end sub

function getAnswers(answer, eventModel, responceServer)
    if eventModel.questiontype = "injectQuiz"
        eventModel.expointsGiven = responceServer.answer.pointsGiven.toStr()
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
            answer.text = m.global.localization.predictionsWagerSubmitted.Replace("{{answer}}", responce.answer.answer)
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

    for each item in EventEnum().Items()
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

function getProduct(data)
    model = {
        idEvent: data.id
        question: data.name
        closePostInteraction: false
        questionType: "injectProduct"
        answers: ""
        timeForHiding: 30
        type: "injectProduct"
        averageRate: invalid
        optionsNumber: data.optionsNumber
        icon: data.icon
        halfIcon: invalid
        emptyIcon: invalid
        buttonText: data.actionBtnText
        categoryId: data.categoryId
        currency: data.currency
        description: data.description
        image: data.image
        name: invalid
        price: data.price
        qrCodeImage: data.qrcodeimage
        userId: data.user_id
        content: data.content
        discount: data.discount
    }
    model.itemComponent = "ActivityButton"
    return model
end function