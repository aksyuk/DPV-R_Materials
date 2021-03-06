# ФАЙЛ ./iris_hist_app/server.R ------------------------------------------------
library('shiny')       # загрузка пакетов
library('lattice')

shinyServer(function(input, output) {
    # текст для отображения на главной панели
    output$sp.text <- renderText({
        paste0('Вы выбрали вид ирисов: ', 
               # переменная, связанная со списком видов ирисов
               )
    })
    # строим гистограммы переменных
    output$sp.hist <- renderPlot({
        # сначала фильтруем данные
        DF <- 
        # затем строим график
        histogram( , 
                   data = DF,
                   xlab = '',
                   breaks = seq(min(DF), max(DF), 
                                length = input$int.hist + 1))
    })
})
