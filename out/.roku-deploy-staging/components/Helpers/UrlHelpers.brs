sub baseUrl() as string
    return "https://itg-dev4.inthegame.io/"
end sub

sub getRegistrationUrl() as string
    return baseUrl() + "userApi/user/register"
end sub

sub getLoginizationUrl() as string
    return baseUrl() + "userApi/user/login_by_token"
end sub

sub getInfoAppUrl() as string
    return baseUrl() + "userApi/streamer/getInfo"
end sub

sub getSendAnswerUrl(typeAnswer, id) as string
    if typeAnswer = "poll" or typeAnswer = "prediction"
        return baseUrl() + "userApi/poll/answer_new/" + id
    else if typeAnswer = "injectRating"
        return baseUrl() + "userApi/rating/answer_new/" + id
    else if typeAnswer = "injectQuiz"
        return baseUrl() + "userApi/trivia/answer/" + id
    end if
end sub

sub getQuizUrl(id) as string
    return baseUrl() + "userApi/trivia/getQuestionById/" + id
end sub