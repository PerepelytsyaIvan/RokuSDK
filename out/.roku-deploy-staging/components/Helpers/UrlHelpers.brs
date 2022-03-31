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
    if typeAnswer = "poll" or typeAnswer = "prediction" or typeAnswer = "predictionWager" or typeAnswer = "injectPoll"
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

sub getAvatarsUrl() as string
    return baseUrl() + "userApi/user/getAvailableAvatars/avatar/null"
end sub

sub getLeadersUrl() as string
    ' return baseUrl() + "userApi/leaderboard/getLeaders"
    return "https://itg-test4.inthegame.io/userApi/leaderboard/getLeaders"
end sub

sub getProductUrl() as string
    return baseUrl() + "userApi/shop/getProducts"
end sub

sub buyItemUrl() as string
    return baseUrl() + "userApi/shop/buyItem"
end sub