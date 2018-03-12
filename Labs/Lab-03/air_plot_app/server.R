# ФАЙЛ ./air_plot_app/server.R -------------------------------------------------
library('shiny')        # загрузка пакетов
library('ggplot2')
library('data.table')
library('dplyr')

shinyServer(function(input, output) {
    # реагирующий фрейм с данными
    DT <- reactive({
        DT <- data.table(airquality)
        select(DT[between(Month, input$month.range[1], 
                   input$month.range[2]), ],
               input$Y.var, input$X.var)
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
    output$lm.result <- renderPrint({
        eq <- as.formula(paste(input$Y.var, ' ~ ', input$X.var))
        mod <- lm(eq, data = DT())
        summary(mod)
    })
})
