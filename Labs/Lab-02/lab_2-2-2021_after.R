# Esly russkie bukvy ne otobrajautsa: File -> Reopen with encoding... UTF-8

# Используйте UTF-8 как кодировку по умолчанию!
# Установить кодировку в RStudio: Tools -> Global Options -> General, 
#  Default text encoding: UTF-8

# Аналитический пакет R: Занятие 2


# Очистка и трансформация данных -----------------------------------------------

# загрузка пакетов
library('dplyr')               # манипуляции с тиббл-таблицами
library('nycflights13')        # данные по полётам из Нью-Йорка
library('data.table')          # объекты "таблица данных"


# Преобразование данных с помощью пакета `dplyr` ===============================


# Пример 1: Авиарейсы из Нью-Йорка в 2013 г. ###################################

# отображение объекта типа "тиббл-таблица"
flights


# Фильтруем строки с filter() ..................................................

# отбираем все рейсы 1 января
filter(flights, month == 1, day == 1)

# присваивание + отображение
(jan.1 <- filter(flights, month == 1, day == 1))

# тонкий момент: отбор строк по логическому выражению
# рейсы только в январе и декабре
filter(flights, month == 11 | month == 12)
# ошибка: функция выдаст всю таблицу
filter(flights, month == 11 | 12)
# более универсальный и безопасный вариант
filter(flights, month %in% c(11, 12))   

# несколько логических условий на строки
filter(flights, arr_delay <= 120, dep_delay >= 180)


# Переставляем строки с arrange() ..............................................

# сортируем по возрастанию даты
arrange(flights, year, month, day)

# сортируем по убыванию задержки
arrange(flights, desc(dep_delay))

# пропуски сортируются в конец таблицы
df <- tibble(x = c(5, 2, NA))
arrange(df, x)


# Отбираем столбцы с select() ..................................................

# выбрать столбцы по имени year, month, day
select(flights, year, month, day)

# выбрать столбцы между year и day (включая их)
select(flights, year:day)

# выбрать столбцы кроме year и day (и кроме них)
select(flights, -(year:day))

# столбцы, имена которых заканчиваются на 'delay' (задержка)
select(flights, ends_with('_delay'))

# переставить время рейса и время полёта в начало таблицы
select(flights, time_hour, air_time, everything())

# переименовать столбец с использованием змеиного регистра
(flights.mod <- rename(flights, tail_num = tailnum))
# убедимся, что столбец переименован
select(flights.mod, tail_num, everything())


# Добавляем новые столбцы с mutate() ...........................................

# выборка из таблицы: только нужные столбцы
(flights_sml <- select(flights, year:day, ends_with('delay'), 
                       distance, air_time))

# нагнанное время и скорость
mutate(flights_sml, 
       gain = arr_delay - dep_delay,
       speed = distance / air_time * 60)

# сразу используем новые столбцы
mutate(flights_sml, 
       gain = arr_delay - dep_delay,
       hours = air_time / 60,
       gain_per_hour = gain / hours)

# transmute() оставляет только новые столбцы
transmute(flights_sml, 
          gain = arr_delay - dep_delay,
          hours = air_time / 60,
          gein_per_hour = gain / hours)


# Агрегируем таблицу с summarize() .............................................

# средняя задержка вылета
summarize(flights, delay = mean(dep_delay, na.rm = T))

# то же по каждому дню
by_day <- group_by(flights, year, month, day)
summarize(by_day, delay = mean(dep_delay, na.rm = T))

# группировка + агрегирование + фильтрация средствами 'dplyr'
# группируем рейсы по пунктам назначения
by_dest <- group_by(flights, dest)
# по группам считаем число рейсов, средние расстояние и задержку прибытия
delay <- summarize(by_dest,
                   count = n(),
                   dist = mean(distance, na.rm = T),
                   delay = mean(arr_delay, na.rm = T))
# фильтруем строки: пункты с числом опозданий больше 20, кроме Гонолулу
(delay <- filter(delay, count > 20, dest != 'HNL'))

# то же с использованием канала %>%
(delays <- flights %>%
        group_by(dest) %>%
        summarize(count = n(),
                  dist = mean(distance, na.rm = T),
                  delay = mean(arr_delay, na.rm = T)) %>%
        filter(count > 20, dest != 'HNL'))


# Объекты для хранения больших таблиц: data.table ==============================

# объект типа data.table
DT.flights <- data.table(flights)

# делаем то же, что сделали средствами dplyr:
# группировка + агрегирование + фильтрация
delay.2 <- DT.flights[, list(count = .N, 
                             dist = mean(distance, na.rm = T),
                             delay = mean(arr_delay, na.rm = T)),
                      by = dest]
delay.2

# в data.frame нельзя сразу обращаться к новым столбцам
DT.flights[, list(gain = arr_delay - dep_delay,
                  hours = air_time / 60,
                  gain_per_hour = (arr_delay - dep_delay) / (air_time / 60))]

# отбор только наблюдений из группы, их усреднение и сортировка по убыванию
DT.flights.sml <- DT.flights[, list(month, arr_delay, dest)]
DT.flights.sml[dest == 'DSM', 
               list(count = .N,
                    mean_arr_delay_DSM = mean(arr_delay, na.rm = T)), 
               by = month][, .SD[order(-mean_arr_delay_DSM)]]


# Очистка текстовых значений ===================================================


# Пример 2: Таблица топ-100 2016 года с imdb ###################################

# разобрать самостоятельно по методичке


# Предобработка заголовков столбцов ============================================


# Пример 3: Импорт масла в РФ ##################################################

# проверяем, на месте ли наши файлы со статистикой по импорту
dir('./data')
# имена файлов
data.filename <- paste0('./data/comtrade_', 2010:2020, '.csv')

# # если нет, качаем по новой
# # создаём директорию для данных, если она ещё не существует:
# data.dir <- './data'
# if (!file.exists(data.dir)) dir.create(data.dir)
# # создаём файл с логом загрузок, если он ещё не существует:
# log.filename <- './data/download.log'
# if (!file.exists(log.filename))file.create(log.filename)
# # загружаем файл, если он ещё не существует,
# #  и делаем запись о загрузке в лог:
# file.URL <- paste0('https://raw.githubusercontent.com/aksyuk/',
#                    'R-data/master/COMTRADE/comtrade_',
#                    2010:2020, '.csv')
# for (i in 1:length(data.filename)) {
#     if (!file.exists(data.filename[i])) {
#         download.file(file.URL[i], data.filename[i])
#         write(paste('Файл ', data.filename[i],' загружен', Sys.time()),
#               file = log.filename, append = T)
#     }
# }
# rm(file.URL, i)

# читаем всё в одну таблицу
# флаг: является ли этот файл первым?
flag.is.first <- T
for (i in 1:length(data.filename)) {
    # читаем данные во фрейм
    df <- read.csv(data.filename[i], header = T, stringsAsFactors = F)
    if (flag.is.first) {
        # если это первый файл, просто копируем его
        DT <- df
        flag.is.first <- F         # и снимаем флаг
    } else {
        # если это не первый файл, добавляем строки в конец таблицы
        DT <- rbind(DT, df)
    }
    # сообщение в консоль
    message(paste('Файл ', data.filename[i], ' прочитан.')) 
}
# переводим в формат data.table
DT <- data.table(DT)           
# убираем временные переменные
rm(df, data.filename, flag.is.first, i)

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

# дополнительный пример
#  убрать всё, что идёт после первой точки
gsub('(.*)[.].*$', '\\1', nms)
#  убрать всё, что идёт после последней точки
gsub('^(.*)[.](.*$)', '\\2', nms)

# заменить US на USD
nms <- gsub('Trade.Value.US', 'Trade.Value.USD', nms)
# проверяем, что всё получилось, и заменяем имена столбцов
colnames(DT) <- nms
# результат обработки имён столбцов
names(DT)

# считаем пропущенные
# номера наблюдений, по которым пропущен вес поставки в килограммах
which(is.na(DT$Netweight.kg))
# их количество
length(which(is.na(DT$Netweight.kg)))

# делаем такой подсчёт по каждому столбцу
na.num <- apply(DT, 2, function(x) length(which(is.na(x))))
na.num
# в каких столбцах все наблюдения пропущены?
col.remove <- na.num == dim(DT)[1]

# компактный просмотр результата в одной таблице  
data.frame(names(na.num), na.num, col.remove,
           row.names = 1:length(na.num))

# уберём эти столбцы из таблицы
DT <- DT[, !col.remove, with = F]
dim(DT)

# смотрим статистику по столбцам
summary(DT)

# Запишем объединённую очищенную таблицу в один файл
write.csv(DT, './data/040510-Imp-RF-comtrade.csv', row.names = F)


# Создание справочника к данным ================================================
# справочник создаётся в формате .md (Markdown).
# Справочник к данным по импорту можно посмотреть по адресу: 
#  https://github.com/aksyuk/R-data/blob/master/COMTRADE/CodeBook_040510-Imp-RF-comtrade.md
