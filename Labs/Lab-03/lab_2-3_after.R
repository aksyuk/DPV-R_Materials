# Esly russkie bukvy ne otobrajautsa: File -> Reopen with encoding... UTF-8

# Используйте UTF-8 как кодировку по умолчанию!
# Установить кодировку в RStudio: Tools -> Global Options -> General, 
#  Default text encoding: UTF-8

# Аналитический пакет R: Занятие 3

# Часть 1: Интерактивные веб-приложения в пакете "shiny" -----------------------

# загрузка пакетов
library('shiny')               # создание интерактивных приложений
library('lattice')             # графики lattice
library('ggplot2')             # графики ggplot2
library('data.table')          # работаем с объектами "таблица данных"
library('dplyr')               # трансформации данных
library('lubridate')           # работа с датами, ceiling_date()
library('zoo')                 # работа с датами, as.yearmon() 



# Пример 1 #####################################################################

# Создать приложение, которое строит гистограммы распределения характеристик 
#  цветка ириса из встроенного набора данных iris. Пользователь может 
#  выбирать один из трёх видов ирисов и ширину интервала гистограммы.

# встроенный набор данных airquality
?iris
# все уникальные значения видов ирисов
unique(iris$Species)

# создать папку для файлов приложения
if (!file.exists('./iris_hist_app')) {
    dir.create('./iris_hist_app')}

# создать файлы приложения
# ui.R
if (!file.exists('./iris_hist_app/ui.R')) {
    file.create('./iris_hist_app/ui.R')}
# server.R
if (!file.exists('./iris_hist_app/server.R')) {
    file.create('./iris_hist_app/server.R')}

# ДАЛЬШЕ ИЗМЕНЯЕМ ФАЙЛЫ ПРИЛОЖЕНИЯ: ui.R и server.R

# запустить приложение
runApp('./iris_hist_app', launch.browser = T,
       display.mode = 'showcase')





# Пример 2 #####################################################################

# Создать приложение, которое строит график разброса, таблицу описательных 
#  статистик и отчёт по модели регрессии двух переменных из встроенного набора 
#  данных airquality. Построим график в пакете «ggplot2». Дать пользователю 
#  возможность выбирать переменные и месяцы, за которые берутся наблюдения.

# встроенный набор данных airquality
?airquality
# переменные в таблице
names(airquality)

# число наблюдений по месяцам
DT <- data.table(airquality)
DT[, .N, by = Month]

# СКАЧИВАЕМ, РАСПАКОВЫВАЕМ в папку ./air_plot_app 
#  И ИЗМЕНЯЕМ ФАЙЛЫ ПРИЛОЖЕНИЯ: ui.R и server.R



# запустить приложение
runApp('./air_plot_app', launch.browser = T,
       display.mode = 'showcase')





# Часть 2: Трансформация и агрегирование данных --------------------------------

# Пример 3 #####################################################################

# Cпециальные функции для трансформации данных из пакета «dplyr»

# загружаем файл с данными по импорту масла в РФ (из прошлой практики)
fileURL <- 'https://raw.githubusercontent.com/aksyuk/R-data/master/COMTRADE/040510-Imp-RF-comtrade.csv'
# создаём директорию для данных, если она ещё не существует:
if (!file.exists('./data')) dir.create('./data')
# загружаем файл, если он ещё не существует
if (!file.exists('./data/040510-Imp-RF-comtrade.csv')) {
    download.file(fileURL, './data/040510-Imp-RF-comtrade.csv')}
# читаем данные из загруженного .csv во фрейм, если он ещё не существует
if (!exists('DT.import')){
    DT.import <- data.table(read.csv('./data/040510-Imp-RF-comtrade.csv', as.is = T))
}

# выбираем столбцы функцией select
select(DT.import, Period, Reporter, Trade.Value.USD)

# добавляем условие на отбор строк функцией filter
filter(select(DT.import, Period, Reporter, Trade.Value.USD), 
       Reporter == 'EU-27')

# рассчитать суммарную массу поставок по каждой стране
select(DT.import, Reporter, Trade.Value.USD) %>% 
    group_by(Reporter) %>% 
    mutate(Trade.Value.USD.by.country = sum(Trade.Value.USD))

# переводим период в дату: КОНЕЦ соответствующего месяца
DT.import[, Period.Date := ceiling_date(as.POSIXct(as.yearmon(as.character(Period), 
                                                              '%Y%m')),
                                        unit = 'month') - days(1)]
# что получилось
DT.import[, c('Period', 'Period.Date'), with = F]

# убираем столбец с периодом в виде текста, оставляем дату
DT.import <- select(DT.import, Period.Date, Reporter, 
                    Reporter, Trade.Value.USD)
# смотрим результат
head(DT.import, n = 3)

# Пример 4 #####################################################################

# Создать приложение, которое загружает данные по импорту масла в РФ, 
#  агрегирует их по месяцам либо по кварталам, по выбору пользователя, 
#  фильтрует по выбранной стране, строит график динамики и выводит таблицу. 
#  Дать возможность сохранить результат – отфильтрованные и агрегированные 
#  данные – можно сохранить в файл с расширением «.csv».

# СКАЧИВАЕМ, РАСПАКОВЫВАЕМ в папку ./import_app 
#  И ИЗМЕНЯЕМ ФАЙЛЫ ПРИЛОЖЕНИЯ: ui.R и server.R




# запустить приложение
runApp('./import_app_before', launch.browser = T,
       display.mode = 'showcase')
