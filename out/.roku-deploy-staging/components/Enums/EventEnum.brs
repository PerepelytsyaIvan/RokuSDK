sub EventEnum() as object
    return {
        idEvent: "id"
        question: ["question", "name", "question"]
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
        content: "content"
        discount: "discount"
    }
end sub

sub EventKeyEnum() as object
    return {    "injectPoll": "poll", 
                "injectRating": "rating", 
                "prediction": "poll", 
                "injectQuiz": "injectQuiz", 
                "predictionWager": "poll", 
                "injectWiki": "wiki", 
                "injectProduct": "product"}
end sub