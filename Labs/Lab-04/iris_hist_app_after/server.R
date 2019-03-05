# ФАЙЛ ./iris_hist_app/server.R ------------------------------------------------
library('shiny')       # загрузка пакетов
library('lattice')

shinyServer(function(input, output) {
    # текст для отображения на главной панели
    output$sp.text <- renderText({
        paste0('Вы выбрали вид ирисов: ', 
               # переменная, связанная со списком видов ирисов
               input$sp.to.plot)
    })
    # строим гистограммы переменных
    output$sp.hist <- renderPlot({
        # сначала фильтруем данные
        DF <- iris[iris$Species == input$sp.to.plot, 1:4]
        # затем строим график
        histogram( ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width, 
                   data = DF,
                   xlab = '',
                   breaks = seq(min(DF), max(DF), 
                                length = input$int.hist + 1))
    })
})
