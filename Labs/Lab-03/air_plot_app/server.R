# ФАЙЛ ./air_plot_app/server.R -------------------------------------------------
# загрузка пакетов
library('shiny')
library('ggplot2')
library('data.table')

shinyServer(function(input, output) {
    # реагирующий фрейм с данными
    DT <- reactive({
        DT <- data.table(airquality)
        DT[between(Month, input$month.range[1], 
                   input$month.range[2]), 
           c(input$Y.var, input$X.var), with = F]
    })
    # график разброса с линией регрессии
    output$gplot <- renderPlot({
        gp <- ggplot(data = DT(), aes_string(x = input$X.var,
                                             y = input$Y.var))
        gp <- gp + geom_point() + geom_smooth(method = 'lm')
        gp
    })
    # таблица с описательными статистиками
    output$XY.summary <- renderPrint({
        summary(DT())
    })
    # отчёт по модели регрессии
    output$summary <- renderPrint({
        eq <- as.formula(paste(input$Y.var, ' ~ ', input$X.var))
        mod <- lm(eq, data = DT())
        summary(mod)
    })
})
