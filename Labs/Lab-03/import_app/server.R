# загрузка пакетов
library('shiny')
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
# переводим период в дату: КОНЕЦ соответствующего месяца
DT.import[, Period.Date := ceiling_date(as.POSIXct(as.yearmon(as.character(Period), 
                                                              '%Y%m')),
                                        unit = 'month') - days(1)]
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
        # агрегируем
        if (input$period.name == 'Месяц') {
            DT <- filter(DT.import, Reporter == input$state) %>% 
                mutate(period = as.yearmon(Period.Date))
        } else {
            DT <- filter(DT.import, Reporter == input$state) %>%
                mutate(period = as.yearqtr(Period.Date))
        }
        DT <- DT %>% group_by(period) %>% 
            mutate(Trade.Value.USD = sum(Trade.Value.USD))
        DT <- data.table(DT)
        # оставляем только уникальные периоды времени
        setkey(DT, 'period')
        unique(DT)
    })

    output$text <- renderText({input$state}) 
    
    # график временного ряда
    output$ts.plot <- renderPlot({
        gp <- ggplot(DT(), aes(x = as.POSIXct(period), y = Trade.Value.USD))
        gp + geom_line() + geom_point()
    })
    
    # таблица данных в отчёте
    output$table <- renderDataTable({
        DT()
    }, options = list(lengthMenu = c(5, 10, 20), pageLength = 5))
    
    # событие "нажатие на кнопку 'сохранить'"
    observeEvent(input$save.csv, {
        if (input$period.name == 'Месяц') {
            file.name <- paste('import_from_', input$state, '_by_month.csv', 
                               sep = '')
        } else {
            file.name <- paste('import_from_', input$state, '_by_qrt.csv', 
                               sep = '')
        }
        # файл будет записан в директорию приложения
        write.csv(DT(), file = file.name, 
                  fileEncoding = 'UTF-8', row.names = F)
    })
})