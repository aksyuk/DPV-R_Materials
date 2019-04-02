
# Портал открытых данных РФ ----------------------------------------------------

library('RCurl')
library('jsonlite')
library('XML')

URL.base <- 'http://data.gov.ru/api/'
API.key <- '7d5e6a0ab1c8e540492c8b7012575bcd'

getOpenDataRF <- function(api.params, url.base = URL.base, api.key = API.key) {
    par <- paste0(api.params, collapse = '/')
    url <- paste0(url.base, par, '/?access_token=', api.key)
    message(paste0('Загружаем ', url, ' ...'))
    fromJSON(getURL(url))
}

params <- c('dataset')
datasets <- getOpenDataRF(params)

nrow(datasets)
str(datasets)

head(datasets[, c('title', 'identifier')])

dataset_id <- '8911021426-aptekalist'
params <- c('dataset', dataset_id)
dataset <- getOpenDataRF(params)

params <- c(params, 'version')
versions <- getOpenDataRF(params)
nrow(versions)

mrv <- versions[nrow(versions), 1]
params <- c(params, mrv)
content <- c(params, 'content')
doc <- getOpenDataRF(content)
head(doc)


dataset_id <- '8901017727-shematbo'
params <- c('dataset', dataset_id, 'version')
versions <- getOpenDataRF(params)
params <- c(params, versions[nrow(versions), 1], 'content')
dataset <- getOpenDataRF(params)
head(dataset)

# широта
lat <- dataset$`Географические координаты`
lat <- as.numeric(gsub(pattern = "([0-9]{2})°.*", replacement = "\\1", lat)) + 
    as.numeric(gsub(pattern = "[0-9]{2}°([0-9]{2})[\\].*", 
                    replacement = "\\1", lat)) / 60 + 
    as.numeric(gsub(pattern = "[0-9]{2}°[0-9]{2}[\\]'([0-9]{2})[\\].*", 
                    replacement = "\\1", lat)) / 3600

# долгота
long <- dataset$`Географические координаты`
long <- as.numeric(gsub(pattern = ".+([0-9]{2})°.*", replacement = "\\1", long)) + 
    as.numeric(gsub(pattern = ".+[0-9]{2}°([0-9]{2})[\\].*", 
                    replacement = "\\1", long)) / 60 + 
    as.numeric(gsub(pattern = ".+[0-9]{2}°[0-9]{2}[\\]'([0-9]{2})[\\].*", 
                    replacement = "\\1", long)) / 3600

dataset$long <- long
dataset$lat <- lat
dataset$`Географические координаты` <- NULL

write.csv2(dataset, file = "F:/GitHub/R-data/examples/YNao_tbo.csv", 
           row.names = F)

# API Яндекс-карт --------------------------------------------------------------

URL.base <- 'https://geocode-maps.yandex.ru/1.x/'
API.key <- '4805f844-8782-4568-b6ee-3b476bd3be07'

getYandexMaps <- function(api.params, url.base = URL.base, api.key = API.key) {
    par <- paste0(api.params, collapse = '&')
    url <- paste0(url.base, '/?access_token=', api.key, par)
    message(paste0('Загружаем ', url, ' ...'))
    
    doc <- getURL(url)
    rootNode <- xmlRoot(xmlTreeParse(doc, useInternalNodes = T))
    strsplit(xpathSApply(rootNode, "//*[local-name()='pos']", xmlValue),
             split = ' ')[[1]]
}

coords <- sapply(as.list(doc$Адрес), function(x) {
    params <- paste0('&geocode=', gsub(x[1], pattern = ' ', 
                                       replacement = '+'))
    getYandexMaps(params)
    })
df.coords <- as.data.frame(t(coords))
colnames(df.coords) <- c('long', 'lat')

doc <- cbind(doc, df.coords)

write.csv2(doc, file = "F:/GitHub/R-data/examples/Urengoy_pharmacies.csv", 
           row.names = F)

# Вконтакте --------------------------------------------------------------------

library('RCurl')
library('rjson')
library('igraph')

access_token <- '761041f85995985c87ebe7995640244bb6a218bc0859393ffa49cc3088bb1de4831a9c002bdc565c66eaf'
ver <- '5.92'
method <- 'friends.get'
params <- list(order = 'hints', fields = 'city')
params <- sprintf('?%s', paste0(names(params), '=', unlist(params), 
                                collapse = '&', sep = ''))

url <- sprintf('https://api.vk.com/method/%s%s&access_token=%s&v=%s',
               method, params, access_token, ver)
data <- getURL(url)

friends.list <- fromJSON(data)

vk <- function(method, params) {
    if (!missing(params)) {
        params <- sprintf('?%s', paste0(names(params), '=',
                                        unlist(params), collapse = '&'))
    } else {
        params <- ''
    }
    url <- sprintf('https://api.vk.com/method/%s%s&access_token=%s&v=%s',
                   method, params, access_token, ver)
    data <- getURL(url)
    tryCatch({
        list <- fromJSON(data)
    }, error = function(e) {
        print(data)
        stop(e)
    })
    list$response
}

uid <- '15525469'
params <- list(user_id = uid, fields = 'city')
friends.list <- vk('friends.get', params)

df.friends.cities <- 
    data.frame(name = paste(sapply(friends.list$items, function(x) x$first_name),
                            sapply(friends.list$items, function(x) x$last_name)),
               city = as.character(sapply(friends.list$items, 
                                          function(x) x$city$title)))

table(df.friends.cities$city)

ids <- sapply(friends.list$items, function(x) {x$id})
# ids <- ids[1:10]

n <- length(friends.list$items)
friends.lists <- vector(length = n)
for (i in 1:n) {
    params <- list(user_id = ids[i], fields = 'city')
    list <- vk('friends.get', params)
    friends.lists[i] <- list(list$items)    
}

friends.lists <- c(friends.lists, list(ids))

n <- length(friends.lists)
mutuals <- matrix(nrow = n, ncol = n)
for (i in 1:n) {
    for (j in 1:n) {
        mutuals[i, j] <- sum(friends.lists[[i]] %in% friends.lists[[j]])
    }
}

g <- graph_from_adjacency_matrix(mutuals, weighted = T, mode = 'undirected',
                                 diag = F)
V(g)$name <- as.character(1:n)

isolated <- V(g)[degree(g) == 0]
g <- g - vertices(isolated)

# rm(access_token, coords, count, data, friends.list, i, ids, isolated, j, 
#    list, method, mutuals, n, params, uid, url, ver, vk)

if (!dir.exists('data')) {
    dir.create('data')
}
save.image(file = './data/network_data.RData')

egam <- max(E(g)$weight + 0.5) / (E(g)$weight + 0.5)
coords <- layout_with_kk(g, weights = egam)

png(file = 'graph.png')
plot(g, layout = coords, vertex.size = 15)
dev.off()
