
# Пример 6: рейтинг фильмов IMDB ###############################################

# URL страницы для скраппинга
url <- 'http://www.imdb.com/search/title?count=100&release_date=2016,2016&title_type=feature'

# читаем HTML страницы
webpage <- read_html(url)

# скраппим страницу по селектору и преобразуем в текст
rank_data <- html_nodes(webpage, '.text-primary') %>% html_text
# размер вектора
length(rank_data)
# первые шесть рангов
head(rank_data) 
# конвертируем ранги в числовые данные
rank_data <- as.numeric(rank_data)
# результат
head(rank_data)


# отбор названий фильмов по селектору
title_data <- html_nodes(webpage,'.lister-item-header a') %>% html_text
# результаты
length(title_data)
head(title_data)

# описания фильмов
description_data <- html_nodes(webpage, '.ratings-bar+ .text-muted') %>% html_text
# предварительный результат
length(description_data)
head(description_data)
# предобработка: убираем перенос строки
description_data <- gsub('\n', '', description_data)
# окончательный результат
length(description_data)
head(description_data)

# длительности фильмов
runtime_data <- html_nodes(webpage, '.text-muted .runtime') %>% html_text
# предварительный результат
length(runtime_data)
head(runtime_data)
# предобработка: убираем 'min' и превращаем в числа
runtime_data <- gsub(' min', '', runtime_data)
runtime_data <- as.numeric(runtime_data)
# окончательный результат
length(runtime_data)
head(runtime_data)

# жанры фильмов
genre_data <- html_nodes(webpage, '.genre') %>% html_text
# предварительный результат
length(genre_data)
head(genre_data)
# предобработка: убираем перенос строки
genre_data <- gsub('\n', '', genre_data)
# оставляем только первый жанр для каждого фильма
genre_data <- gsub(',.*', '', genre_data)
# окончательный результат
length(genre_data)
head(genre_data)

# рейтинги IMDB
rating_data <- html_nodes(webpage, '.ratings-imdb-rating strong') %>% html_text
# предварительный результат
length(rating_data)
head(rating_data)
# предобработка: преобразуем в числа
rating_data <- as.numeric(rating_data)
# окончательный результат
length(rating_data)
head(rating_data)

# голоса
votes_data <- html_nodes(webpage, '.sort-num_votes-visible span:nth-child(2)') %>% html_text
# предварительный результат
length(votes_data)
head(votes_data)
# предобработка: убираем запятые
votes_data <- gsub(',', '', votes_data)
# предобработка: преобразуем в числа
votes_data <- as.numeric(votes_data)
# окончательный результат
length(votes_data)
head(votes_data)

# режиссер
directors_data <- html_nodes(webpage, '.text-muted+ p a:nth-child(1)') %>% html_text
# результат
length(directors_data)
head(directors_data)

# ведущий актер
actors_data <- html_nodes(webpage, '.lister-item-content .ghost+ a') %>% html_text
# результат
length(actors_data)
head(actors_data)

# селектор для общего рейтинга
metascore_data <- html_nodes(webpage, '.ratings-metascore') %>% html_text
# предварительный результат
length(metascore_data)

# функция перебора тегов внутри тегов более высокого уровня
get_tags <- function(node){
    # найти все теги с метарейтингом
    raw_data <- html_nodes(node, selector) %>% html_text
    # значения нулевой длины (для фильма нет такого тега) меняем на пропуски
    data_NAs <- ifelse(length(raw_data) == 0, NA, raw_data)
}

# это глобальная переменная будет неявно передана функции get_tags()
selector <- '.ratings-metascore'
# находим все ноды (теги) верхнего уровня, с информацией о каждом фильме
doc <- html_nodes(webpage, '.lister-item-content')
# применяем к этим тегам поиск метарейтинга и ставим NA там, где тега нет
metascore_data <- sapply(doc, get_tags)
# предварительный результат
length(metascore_data)
head(metascore_data)
# чистим данные
metascore_data <- as.numeric(gsub('Metascore|\n| ', '', metascore_data))
# окончательный результат
length(metascore_data)
head(metascore_data)

selector <- '.ghost~ .text-muted+ span'
doc <- html_nodes(webpage, '.lister-item-content')
gross_data <- sapply(doc, get_tags)
# предварительный результат
length(gross_data)
head(gross_data)
# преобразуем в числа
gross_data <- as.numeric(gsub('M|[$]', '', gross_data))
# окончательный результат
length(gross_data)
head(gross_data)

# совмещаем данные в один фрейм
DF_movies <- data.frame(Rank = rank_data, Title = title_data, 
                        Description = description_data, Runtime = runtime_data, 
                        Genre = genre_data, Rating = rating_data, 
                        Metascore = metascore_data, Votes = votes_data, 
                        Gross_Earning_in_Mil = gross_data,
                        Director = directors_data, Actor = actors_data)
# результат
dim(DF_movies)
str(DF_movies)

# записываем в .csv
write.csv(DF_movies, file = 'top100-IMDB-2016.csv', row.names = F)
# сделать запись в лог
write(paste('Файл "top100-IMDB-2016.csv" записан', Sys.time()), 
      file = log.filename, append = T)
