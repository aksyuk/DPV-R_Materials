
library('RCurl')
library('rjson')

access_token <- ''
ver <- '5.92'
method <- 'friends.get'
params <- list(order = 'hints', fields = 'city')
params <- sprintf('?%s', paste0(names(params), '=', unlist(params), 
                                collapse = '&', sep = ''))

url <- sprintf('https://api.vk.com/method/%s%s&access_token=%s&v=%s',
               method, params, access_token, ver)
data <- getURL(url)

friends.list <- fromJSON(data)

lapply(friends.list$response[2][[1]], cbind)

