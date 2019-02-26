# ФАЙЛ ./iris_hist_app/server.R ------------------------------------------------
library('shiny')       # загрузка пакетов
library('lattice')

shinyServer(function(input, output) {
    output$sp.text <- renderText({
        paste0('Вы выбрали вид ирисов: ', input$sp.to.plot)
    })
    output$sp.hist <- renderPlot({
        # сначала фильтруем данные
        DF <- iris[iris$Species == input$sp.to.plot, 1:4]
        # затем строим гистограммы переменных
        histogram( ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width, 
                   data = DF,
                   xlab = '',
                   breaks = seq(min(DF), max(DF), 
                                length = input$int.hist + 1))
    })
})
