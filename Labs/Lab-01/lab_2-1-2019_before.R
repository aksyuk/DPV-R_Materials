# Esly russkie bukvy ne otobrajautsa: File -> Reopen with encoding... UTF-8

# Используйте UTF-8 как кодировку по умолчанию!
# Установить кодировку в RStudio: Tools -> Global Options -> General, 
#  Default text encoding: UTF-8

# Аналитический пакет R: Занятие 1

# Загрузка пакетов
library('XML')                 # разбор XML-файлов
library('RCurl')               # работа с HTML-страницами
library('rjson')               # чтение формата JSON
library('rvest')     # работа с DOM сайта
library('dplyr')     # инструменты трансформирования данных


# Часть 1: Загрузка данных -----------------------------------------------------


# Загрузка файла .csv из сети ==================================================


# Пример 1: Импорт масла в РФ ##################################################

# адрес файла с данными по импорту масла в РФ
fileURL <- 'https://raw.githubusercontent.com/aksyuk/R-data/master/COMTRADE/040510-Imp-RF-comtrade.csv'

# создаём директорию для данных, если она ещё не существует:
data.dir <- 


    
    
# создаём файл с логом загрузок, если он ещё не существует:
log.filename <- './data/download.log'




# загружаем файл, если он ещё не существует,
#  и делаем запись о загрузке в лог:
log.filename <- './data/download.log'








# читаем данные из загруженного .csv во фрейм, 
#  если он ещё не существует
if (!exists('DF.import')){
    DF.import <-    

}
# предварительный просмотр





# справочник к данным
# https://github.com/aksyuk/R-data/blob/master/COMTRADE/CodeBook_040510-Imp-RF-comtrade.md


# Парсинг XML ==================================================================


# Пример 2: Учебная XML-страница ###############################################

# адрес XML-страницы
fileURL <- 'https://www.w3schools.com/xml/simple.xml'

# загружаем содержимое в объект doc
doc <- 

# разбираем объект как XML
doc <- 

# просмотр загруженного документа
# ВНИМАНИЕ: не повторять для больших страниц!
doc

# корневой элемент XML-документа  
rootNode <-  

# имя корневого тега  
 

# объект rootNode относится к специальному типу «XML запись»  
 

# имена тегов, дочерних к корню (именованный вектор)  
  

# первый элемент дерева (обращаемся как к элементу списка)  
 

# первый потомок первого потомка корневого тега...  
 

# ...и его содержимое  
 

# извлечь все значения из потомков в XML-записи  
values.all <-  

# просмотреть первые два элемента  
  

# вытащить содержимое тегов "name" на любом уровне


# вытащить содержимое тегов "price" на любом уровне


# разобрать XML-страницу и собрать данные в таблицу
DF.food <- 
# предварительный просмотр

    
    
    
# Пример 3: Обменные курсы белорусского рубля ##################################

# обменный курс белорусского рубля по отношению к иностранным
#  валютам, на последнюю дату установления 
fileURL <- 'http://www.nbrb.by/Services/XmlExRates.aspx?period=1'
# загружаем содержимое в объект doc
doc <- 

# корневой элемент
rootNode <- 
# класс объекта rootNode
class(rootNode)

xmlName(rootNode)

# вытаскиваем имена всех тегов документа (*)
#  на любом уровне иерархии (//)

tag <- 
# оставляем только уникальные
tag <- 

# считаем их количество
length(tag)

# смотрим названия
tag

# вытаскиваем все значения из тегов "CharCode"
cur <- 

# считаем количество уникальных
length(unique(cur))

# превращаем XML во фрем
DF.BYB <- 
# предварительный просмотр
dim(DF.food)     # размерность таблицы
str(DF.food)     # структура (характеристики столбцов)

# извлекаем дату
BYB.date <- 
BYB.date

# добавляем даты во фрейм
DF.BYB$Date.chr <- 

# снова проверяем структуру фрейма
str(DF.BYB)


# Парсинг HTML =================================================================


# Пример 4: Поисковая выдача Яндекс ############################################

# URL страницы поиска в Яндекс: "Импорт в Россию"
fileURL <- "https://yandex.ru/search/?lr=37141&text=%D0%B8%D0%BC%D0%BF%D0%BE%D1%80%D1%82%20%D0%B2%20%D0%A0%D0%BE%D1%81%D1%81%D0%B8%D1%8E"

# загружаем текст html-страницы
html <- 

# разбираем как html
doc <- 

# корневой элемент
rootNode <- 

# выбираем все заголовки результатов запроса
h <- xpathSApply(rootNode, '//li[@class="serp-item"]//div[contains(@class, "organic__url-text")]/following::a[contains(@class, "organic__url")]', 
                 xmlValue)
# просмотр первых трёх элементов вектора
h[1:3]

# выбираем все источники результатов запроса
s <- xpathSApply(rootNode, '//li[@class="serp-item"]//div[contains(@class, "organic__url-text")]/following::a[contains(@class, "organic__url")]', xmlGetAttr, 'href')

# просмотр первых трёх элементов вектора
s[1:3]

DF.news <- 

# просмотр результата
dim(DF.news)                  # размерность
str(DF.news)                  # структура

# записываем в файл .csv
write.csv(DF.news, file = './data/DF_news.csv', row.names = F)


# Загрузка данных с помощью API ================================================


# Пример 5: Импорт масла в РФ ##################################################


# Статистика международной торговли из базы UN COMTRADE

# адрес справочника по странам UN COMTRADE
fileURL <- "http://comtrade.un.org/data/cache/partnerAreas.json"
# загружаем данные из формата JSON
reporters <- 
is.list(reporters)

# соединяем элементы списка построчно
reporters <- 
dim(reporters)

# превращаем во фрейм
reporters <- 
head(reporters)

# даём столбцам имена
names(reporters) <- c('State.Code', 'State.Name.En')
# находим РФ


# функция, реализующая API (источник: UN COMTRADE)
source("https://raw.githubusercontent.com/aksyuk/R-data/master/API/comtrade_API.R")
# ежемесячные данные по импорту масла в РФ за 2010 год
# 040510 – код сливочного масла по классификации HS
s1 <- get.Comtrade(r = 'all', p = "643", 
                   ps = as.character(2010), freq = "M",
                   rg = '1', cc = '040510',
                   fmt = "csv")
dim(s1$data)
is.data.frame(s1$data)

# записываем выборку за 2010 год в файл


# загрузка данных в цикле
for (i in 2011:2018) {
    # таймер для ограничения API: не более запроса в секунду
    Sys.sleep(5)
    s1 <- get.Comtrade(r = 'all', p = "643", 
                       ps = as.character(i), freq="M",
                       rg = '1', cc = '040510',
                       fmt="csv")
    # имя файла для сохранения
    file.name <- paste('./data/comtrade_', i, '.csv', 
                       sep = '')
    # записать данные в файл
    write.csv(s1$data, file.name, row.names = F)
    # вывести сообщение в консоль
    print(paste('Данные за', i, 'год сохранены в файл', 
                file.name))
    # сделать запись в лог
    write(paste('Файл', 
                paste('comtrade_', i, '.csv', sep = ''), 
                'загружен', Sys.time()), 
          file = log.filename, append = T)
}



# Веб-скраппинг с пакетом "rvest" ==============================================


# Пример 6: рейтинг фильмов IMDB ###############################################

# URL страницы для скраппинга
url <- 'http://www.imdb.com/search/title?count=100&release_date=2016,2016&title_type=feature'

# читаем HTML страницы
webpage <- 

# скраппим страницу по селектору и преобразуем в текст
rank_data <- 
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

# окончательный результат
length(description_data)
head(description_data)

# длительности фильмов
runtime_data <- html_nodes(webpage, '.text-muted .runtime') %>% html_text
# предварительный результат
length(runtime_data)
head(runtime_data)
# предобработка: убираем 'min' и превращаем в числа


# окончательный результат
length(runtime_data)
head(runtime_data)

# жанры фильмов
genre_data <- html_nodes(webpage, '.genre') %>% html_text
# предварительный результат
length(genre_data)
head(genre_data)
# предобработка: убираем перенос строки

# оставляем только первый жанр для каждого фильма

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
    
    # значения нулевой длины (для фильма нет такого тега) меняем на пропуски
    
}

# это глобальная переменная будет неявно передана функции get_tags()
selector <- '.ratings-metascore'
# находим все ноды (теги) верхнего уровня, с информацией о каждом фильме
doc <- 
# применяем к этим тегам поиск метарейтинга и ставим NA там, где тега нет
metascore_data <- 
# предварительный результат
length(metascore_data)
head(metascore_data)
# чистим данные

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
      file = './data/download.log', append = T)
