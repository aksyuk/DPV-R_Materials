# загрузка пакетов
library('shiny')

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
            # выпадающее меню: страна для отбора наблюдений
            uiOutput('stateList')
        ),
        
        # главная область
        mainPanel(
            # график ряда
            plotOutput('ts.plot'),
            # таблица данных
            dataTableOutput('table'),
            # кнопка сохранения данных
            actionButton('save.csv', 'Сохранить данные в .csv')
        )
    )
)