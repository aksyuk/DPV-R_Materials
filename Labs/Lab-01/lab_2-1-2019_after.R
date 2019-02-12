# Esly russkie bukvy ne otobrajautsa: File -> Reopen with encoding... UTF-8

# Используйте UTF-8 как кодировку по умолчанию!
# Установить кодировку в RStudio: Tools -> Global Options -> General, 
#  Default text encoding: UTF-8

# Аналитический пакет R: Занятие 1

# Часть 1: Загрузка данных -----------------------------------------------------

# Загрузка пакетов
library('XML')                 # разбор XML-файлов
library('RCurl')               # работа с HTML-страницами
library('rjson')               # чтение формата JSON
library('rvest')     # работа с DOM сайта
library('dplyr')     # инструменты трансформирования данных


# Загрузка файла .csv из сети ==================================================

# Пример 1 #####################################################################

# адрес файла с данными по импорту масла в РФ
fileURL <- 'https://raw.githubusercontent.com/aksyuk/R-data/master/COMTRADE/040510-Imp-RF-comtrade.csv'

# создаём директорию для данных, если она ещё не существует:
data.dir <- './data'
if (!file.exists(data.dir)) {
    dir.create(data.dir)
}

# создаём файл с логом загрузок, если он ещё не существует:
log.filename <- './data/download.log'
if (!file.exists(log.filename)) {
    file.create(log.filename)
}

# загружаем файл, если он ещё не существует,
#  и делаем запись о загрузке в лог:
data.filename <- './data/040510-Imp-RF-comtrade.csv'
if (!file.exists(data.filename)) {
    download.file(fileURL, data.filename) 
    # сделать запись в лог
    write(paste('Файл ', data.filename,' загружен', Sys.time()), 
          file = log.filename, append = T)
}

# читаем данные из загруженного .csv во фрейм, если он ещё не существует
if (!exists('DF.import')){
    DF.import <- read.csv(data.filename, as.is = T) 
}

# предварительный просмотр
dim(DF.import)     # размерность таблицы
str(DF.import)     # структура (характеристики столбцов)
head(DF.import)    # первые несколько строк таблицы
tail(DF.import)    # последние несколько строк таблицы

# справочник к данным
# https://github.com/aksyuk/R-data/blob/master/COMTRADE/CodeBook_040510-Imp-RF-comtrade.md


# Парсинг XML ==================================================================

# Пример 2 #####################################################################

# адрес учебной XML-страницы
fileURL <- "https://www.w3schools.com/xml/simple.xml"

doc <- getURL(fileURL)

# загружаем содержимое в объект doc
doc <- xmlTreeParse(doc, useInternalNodes = T)

# просмотр загруженного документа
# ВНИМАНИЕ: не повторять для больших страниц!
doc

# корневой элемент
rootNode <- xmlRoot(doc)
# класс объекта rootNode
class(rootNode)
# имя корневого тега
xmlName(rootNode)
# имена тегов, дочерних к корню
names(rootNode)
# первый элемент дерева
rootNode[[1]]

# ...и его первый тег...
rootNode[[1]][[1]]
# ...и содержимое этого тега
xmlValue(rootNode[[1]][[1]])

# извлечь определённую часть файла
values.all <- xmlSApply(rootNode, xmlValue)
values.all[1:2]

# вытащить содержимое тегов "name" на любом уровне (//)
xpathSApply(rootNode, "//name", xmlValue)

# вытащить содержимое тегов "price" на любом уровне (//)
xpathSApply(rootNode, "//price", xmlValue)

# разобрать XML-страницу и собрать данные в таблицу
DF.food <- xmlToDataFrame(rootNode, stringsAsFactors = F)
# предварительный просмотр
dim(DF.food)     # размерность таблицы
str(DF.food)     # структура (характеристики столбцов)
head(DF.food)    # первые несколько строк таблицы





# Пример 3 #####################################################################

# обменный курс белорусского рубля по отношению к иностранным валютам,
#  устанавливаемый ежемесячно, на последнюю дату установления 
fileURL <-  'http://www.nbrb.by/Services/XmlExRates.aspx?period=1'

# загружаем содержимое в объект doc
doc <- xmlTreeParse(fileURL, useInternalNodes = T)

# корневой элемент
rootNode <- xmlRoot(doc)
# класс объекта rootNode
class(rootNode)
# имя корневого тега
xmlName(rootNode)

# сколько уникальных тегов в документе?
# вытаскиваем имена всех тегов документа на любом уровне иерархии
tag <- xpathSApply(rootNode, "//*", xmlName)
# оставляем только уникальные
tag <- unique(tag)
# считаем их количество
length(tag)
tag

# сколько валют в файле?
# вытаскиваем все значения из тегов "CharCode"
cur <- xpathSApply(rootNode, "//CharCode", xmlValue)
# считаем количество уникальных
length(unique(cur))
### [1] 52

# превращаем во фрем. Чего здесь нет? ДАТЫ
DF.BYB <- xmlToDataFrame(rootNode, stringsAsFactors = F)
# предварительный просмотр
dim(DF.BYB)     # размерность таблицы
str(DF.BYB)     # структура (характеристики столбцов)

# извлекаем дату
BYB.date <- xpathSApply(rootNode, "//*[@Date]", xmlAttrs)
BYB.date

# добавляем даты во фрейм
DF.BYB$Date.chr <- rep(BYB.date, dim(DF.BYB)[1])
# снова проверяем структуру фрейма
str(DF.BYB)





# Парсинг HTML =================================================================

# Пример 4 #####################################################################

# URL страницы поиска в Яндекс: "Импорт в Россию"
fileURL <- "https://yandex.ru/yandsearch?clid=2186618&text=%D0%B8%D0%BC%D0%BF%D0%BE%D1%80%D1%82%20%D0%B2%20%D0%A0%D0%BE%D1%81%D1%81%D0%B8%D1%8E"

# загружаем текст html-страницы
html <- getURL(fileURL)
# разбираем как html
doc <- htmlTreeParse(html, useInternalNodes = T)
# корневой элемент
rootNode <- xmlRoot(doc)

# выбираем все заголовки результатов запроса (версия 7.02.2017)
h <- xpathSApply(rootNode, '//a[contains(@class, "organic__url")]',
                 xmlValue)
h[1:3]
# [1] "ВЭД РФ: данные импорта/экспорта. / marketing1.ru"   
# [2] "Внешняя торговля России — Википедия"                
# [3] "Итоги внешней торговли России в 2015 году: цифры..."

length(h)

# выбираем все источники результатов запроса (версия 7.02.2017)
s <- xpathSApply(rootNode, '//div[contains(@class, "organic__subtitle")]/a[contains(@class, "link link_outer_yes"][1]', 
                 xmlValue)
s[1:3]
length(s)

# объединяем во фрейм
DF.news <- data.frame(Header = h, Source = s, stringsAsFactors = F)
dim(DF.news)
str(DF.news)





# Загрузка данных с помощью API ================================================

# Пример 5 #####################################################################

# адрес справочника по странам UN COMTRADE
fileURL <- "http://comtrade.un.org/data/cache/partnerAreas.json"
# загружаем данные из формата JSON
reporters <- fromJSON(fileURL) ### ОШИБКА ПОД LINUX
is.list(reporters)
### [1] TRUE
# соединяем элементы списка построчно
reporters <- sapply(reporters$results, rbind)
dim(reporters)
### [1] 293   2
# превращаем во фрейм
reporters <- as.data.frame(reporters)
head(reporters)
###    id                     text
### 1 all                      All
### 2   0                    World
### 3   4              Afghanistan
### 4 472 Africa CAMEU region, nes
# даём столбцам имена
names(reporters) <- c('State.Code', 'State.Name.En')
# ищем РФ
reporters[reporters$State.Name.En == 'Russian Federation', ]
###     State.Code      State.Name.En
### 219        643 Russian Federation

# функция, реализующая API (источник: UN COMTRADE)
source("https://raw.githubusercontent.com/aksyuk/R-data/master/API/comtrade_API.R")


# ежемесячные данные по импорту масла в РФ за 2010 год
# 040510 – код сливочного масла по классификации HS
s1 <- get.Comtrade(r = 'all', p = "643", 
                   ps = as.character(2010), freq="M",
                   rg = '1', cc = '040510',
                   fmt="csv")
dim(s1$data)
### [1] 10 35
is.data.frame(s1$data)
# создаём директорию
if (!file.exists('./data')) {dir.create('./data')}
# записываем в файл
write.csv(s1$data, './data/comtrade_2010.csv', row.names = F)

# загрузка данных и сохранение файлов в цикле
for (i in 2011:2017) {
    Sys.sleep(5)
    s1 <- get.Comtrade(r = 'all', p = "643", ps = as.character(i), freq="M",
                       rg = '1', cc = '040510',
                       fmt="csv")
    file.name <- paste('./data/comtrade_', i, '.csv', sep = '')
    write.csv(s1$data, file.name, row.names = F)
    # вывести сообщение в консоль
    print(paste('Данные за', i, 'год сохранены в файл', file.name))
    # сделать запись в лог
    write(paste('Файл', paste('comtrade_', i, '.csv', sep = ''), 
                'загружен', Sys.time()), 
          file = './data/download.log', append = T)
}





# Часть 2: Очистка и трансформация данных --------------------------------------

# Загрузка пакетов
library('data.table')          # работа с объектами 'data.table'
library('dplyr')               # функции для выборок из таблиц
library('plyr')                # функции для трансформации данных


# Объекты для хранения таблиц в R: data.frame и data.table =====================

# Пример 6 #####################################################################

# учимся работать с data.table
# сделать генерацию случайных чисел воспроизводимой
set.seed(12345)
# создание таблицы аналогично созданию фрейма
DF <- data.frame(x = round(rnorm(n = 12), 1), 
                 y = round(rnorm(n = 12, mean = 15), 1), 
                 grp = rep(c('A', 'B', 'C'), 4))
DT <- data.table(x = round(rnorm(n = 12), 1), 
                 y = round(rnorm(n = 12, mean = 15), 1), 
                 grp = rep(c('A', 'B', 'C'), 4))
# ещё можно делать одно из другого
DT.2 <- data.table(DF)
# вывести список таблиц в памяти
tables()
# выбрать строки таблицы по номеру (так же как для фрейма)
DT.2[c(2, 4), ]

# выбрать строки таблицы по условию
DT.2[grp == 'A', ]  # ВНУТРИ [] МОЖНО УКАЗЫВАТЬ ТОЛЬКО ИМЯ СТОЛБЦА

# выбрать строки фрейма по условию
DF[DF$grp == 'A', ]

# выбрать столбцы фрейма по номеру
head(DF[, c(1, 2)], n = 3)
# в таблице это не работает!
DT.2[, c(1, 2)]
### [1] 1 2

# после запятой указывается выражение, которое применяется к таблице
DT.2[, list(mean(x), sum(y), sum(is.na(grp)))]
DT.2[, table(grp)]

# выбор столбцов таблицы по номеру
head(DT.2[, c(1, 2), with = F], 3)

# нужны только столбцы с этими именами 
names.select <- c('x', 'grp')
head(DT.2[, colnames(DT.2) %in% names.select, with = F], n = 3)

# выбор столбцов функцией select() пакета dplyr
head(select(DT.2, x, grp), n = 3)

# новый столбец z, равный сумме x и y
DT.2[, z := x + y]
head(DT.2, n = 2)

# отменим изменения, скопировав DT.2 из DT
DT.2 <- DT
# новый столбец w, равный 2
DT.2[, w := 2]
head(DT.2, n = 2)
head(DT, n = 2)

# несколько последовательных трансформаций данных
DT.2[, s := {tmp <- x - min(x) + 1; log10(tmp)}]
head(DT.2, n = 2)

# найти среднее x по каждой группе значений grp
DT.2[, mean.x.gpp := mean(x), by = grp]
DT.2

# количество строк по каждой группе из переменной grp
DT.2[, .N, by = grp]

# отбор только наблюдений из группы grp и их сортировка по убыванию x
DT.2[grp == 'A', .SD[order(-y)]]

# номера наблюдений, значения переменной y в которых максимальны
# по каждой из групп по переменной grp
DT.2[, .I[which.max(y)], by=grp]
# номера групп по переменной grp
DT.2[, .GRP, by=grp]

# ключи
DT.3 <- data.table(grp.val = c(100, 200, 300),
                   grp = c('A', 'B', 'C'))
# задать ключи
setkey(DT.2, grp)
setkey(DT.3, grp)

# просмотр таблиц
tables()

# объединение таблиц по ключу
merge(DT.2, DT.3, by.x = 'grp', by.y = 'grp')





# Нормализация данных ==========================================================

# Продолжение примера 4 ########################################################

# возвращаемся к выдаче Яндекса по запросу "Импорт в Россию"
DT.news <- data.table(DF.news)
head(DT.news, n = 4)

# номера заголовков, в которых встречается слово "импорт"
grep('импорт', DT.news$Header)
### [1] 1  5  9 10 11 12 15

# значения этих заголовков
grep('импорт', DT.news$Header, value = T)
# [1] "ВЭД РФ: данные импорта/экспорта. / marketing1.ru"                                
# [2] "Ответы@Mail.Ru: Из каких стран идет импорт и экспорт в Россию? И что поставляют?"
# [3] "«Россия-экспорт-импорт» — сайт о внешней торговле"                               
# [4] "Федеральная таможенная служба - Экспорт-импорт..."                               
# [5] "Что есть: Как изменился импорт продуктов в Россию"                               
# [6] "Анализ импорта/экспорта - 39000р. / all-market.info"

# количество строк со словом "импорт" и без него
table(grepl('импорт', DT.news$Header))
### FALSE  TRUE 
###     9     6

# поиск с регулярным выражением
has.import <- grepl('[и|И]мпорт', DT.news$Header)
table(has.import)
### FALSE  TRUE 
###     6     9 

# строка, в которой слово не встречается
DT.news[!has.import, ]
#                                                     Header           Source
# 1:                     Внешняя торговля России — Википедия ru.wikipedia.org
# 2:     Итоги внешней торговли России в 2015 году: цифры...        провэд.рф
# 3: Внешняя торговля::Федеральная служба государственной...           gks.ru
# 4:                     Внешняя торговля России — Википедия    ru.rfwiki.org
# 5:    Виза в Россию из Германии. Какие – есть 10 вариантов      llcentre.ru
# 6:         Переводы с 57 языков! От 250 руб! / ooozippy.ru      ooozippy.ru

# слово "Импорт" в начале строки
grep('^Импорт', DT.news$Header, value = T)
# [1] "Импорт в Россию — Documentation"              
# [2] "Импорт в Россию, Экспорт из РФ - Бизнес форум"
# [3] "Импорт 2016. Аналитика / customstat.ru"

# ".ru" в конце строки: точка выделена как спецсимвол
grep('\\.ru$', DT.news$Header, value = T)

# на самом деле точка обозначает любой символ
grep('.', DT.news$Header, value = T)

# заголовки, в которых присутствуют цифры
grep('\\d+', DT.news$Header, value = T)

# найти и убрать всё что начинается с " / " или " | " до конца строки
gsub(' [/||] .*$', '', DT.news$Header)
# звёздочка находит максимально длинную строку по условию
gsub(' [/||] .*$', '', 'Абв / где | 12345 / 11')
### [1] "Абв"

# удалим источники из первого столбца таблицы:
DT.news[, Header:=gsub(' [/||] .*$', '', Header)]
DT.news[1:4, Header]

object.size(DF.news)
### 3048 bytes
object.size(DT.news)
### 3504 bytes
system.time(DF.news$Header <- gsub(' [/||] .*$', '', DF.news$Header))
### пользователь      система       прошло 
###            0            0            0 
system.time(DT.news[, Header:=gsub(' [/||] .*$', '', Header)])
### пользователь      система       прошло 
###        0.002        0.000        0.028


# Предобработка заголовков столбцов ============================================

# Продолжение примера 5 ########################################################

# проверяем, на месте ли наши файлы со статистикой по импорту
dir('./data')

# читаем всё в одну таблицу
# флаг: является ли этот файл первым?
flag.is.first <- T
for (i in 2010:2017) {
    # собираем имя файла
    file.name <- paste('./data/comtrade_', i, '.csv', sep = '')
    # читаем данные во фрейм
    df <- read.csv(file.name, header = T, as.is = T)
    if (flag.is.first) {
        # если это первый файл, просто копируем его
        DT <- df
        flag.is.first <- F         # и снимаем флаг
    } else {
        # если это не первый файл, добавляем строки в конец таблицы
        DT <- rbind(DT, df)
    }
    print(paste('Файл ', file.name, ' прочитан.'))  # сообщение в консоль
}
DT <- data.table(DT)           # переводим в формат data.table
# убираем временные переменные
rm(df, file.name, flag.is.first, i)

# размерность таблицы
dim(DT)
# имена столбцов
names(DT)
# копируем имена в символьный вектор, чтобы ничего не испортить
nms <- colnames(DT)
# заменить серии из двух и более точек на одну
nms <- gsub('[.]+', '.', nms)
# убрать все хвостовые точки
nms <- gsub('[.]+$', '', nms)
# заменить US на USD
nms <- gsub('Trade.Value.US', 'Trade.Value.USD', nms)
# проверяем, что всё получилось, и заменяем имена столбцов
colnames(DT) <- nms
# результат обработки имён столбцов
names(DT)

# считаем пропущенные
# номера наблюдений, по которым пропущен вес поставки в килограммах
which(is.na(DT$Netweight.kg))
###  [1]   2   7   9  10  33  34  94  95 117 118 130 150
# их количество
length(which(is.na(DT$Netweight.kg)))
### [1] 12

# делаем такой подсчёт по каждому столбцу
na.num <- apply(DT, 2, function(x) length(which(is.na(x))))
na.num
# в каких столбцах все наблюдения пропущены?
col.remove <- na.num == dim(DT)[1]
col.remove

# компактный просмотр результата
data.frame(names(na.num), na.num, col.remove,
           row.names = 1:length(na.num))

# уберём эти столбцы из таблицы
DT <- DT[, !col.remove, with = F]
dim(DT)
# смотрим структуру данных
str(DT, vec.len = 2)

# Запишем объединённую очищенную таблицу в один файл
write.table(DT, './data/040510-Imp-RF-comtrade.csv', 
            sep = ',', dec = '.', row.names = F)



# Создание справочника к данным ================================================
# справочник создаётся в формате .md (Markdown).
# Справочник к данным по импорту можно посмотреть по адресу: 
#  https://github.com/aksyuk/R-data/blob/master/COMTRADE/CodeBook_040510-Imp-RF-comtrade.md
