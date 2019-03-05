library('shiny')              # загрузка пакетов
library('dplyr')
library('data.table')
library('zoo')
library('lubridate')
library('ggplot2')

# загружаем файл с данными по импорту масла в РФ (из прошлой практики)
fileURL <- 'https://raw.githubusercontent.com/aksyuk/R-data/master/COMTRADE/040510-Imp-RF-comtrade.csv'
# создаём директорию для данных, если она не существует:
if (!file.exists('./data')) dir.create('./data')
# загружаем файл, если он не существует
if (!file.exists('./data/040510-Imp-RF-comtrade.csv')) {
    download.file(fileURL, './data/040510-Imp-RF-comtrade.csv')}
# читаем данные из загруженного .csv во фрейм
DT.import <- data.table(read.csv('./data/040510-Imp-RF-comtrade.csv', as.is = T))
# переводим период в дату: начало соответствующего месяца
#  нелогично, но ceiling_date, с помощью которого дата округлялась 
#  до следующего месяца ранее, выдаёт ошибку: не распознаёт timezone
DT.import[, Period.Date := 
              as.POSIXct(as.yearmon(as.character(Period), 
                                    '%Y%m'))]

# убираем столбец с периодом в виде текста, оставляем только дату
DT.import <- select(DT.import, Period.Date, Reporter, Trade.Value.USD)

# серверная часть приложения shiny
shinyServer(function(input, output) {
    # список стран для выбора
    output$stateList <- renderUI({
        state.list <- sort(unique(DT.import$Reporter))
        radioButtons('state',   # связанная переменная
                     'Выберите торгового партнёра:', state.list, 
                     selected = state.list[1])
    })
    # реагирующая таблица данных
    DT <- reactive({
        # фильтруем по годам
        DT <- filter(DT.import, between(year(Period.Date), 
                                        input$year.range[1],
                                        input$year.range[2]))
        # агрегируем
        if (input$period.name == 'Месяц') {
            DT <- 
                
        } else {
            DT <- 
                
        }
        DT <- 
            
        DT <- data.table(DT)
        # добавляем ключевой столбец: период времени
        setkey(DT, 'period')
        # оставляем только уникальные периоды времени
        DT <- data.table(unique(DT))
    })
    
    # текст: выбрана страна
    output$text <- renderText({input$state}) 
        
    # график динамики
    output$ts.plot <- renderPlot({
        gp <- 
        if (input$period.name == 'Месяц') {
            gp + geom_histogram(stat = 'identity') + 
                scale_x_yearmon(format = "%b %Y")
        } else {
            gp + geom_histogram(stat = 'identity') + 
                scale_x_yearqtr(format = "%YQ%q")
        }
    })
    
    # таблица данных в отчёте
    output$table <- renderDataTable({
        DT()
    }, options = list(lengthMenu = c(5, 10, 20), pageLength = 5))
    
    # событие "нажатие на кнопку 'сохранить'"
    observeEvent(input$save.csv, {
        if (input$period.name == 'Месяц') {
            by.string <- '_by_mon_'
        } else {
            by.string <- '_by_qrt_'
        }
        file.name <- paste('import_', input$year.range[1], '-',
                           input$year.range[2], by.string, 'from_',
                           input$state, '.csv', 
                           sep = '')
        # файл будет записан в директорию приложения
        write.csv(DT(), file = file.name, 
                  fileEncoding = 'UTF-8', row.names = F)
    })
})