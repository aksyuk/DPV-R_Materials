# Esly russkie bukvy ne otobrajautsa: File -> Reopen with encoding... UTF-8

# Используйте UTF-8 как кодировку по умолчанию!
# Установить кодировку в RStudio: Tools -> Global Options -> General, 
#  Default text encoding: UTF-8

# Аналитический пакет R: Занятие 4 ---------------------------------------------

# Создание статических картограмм ==============================================

# загрузка пакетов
library('R.utils')               # gunzip() для распаковки архивов 
library('sp')                    # функция spplot()
library('ggplot2')               # функция ggplot()
library('RColorBrewer')          # цветовые палитры
require('rgdal')                 # функция readOGR()
library('broom')                 # функция tidy()
require('dplyr')                 # функция join()
library('scales')                # функция pretty_breaks()
# Rtools: https://cran.r-project.org/bin/windows/Rtools/
# install.packages("gpclib", type = "source")
library('gpclib')
library('maptools')

gpclibPermit()


# Пример 2 #####################################################################
# Административная карта Республики Беларусь
# источник примера: 
#  http://www.ievbras.ru/ecostat/Kiril/R/Mastitsky%20and%20Shitikov%202014.pdf

# загрузить ShapeFile с http://www.gadm.org
ShapeFileURL <- "http://biogeo.ucdavis.edu/data/gadm2.8/shp/BLR_adm_shp.zip"
if (!file.exists('./data')) dir.create('./data')
if (!file.exists('./data/BLR_adm_shp.zip')) {
    download.file(ShapeFileURL, destfile = './data/BLR_adm_shp.zip')
}
# распаковать архив
unzip('./data/BLR_adm_shp.zip', exdir = './data/BLR_adm_shp')
# посмотреть список файлов распакованного архива
dir('./data/BLR_adm_shp')

# прочитать данные уровней 0, 1, 2
Regions0 <- 
Regions1 <- 
Regions2 <- 
    
# контурные карты для разных уровней иерархии
par(mfrow = c(1, 3))
par(oma = c(0, 0, 0, 0))
par(mar = c(0, 0, 1, 0))



par(mfrow = c(1, 1))

# убрать лишние объекты из памяти


# структура объекта Regions1


# имена слотов


# слот "данные"


# слот "полигоны"


# картограмма Беларуси, на которой каждая область залита своим цветом
# делаем фактор из имён областей (т.е. нумеруем их)
Regions1@data$NAME_1 <- 
Regions1@data$NAME_1

# строим картограмму
spplot(
       scales = list(draw = T),
       col.regions = rainbow(n = 6)
       )

# вариант с палитрой из пакета ColorBrewer и без координатной сетки
spplot(
       col.regions = 
       par.settings = list(axis.line = list(col = NA)))

# больше вариантов палитр на все случаи жизни: 
# https://moderndata.plot.ly/create-colorful-graphs-in-r-with-rcolorbrewer-and-plotly/


# Пример 3 #####################################################################
# Административная карта Республики Беларусь, регионы раскрашены
#  по значениям непрерывного числового показателя

# загружаем статистику с показателями по регионам
fileURL <- 'https://raw.githubusercontent.com/aksyuk/R-data/master/STATE_STAT/BLR_Regions_2014.csv'
stat.Regions <- 
stat.Regions

# вносим данные в файл карты
Regions1@data <- 
    
# задаём палитру
mypalette <- 

# строим картограмму численности населения
spplot(
       col.regions = mypalette(20),  # определение цветовой шкалы
       col = 'coral4',               # цвет контурных линий на карте
       par.settings = list(axis.line = list(col = NA))) # без осей

# то же - с названиями областей
spplot( 
       col.regions = mypalette(16), col = 'coral4', 
       main = 'Численность населения, человек',
       panel = function(x, y, z, subscripts, ...) {
         
         }
)

rm(Regions1)



# Пример 4 #####################################################################
# Перестроить последний график из примера 3 средствами ggplot2

# Формируем данные для ggplot
#  читаем ShapeFile из папки, с указанием уровня
Regions <- 
    
# создаём столбец-ключ id для связи с другими таблицами
#  (названия регионов из столбца NAME_1)
Regions@data$id <- 
# преобразовать SpatialPolygonsDataFrame в data.frame

Regions.points <- 
# добавить к координатам сведения о регионах
Regions.df <- 
# добавляем к координатам значения показателя для заливки
#  (численность населения из фрейма stat.Regions)
stat.Regions$id <- 
Regions.df <- 
    
    
names(Regions.df)

# координаты центров полигонов (для подписей регионов)
centroids.df <- 
centroids.df$id <- 
colnames(centroids.df) <- c('long', 'lat', 'id')

# создаём график
gp <- ggplot() + 
    geom_polygon() +
    geom_path() +
    coord_map(projection = 'gilbert') +
    scale_fill_distiller(palette = 'OrRd',
                         direction = 1,
                         breaks = pretty_breaks(n = 5)) +
    labs(x = 'Долгота', y = 'Широта', 
         title = "Численность населения, человек") +
    geom_text(data = centroids.df, 
                       aes(long, lat, label = id))
# выводим график
gp

  