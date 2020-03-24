# Аналитический пакет R: Занятие 4 ---------------------------------------------

# Создание статических картограмм ==============================================

# загрузка пакетов
# library('R.utils')               # gunzip() для распаковки архивов 
library('sp')                    # функция spplot()
library('ggplot2')               # функция ggplot()
library('RColorBrewer')          # цветовые палитры
require('rgdal')                 # функция readOGR()
library('broom')                 # функция tidy()
require('dplyr')                 # функция join()
library('scales')                # функция pretty_breaks()
library('mapproj')               # проекции для карт
## установка и сборка пакета «gpclib»
## установить RTools (recommended) отсюда:
## http://cran.r-project.org/bin/windows/Rtools/
# install.packages('gpclib', type = 'source')
library('gpclib')
library('maptools')
# разрешить использовать полигональную геометрию, которая защищена лицензией 
gpclibPermit()



# Пример с картой РФ -----------------------------------------------------------

# Адрес сайта с картами границ стран мира:
# https://gadm.org/download_country_v3.html

# загружаем файл с границами РФ
fileURL <- 'https://biogeo.ucdavis.edu/data/gadm3.6/shp/gadm36_RUS_shp.zip'
if (!dir.exists('./data')) {
    dir.create('data2')
}
if (!file.exists('./data/gadm36_RUS_shp.zip')) {
    download.file(fileURL, destfile = './data/gadm36_RUS_shp.zip')
}
# загружаем файл со статистикой
fileURL <- 'https://raw.githubusercontent.com/aksyuk/R-data/master/STATE_STAT/RUS_CFO_pop_2020.csv'
if (!file.exists('./data/RUS_CFO_pop_2020.csv')) {
    download.file(fileURL, destfile = './data/RUS_CFO_pop_2020.csv')
}

# распаковка данных (архив в ./data)
unzip('./data/gadm36_RUS_shp.zip', exdir = './data/RUS_adm_shp')

# прочитать данные уровней 0, 1
Regions0 <- readOGR("./data/RUS_adm_shp/gadm36_RUS_0.shp", stringsAsFactors = F)
Regions1 <- readOGR("./data/RUS_adm_shp/gadm36_RUS_1.shp", stringsAsFactors = F)


# контурные карты для разных уровней иерархии ==================================
par(mfrow = c(1, 2))
par(oma = c(0, 0, 0, 0))
par(mar = c(0, 0, 1, 0))
plot(Regions0, main = 'adm0', asp = 1.8)
plot(Regions1, main = 'adm1', asp = 1.8)
par(mfrow = c(1, 1))


# карта-хороплет для численности населения в регионах ЦФО ======================

# заготовка для присоединения данных ###########################################
#  посмотрим на имена слотов объекта-карты
slotNames(Regions1)

# слот data
head(Regions1@data)
# head(Regions1@polygons)
colnames(Regions1@data)

# преобразуем кодировку
Encoding(Regions1@data$NL_NAME_1) <- 'UTF-8'
Regions1@data$NL_NAME_1[1:10]

# делаем фрейм с координатами для ggplot
Regions.points <- fortify(Regions1, region = 'NAME_1')

# оставляем только регионы ЦФО
reg.names.ЦФО <- c('Belgorod', 'Bryansk', 'Vladimir', 'Voronezh', 'Ivanovo', 
                   'Kaluga', 'Kostroma', 'Kursk', 'Lipetsk', 'Moskva', 
                   'Moscow City', 'Orel', "Ryazan'", 'Smolensk', 'Tambov', 
                   "Tver'", 'Tula', "Yaroslavl'")
Regions.points <- Regions.points[Regions.points$id %in% reg.names.ЦФО, ]
unique(Regions1@data$NAME_1)

# присоединяем показатель численности населения ################################
df.pop <- read.csv2('./data/RUS_CFO_pop_2020.csv', stringsAsFactors = F)
Regions.points <- merge(Regions.points, df.pop, by = 'id')
Regions.points <- Regions.points[order(Regions.points$order), ]

# график ggplot2 ###############################################################
gp <- ggplot() + 
    geom_polygon(data = Regions.points, 
                 aes(long, lat, group = group, fill = pop.2020)) +
    geom_path(data = Regions.points, 
              aes(long, lat, group = group),
              color = 'coral4') +
    coord_map(projection = 'gilbert') +
    scale_fill_distiller(palette = 'OrRd',
                         direction = 1,
                         breaks = pretty_breaks(n = 5)) +
    labs(x = 'Долгота', y = 'Широта', 
         title = "Численность населения, оценка на 1.01.2020")
# выводим график
gp

# график spplot ################################################################

# работаем с Regions1, добавляем статистику
Regions1@data <- merge(Regions1@data, df.pop, 
                       by.x = 'NAME_1', by.y = 'id', all.x = T)

# задаём границы карты
scale.parameter <- 0.1  # шкалирование: меньше 1 -- ближе, больше 1 -- дальше
xshift <- -0.1  # сдвиг вправо в е.и. карты 
yshift <- 0.1  # сдвиг вверх в е.и. карты 
original.bbox <- Regions1@bbox  # сохраняем исходные рамки

# создаём новые рамки
edges <- original.bbox
edges[1, ] <- (edges[1, ] - mean(edges[1, ])) * 
    scale.parameter + mean(edges[1, ]) + xshift
edges[2, ] <- (edges[2, ] - mean(edges[2, ])) * scale.parameter + 
    mean(edges[2, ]) + yshift

# задаём палитру
mypalette <- colorRampPalette(c('whitesmoke', 'coral3'))

spplot(Regions1, 'pop.2020',
       col.regions = mypalette(20),  # определение цветовой шкалы
       col = 'coral4',               # цвет контурных линий на карте
       par.settings = list(axis.line = list(col = NA)), # без осей
       xlim = edges[1, ], ylim = edges[2, ])
