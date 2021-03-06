# ФАЙЛ ./iris_hist_app/ui.R ----------------------------------------------------
library('shiny')       # загрузка пакетов

# список уникальных значений столбца Species для фильтрации данных
sp.filter <- as.character(unique(iris$Species))
names(sp.filter) <- sp.filter
sp.filter <- as.list(sp.filter)

# размещение всех объектов на странице
shinyUI(
    # создать страницу с боковой панелью
    # и главной областью для отчётов
    pageWithSidebar(
        # название приложения:
        headerPanel('Распределение характеристик цветков'),
        # боковая панель:
        sidebarPanel(
            selectInput(               # выпадающее меню: вид ирисов
                'sp.to.plot',          # связанная переменная
                        'Выберите вид ириса',  # подпись списка
                        sp.filter),            # сам список
            sliderInput(               # слайдер: кол-во интервалов гистограммы
                'int.hist',                       # связанная переменная
                        'Количество интервалов гистограммы:', # подпись
                        min = 2, max = 10,                    # мин и макс
                        value = floor(1 + log(50, base = 2)), # базовое значение
                        step = 1)                             # шаг
        ),
        # главная область
        mainPanel(
            # текстовый объект для отображения
            
            # гистограммы переменных
            
            )
        )
    )
