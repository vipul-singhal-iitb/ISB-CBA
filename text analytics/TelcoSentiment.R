airtel.tweets <- searchTwitter('to:@airtel_presence', n=100, lang="en")
airtel.text = laply(airtel.tweets, function(t) t$getText())
airtel.text = gsub("[^[:alnum:]|^[:space:]]", "", airtel.text)
airtel.scores <- score.sentiment(airtel.text, pos.words, 
                                   neg.words, .progress='text')
airtel.scores$team = 'Bharti Airtel'
airtel.scores$code = 'AIRTEL'

vodafone.tweets <- searchTwitter('to:@vodafonein', n=100, lang="en")
vodafone.text = laply(vodafone.tweets, function(t) t$getText())
vodafone.text = gsub("[^[:alnum:]|^[:space:]]", "", vodafone.text)
vodafone.scores <- score.sentiment(vodafone.text, pos.words, 
                                   neg.words, .progress='text')
vodafone.scores$team = 'Vodafone India'
vodafone.scores$code = 'vodafone'

hotstartweets.tweets <- searchTwitter('to:@hotstartweets', n=1000, lang="en")
hotstartweets.text = laply(hotstartweets.tweets, function(t) t$getText())
hotstartweets.text = gsub("[^[:alnum:]|^[:space:]]", "", hotstartweets.text)
hotstartweets.scores <- score.sentiment(hotstartweets.text, pos.words, 
                                   neg.words, .progress='text')
hotstartweets.scores$team = 'hotstar tweets'
hotstartweets.scores$code = 'hotstar'


telco.scores = rbind(airtel.scores, vodafone.scores, hotstartweets.scores)

ggplot(data=telco.scores) +
    geom_bar(mapping=aes(x=score, fill=team), binwidth=1) + 
    facet_grid(team~.) +
    theme_bw() + scale_color_brewer() +
    labs(title="Telco Teams Sentiment")

