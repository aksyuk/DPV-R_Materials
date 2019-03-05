# ФАЙЛ ./air_plot_app/server.R -------------------------------------------------
library('shiny')        # загрузка пакетов
library('ggplot2')
library('data.table')

shinyServer(function(input, output) {
    # реагирующий фрейм с данными
    DT <- 
      
    # график разброса с линией регрессии
    output$gplot <- 
      
    # таблица с описательными статистиками
    output$XY.summary <- 
      
    # отчёт по модели регрессии
    output$lm.result <- 
        
})
