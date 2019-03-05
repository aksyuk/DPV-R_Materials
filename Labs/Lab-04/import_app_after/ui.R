library('shiny')              # загрузка пакетов

shinyUI(
    pageWithSidebar(
        
        # название приложения:
        headerPanel('Статистика импорта'),
        
        # боковая панель
        sidebarPanel(
            # радиокнопки: период агрегирования данных
            radioButtons('period.name', 
                         'Выберите период агрегирования', 
                         c('Месяц', 'Квартал'), 
                         selected = 'Месяц'),
            # слайдер: фильтр по годам
            sliderInput('year.range', 'Годы:',
                        min = 2010, max = 2017, value = c(2010, 2017),
                        width = "100%", sep = ''),
            # выпадающее меню: страна для отбора наблюдений
            uiOutput('stateList')
        ),
        
        # главная область
        mainPanel(
            # текст с названием выбранной страны
            textOutput('text'),
            # график ряда
            plotOutput('ts.plot'),
            # таблица данных
            dataTableOutput('table'),
            # кнопка сохранения данных
            actionButton('save.csv', 'Сохранить данные в .csv')
        )
    )
)