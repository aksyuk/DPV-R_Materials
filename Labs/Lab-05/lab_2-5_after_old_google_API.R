# Esly russkie bukvy ne otobrajautsa: File -> Reopen with encoding... UTF-8

# Используйте UTF-8 как кодировку по умолчанию!
# Установить кодировку в RStudio: Tools -> Global Options -> General, 
#  Default text encoding: UTF-8

# Аналитический пакет R: Занятие 4 ---------------------------------------------

# Создание статических картограмм ==============================================

# загрузка пакетов
library('R.utils')               # gunzip() для распаковки архивов 
library('dismo')                 # gmap() для загрузки Google карты
library('raster')                # функции для работы с растровыми картами в R
library('maptools')              # инструменты для создания картограмм
library('sp')                    # функция spplot()
library('RColorBrewer')          # цветовые палитры
require('rgdal')                 # функция readOGR()
require('plyr')                  # функция join()
library('ggplot2')               # функция ggplot()
library('scales')                # функция pretty_breaks()
# Rtools: https://cran.r-project.org/bin/windows/Rtools/
install.packages("gpclib", type = "source")
library('gpclib')
library('mapproj')

gpclibPermit()


# Пример 1 #####################################################################

# Нулевая параллель и нулевой меридиан

long.min <- -20      # западная долгота, левая граница карты
long.max <- 20       # восточная долгота, правая граница карты
lat.min <- -20        # южная широта, нижняя граница карты
lat.max <- 20        # северная широта, верхняя граница карты

# делаем 'рамку' для участка карты
e <- extent(long.min, long.max, lat.min, lat.max)
# загружаем заданный участок спутниковой карты с Google Maps
g <- gmap(e, type = 'satellite')
# график
plot(g, interpolate = TRUE)

# координаты для параллелей и меридианов 
meridian <- data.frame(x = rep(seq(long.min, long.max, by = 10), each = 200), 
                       y = rep(seq(lat.min, lat.max, length = 200), 5))
parallel <- data.frame(x = rep(seq(long.min, long.max, length = 200), 5),
                       y = rep(seq(lat.min, lat.max, by = 10), each = 200))
# наносим линии (точечный пунктир)
points(Mercator(meridian), col = 'gray', pch = '.')
points(Mercator(parallel), col = 'gray', pch = '.')
# поверх белым цветом рисуем нулевые параллель и меридиан
meridian0 <- data.frame(x = rep((long.max + long.min) / 2, 200), 
                        y = seq(lat.min, lat.max, length = 200))
parallel0 <- data.frame(x = seq(long.min, long.max, length = 200), 
                        y = rep((lat.max + lat.min) / 2, 200))
points(Mercator(meridian0), col = 'white', pch = '.', cex = 2)
points(Mercator(parallel0), col = 'white', pch = '.', cex = 2)

# То же гораздо севернее
long.min <- -20      # западная долгота, левая граница карты
long.max <- 20       # восточная долгота, правая граница карты
lat.min <- 40        # южная широта, нижняя граница карты
lat.max <- 80       # северная широта, верхняя граница карты


# Пример 2 #####################################################################
# Административная карта Республики Беларусь
# источник примера: 
#  http://www.ievbras.ru/ecostat/Kiril/R/Mastitsky%20and%20Shitikov%202014.pdf

# загрузить ShapeFile с http://www.gadm.org
ShapeFileURL <- "http://biogeo.ucdavis.edu/data/gadm2.8/shp/BLR_adm_shp.zip"
if(!file.exists('./data')) dir.create('./data')
if(!file.exists('./data/BLR_adm_shp.zip')) {
    download.file(ShapeFileURL, destfile = './data/BLR_adm_shp.zip')
}
# распаковать архив
unzip('./data/BLR_adm_shp.zip', exdir = './data/BLR_adm_shp')
# посмотреть список файлов распакованного архива
dir('./data/BLR_adm_shp')
###  [1] "BLR_adm0.cpg" "BLR_adm0.csv" "BLR_adm0.dbf" "BLR_adm0.prj"
###  [5] "BLR_adm0.shp" "BLR_adm0.shx" "BLR_adm1.cpg" "BLR_adm1.csv"
###  [9] "BLR_adm1.dbf" "BLR_adm1.prj" "BLR_adm1.shp" "BLR_adm1.shx"
###  [13] "BLR_adm2.cpg" "BLR_adm2.csv" "BLR_adm2.dbf" "BLR_adm2.prj"
###  [17] "BLR_adm2.shp" "BLR_adm2.shx" "license.txt" 

# прочитать данные уровней 0, 1, 2
Regions0 <- readShapePoly("./data/BLR_adm_shp/BLR_adm0.shp")
Regions1 <- readShapePoly("./data/BLR_adm_shp/BLR_adm1.shp")
Regions2 <- readShapePoly("./data/BLR_adm_shp/BLR_adm2.shp")
# контурные карты для разных уровней иерархии
par(mfrow = c(1, 3))
plot(Regions0, main = 'adm0', asp = 1.8)
plot(Regions1, main = 'adm1', asp = 1.8)
plot(Regions2, main = 'adm2', asp = 1.8)
par(mfrow = c(1, 1))

# убрать лишние объекты из памяти
rm(Regions0, Regions2)

# структура объекта Regions1
str(Regions1)

# имена слотов
slotNames(Regions1)
### [1] "data"        "polygons"    "plotOrder"   "bbox"       
### [5] "proj4string"

# слот "данные"
Regions1@data

# слот "полигоны"
str(Regions1@polygons)

# картограмма Беларуси, на которой каждая область залита своим цветом
# делаем фактор из имён областей (т.е. нумеруем их)
Regions1@data$NAME_1 <- as.factor(Regions1@data$NAME_1)
Regions1@data$NAME_1
### [1] Brest     Homyel'   Hrodna    Mahilyow  Minsk     Vitsyebsk
### Levels: Brest Homyel' Hrodna Mahilyow Minsk Vitsyebsk

# строим картограмму
spplot(Regions1, 'NAME_1',            # отображаемая переменная
       scales = list(draw = T),      # отображение координатной сетки
       col.regions = rainbow(n = 6)  # цвета для заливки
       )

# вариант с палитрой из пакета ColorBrewer и без координатной сетки
spplot(Regions1, "NAME_1",
       col.regions = brewer.pal(6, "Set3"),
       par.settings = list(axis.line = list(col = NA)))





# Пример 3 #####################################################################
# Административная карта Республики Беларусь, регионы раскрашены
#  по значениям непрерывного числового показателя

# загружаем статистику с показателями по регионам
fileURL <- 'https://raw.githubusercontent.com/aksyuk/R-data/master/STATE_STAT/BLR_Regions_2014.csv'
stat.Regions <- read.csv(fileURL, sep = ';', dec = ',', as.is = T)
stat.Regions

# вносим данные в файл карты
Regions1@data <- merge(Regions1@data, stat.Regions, by.x = 'NAME_1', by.y = 'Region')
# задаём палитру
mypalette <- colorRampPalette(c('whitesmoke', 'coral3'))

# строим картограмму численности населения
spplot(Regions1, 'Population.people',
       col.regions = mypalette(20),  # определение цветовой шкалы
       col = 'coral4',               # цвет контурных линий на карте
       par.settings = list(axis.line = list(col = NA))) # без осей

# то же - с названиями областей
spplot(Regions1, 'Population.people', 
       col.regions = mypalette(16), col = 'coral4', 
       main = 'Численность населения, человек',
       panel = function(x, y, z, subscripts, ...) {
         panel.polygonsplot(x, y, z, subscripts, ...)
         sp.text(coordinates(Regions1), Regions1$NAME_1[subscripts])}
)

rm(Regions1)



# Пример 4 #####################################################################
# Перестроить последний график из примера 3 средствами ggplot2

# Формируем данные для ggplot
#  читаем ShapeFile из папки, с указанием уровня
Regions <- readOGR(dsn = './data/BLR_adm_shp',   # папка с файлами .shp,...
                   layer = 'BLR_adm1')           # уровень иерархии
# создаём столбец-ключ id для связи с другими таблицами
#  (названия регионов из столбца NAME_1)
Regions@data$id <- Regions@data$NAME_1
# преобразовать SpatialPolygonsDataFrame в data.frame
gpclibPermit()
Regions.points <- fortify(Regions, region = 'id')
# добавить к координатам сведения о регионах
Regions.df <- join(Regions.points, Regions@data, by = 'id')
# добавляем к координатам значения показателя для заливки
#  (численность населения из фрейма stat.Regions)
stat.Regions$id <- stat.Regions$Region
Regions.df <- join(Regions.df, 
                   stat.Regions[, c('id', 'Population.people')], 
                   by = 'id')
names(Regions.df)

# координаты центров полигонов (для подписей регионов)
centroids.df <- as.data.frame(coordinates(Regions))
centroids.df$id <- Regions@data$id
colnames(centroids.df) <- c('long', 'lat', 'id')

# создаём график
gp <- ggplot() + 
    geom_polygon(data = Regions.df, 
                 aes(long, lat, group = group, fill = Population.people)) +
    geom_path(data = Regions.df, 
              aes(long, lat, group = group),
              color = 'coral4') +
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

  