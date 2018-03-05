# ФАЙЛ ./iris_hist_app/server.R ------------------------------------------------
# загрузка пакетов
library('shiny')
library('lattice')

# Функция shinyServer() определяет описывает действия и события, 
#  которые происходят при обновлении интерфейса
shinyServer(function(input, output) {
    output$sp.text <- renderText({
        paste('Вы выбрали вид ирисов: "',
              # переменная, связанная со списком видов ирисов
              input$spesies.to.plot,
              '"', sep = '')
    })
    output$sp.hist <- renderPlot({
        # сначала фильтруем данные
        DF <- iris[iris$Species == input$spesies.to.plot, 1:4]
        # затем строим гистограммы переменных
        histogram( ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width, 
                   data = DF,
                   xlab = '',
                   breaks = seq(min(DF), max(DF), 
                                length = input$int.hist + 1))
    })
})
