# Esly russkie bukvy ne otobrajautsa: File -> Reopen with encoding... UTF-8

# Используйте UTF-8 как кодировку по умолчанию!
# Установить кодировку в RStudio: Tools -> Global Options -> General, 
#  Default text encoding: UTF-8

# Аналитический пакет R: Занятие 1

# Загрузка пакетов
library('XML')                 # разбор XML-файлов
library('RCurl')               # работа с HTML-страницами
library('httr')                # работа с HTML-страницами -- надёжнее, чем RCurl
library('rjson')               # чтение формата JSON
library('rvest')               # работа с DOM сайта
library('dplyr')               # инструменты трансформирования данных




# Часть 1: Загрузка данных -----------------------------------------------------



# Загрузка файла .csv из сети ==================================================


# Пример 1: Импорт масла в РФ ##################################################

# адрес файла с данными по импорту масла в РФ
fileURL <- 'https://raw.githubusercontent.com/aksyuk/R-data/master/COMTRADE/040510-Imp-RF-comtrade.csv'
data.dir <- './data'
dest.file <- './data/040510-Imp-RF-comtrade.csv'

# создаём директорию для данных, если она ещё не существует:
if (!file.exists(data.dir)) dir.create(data.dir)

# создаём файл с логом загрузок, если он ещё не существует:
log.filename <- './data/download.log'
if (!file.exists(log.filename)) file.create(log.filename)

# загружаем файл, если он ещё не существует,
#  и делаем запись о загрузке в лог:
if (!file.exists(dest.file)) {
    # загрузить файл 
    download.file(fileURL, dest.file)
    # сделать запись в лог
    write(paste('Файл', dest.file, 'загружен', Sys.time()), 
          file = log.filename, append = T)
}

# читаем данные из загруженного .csv во фрейм, 
#  если он ещё не существует
if (!exists('DF.import')) {
    DF.import <- read.csv(dest.file, stringsAsFactors = F)    
}
# предварительный просмотр
dim(DF.import)     # размерность таблицы
str(DF.import)     # структура (характеристики столбцов)
head(DF.import)    # первые несколько строк таблицы
tail(DF.import)    # последние несколько строк таблицы

# справочник к данным
# https://github.com/aksyuk/R-data/blob/master/COMTRADE/CodeBook_040510-Imp-RF-comtrade.md



# Парсинг XML ==================================================================


# Пример 2: Учебная XML-страница ###############################################

# адрес XML-страницы
fileURL <- 'https://www.w3schools.com/xml/simple.xml'

# загружаем содержимое в объект doc
doc <- getURL(fileURL)

# разбираем объект как XML
parsedXML <- xmlTreeParse(doc, useInternalNodes = T)

# просмотр загруженного документа
# ВНИМАНИЕ: не повторять для больших страниц!
parsedXML

# корневой элемент XML-документа  
rootNode <- xmlRoot(parsedXML)  

# имя корневого тега  
xmlName(rootNode)  

# объект rootNode относится к специальному типу «XML запись»  
class(rootNode)  

# имена тегов, дочерних к корню (именованный вектор)  
names(rootNode)  

# первый элемент дерева (обращаемся как к элементу списка)  
rootNode[[1]]  

# первый потомок первого потомка корневого тега...  
rootNode[[1]][[1]]  

# ...и его содержимое  
xmlValue(rootNode[[1]][[1]])  

# извлечь все значения из потомков в XML-записи  
values.all <- xmlSApply(rootNode, xmlValue)  

# просмотреть первые два элемента  
values.all[1:2]  

# вытащить содержимое тегов "name" на любом уровне
xpathSApply(rootNode, "//name", xmlValue)

# вытащить содержимое тегов "price" на любом уровне
xpathSApply(rootNode, "//price", xmlValue)

# разобрать XML-страницу и собрать данные в таблицу
DF.food <- xmlToDataFrame(rootNode, stringsAsFactors = F)
# предварительный просмотр
dim(DF.food)     # размерность таблицы
str(DF.food)     # структура (характеристики столбцов)


# Пример 3: Обменные курсы евро ################################################

# обменный курс евро по отношению к иностранным
#  валютам, на текущую дату
fileURL <- 'https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml'
# xmlParse() не работает с https, поэтому сначала читаем страницу как текст
doc <- getURL(fileURL)
# и разбираем содержимое в объект doc
parsedXML <- xmlParse(doc, useInternalNodes = T)

# корневой элемент
rootNode <- xmlRoot(parsedXML)
# класс объекта rootNode
class(rootNode)

# имя корневого элемента
xmlName(rootNode)

# вытаскиваем имена всех тегов документа (*)
#  на любом уровне иерархии (//)

tag <- xpathSApply(rootNode, "//*", xmlName)
# оставляем только уникальные
tag <- unique(tag)

# считаем их количество
length(tag)

# смотрим названия
tag

# в документе есть теги с явно объявленным пространством имён (namespace) gesmes
try.tag <- xpathSApply(rootNode, "//name", xmlValue)         # пусто
try.tag
try.tag <- xpathSApply(rootNode, "//gesmes:name", xmlValue)  # тег найден
try.tag

# посмотреть пространство имён xml-документа
xmlNamespace(rootNode)

# а информация о курсах записана в тегах Cube без явного namespace
#  поэтому используем функцию name() для поиска тега
# source: https://stackoverflow.com/questions/45634155/parse-nested-xml-with-namespaces-in-r
tag <- xpathSApply(rootNode, "//*[name()='Cube']", xmlGetAttr, 'currency')
tag
curr.names <- unlist(tag)

# курсы обмена
tag <- xpathSApply(rootNode, "//*[name()='Cube']", xmlGetAttr, 'rate')
tag
curr.rate <- unlist(tag)

# дата (обращаемся только к тегу Cube, в котором есть атрибут time)
tag <- xpathSApply(rootNode, "//*[name()='Cube'][@time]", xmlGetAttr, 'time')
tag

# превращаем XML во фрейм
DF.EUR <- cbind(curr.names, curr.rate, tag)
colnames(DF.EUR) <- c('Валюта', 'Курс к евро', 'Дата')
# предварительный просмотр
dim(DF.EUR)     # размерность таблицы
str(DF.EUR)     # структура (характеристики столбцов)



# Парсинг HTML =================================================================


# Пример 4: Список книг с Википедии ############################################

# URL страницы топ-200 книг по версии BBC на Википедии
fileURL <- "https://ru.wikipedia.org/wiki/200_%D0%BB%D1%83%D1%87%D1%88%D0%B8%D1%85_%D0%BA%D0%BD%D0%B8%D0%B3_%D0%BF%D0%BE_%D0%B2%D0%B5%D1%80%D1%81%D0%B8%D0%B8_%D0%91%D0%B8-%D0%B1%D0%B8-%D1%81%D0%B8"

# загружаем текст html-страницы, явно указывая кодировку (помогает от проблем с кириллицей)
# html <- getURL(fileURL, .encoding = 'UTF-8')  # работает под Linux
html <- GET(fileURL)     # работает под Windows

# класс объекта с загруженным содержимым
class(html)
class(content(html))     # только для функции GET()

# разбираем как html
# parsedHTML <- htmlParse(html)       # для getURL()
parsedHTML <- htmlParse(httr::content(html, as = 'text'),
                        useInternalNodes = T)             # для GET()

# корневой элемент
rootNode <- xmlRoot(parsedHTML)

# выбираем все наименования книг
wiki.title <- xpathSApply(rootNode, '//span[@class="mw-headline"][1]/parent::h2/following-sibling::div//li/a[1]',
                          xmlGetAttr, 'title')
# проверяем длину
length(wiki.title)

# просмотр первых трёх элементов вектора
wiki.title[1:3]

# исправляем кодировку
Encoding(wiki.title) <- 'UTF-8'
wiki.title[1:3]

# выбираем всех авторов книг
wiki.author <- xpathSApply(rootNode, '//span[@class="mw-headline"][1]/parent::h2/following-sibling::div//li/a[2]',
                           xmlGetAttr, 'title')
# проверяем длину
length(wiki.author)

# исправляем кодировку
Encoding(wiki.author) <- 'UTF-8'
wiki.author[1:3]

# выбираем все ссылки на книги
wiki.link <- xpathSApply(rootNode, '//span[@class="mw-headline"][1]/parent::h2/following-sibling::div//li/a[1]',
                         xmlGetAttr, 'href')
# проверяем длину
length(wiki.link)
# просмотр первых трёх элементов вектора
wiki.link[1:3]

# выделяем те книги, у которых нет страниц на Википедии. Ссылки при этом есть, но их класс 'new'
wiki.no.page <- xpathSApply(rootNode,
                            '//span[@class="mw-headline"][1]/parent::h2/following-sibling::div//li/a[1][@class="new"]',
                            xmlGetAttr, 'title')
# исправляем кодировку
Encoding(wiki.no.page) <- 'UTF-8'
wiki.no.page[1:3]

# делаем ссылки на страницу-заглушку "такой страницы на Википедии нет" пропусками
wiki.link[wiki.title %in% wiki.no.page] <- NA

# добавляем адрес сайта во внутренние ссылки
wiki.link[!is.na(wiki.link)] <- paste0('https://ru.wikipedia.org', 
                                       wiki.link[!is.na(wiki.link)])

# объединяем во фрейм
DF.wiki <- data.frame(Книга = wiki.title, Автор = wiki.author, Ссылка = wiki.link)
# записываем в файл .csv
write.csv(DF.wiki, file = './data/DF_wiki.csv', row.names = F)
# сделать запись в лог
write(paste('Файл "DF_wiki.csv" записан', Sys.time()), 
      file = log.filename, append = T)



# Веб-скраппинг с пакетом "rvest" ==============================================


# Пример 5: рейтинг фильмов IMDB ###############################################

# URL страницы для скраппинга
fileURL <- 'https://www.imdb.com/search/title/?title_type=feature&release_date=2016-01-01,2016-12-31'

# читаем HTML страницы
doc <- read_html(fileURL, encoding = 'UTF-8')

# скраппим страницу по селектору и преобразуем в текст
rank_data <- doc %>% html_nodes('.text-primary') %>% html_text

length(rank_data)      # размер вектора
head(rank_data)        # первые шесть рангов
# конвертируем ранги в числовые данные
rank_data <- as.numeric(rank_data)
head(rank_data)

# отбор названий фильмов по селектору
title_data <- doc %>% html_nodes('.lister-item-header a') %>% html_text
length(title_data)
head(title_data)

# описания фильмов
description_data <- doc %>% html_nodes('.ratings-bar+ .text-muted') %>% 
  html_text()
length(description_data)
head(description_data)

# длительности фильмов
runtime_data <- doc %>% html_nodes('.text-muted .runtime') %>% html_text
length(runtime_data)
head(runtime_data)

# жанры фильмов 
genre_data <- doc %>% html_nodes('.genre') %>% html_text
length(genre_data)
head(genre_data)

# селектор для общего рейтинга (метарейтинга) 
metascore_data <- doc %>% html_nodes('.ratings-metascore') %>% html_text
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
doc <- html_nodes(doc, '.lister-item-content')
# применяем к этим тегам поиск метарейтинга и ставим NA там, где тега нет
metascore_data <- sapply(doc, get_tags)
# предварительный результат
length(metascore_data)
head(metascore_data)

# совмещаем данные в один фрейм
DF_movies_short <- data.frame(Rank = rank_data, Title = title_data, 
                              Description = description_data, 
                              Runtime = runtime_data, 
                              Genre = genre_data,  Metascore = metascore_data)
# результат
dim(DF_movies_short)
str(DF_movies_short)

# записываем в .csv
write.csv(DF_movies_short, file = './data/DF_movies_short.csv', row.names = F)
# сделать запись в лог
write(paste('Файл "DF_movies_short.csv" записан', Sys.time()), 
      file = log.filename, append = T)



# Загрузка данных с помощью API ================================================


# Пример 6: Импорт масла в РФ по годам #########################################


# Статистика международной торговли из базы UN COMTRADE

# адрес справочника по странам UN COMTRADE
fileURL <- "http://comtrade.un.org/data/cache/partnerAreas.json"
# загружаем данные из формата JSON
reporters <- fromJSON(file = fileURL)
is.list(reporters)

# соединяем элементы списка построчно
reporters <- t(sapply(reporters$results, rbind))
dim(reporters)

# превращаем во фрейм
reporters <- as.data.frame(reporters)
head(reporters)

# даём столбцам имена
names(reporters) <- c('State.Code', 'State.Name.En')
# находим РФ
reporters[reporters$State.Name.En == 'Russian Federation', ]

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
file.name <- './data/comtrade_2010.csv'
write.csv(s1$data, file.name, row.names = F)

# загрузка данных в цикле
for (i in 2011:2020) {
    # таймер для ограничения API: не более запроса в секунду
    Sys.sleep(5)
    s1 <- get.Comtrade(r = 'all', p = "643", 
                       ps = as.character(i), freq = "M",
                       rg = '1', cc = '040510',
                       fmt = "csv")
    # имя файла для сохранения
    file.name <- paste0('./data/comtrade_', i, '.csv')
    # записать данные в файл
    write.csv(s1$data, file.name, row.names = F)
    # вывести сообщение в консоль
    print(paste('Данные за', i, 'год сохранены в файл', 
                file.name))
    # сделать запись в лог
    write(paste('Файл', file.name, 'загружен', Sys.time()), 
          file = log.filename, append = T)
}
