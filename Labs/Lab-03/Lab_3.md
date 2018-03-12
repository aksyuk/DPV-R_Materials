<style>

.footer-left {  
    position: fixed;  
    top: 95%;  
    left: 0%;  
    text-align: left;  
    width:85%;  
}  
  
.footer-right {  
    position: fixed;  
    top: 95%;  
    right: 0%;  
    text-align: right;  
    width:15%;  
}  
  
.col2 {  
    columns: 2 200px;           /* number of columns and width in pixels*/
    -webkit-columns: 2 200px;   /* chrome, safari */
    -moz-columns: 2 200px;      /* firefox */
}  
  
</style>

ДПВ "Аналитический пакет R"
========================================================
autosize: true
font-family: 'Verdana'

## Практика 3:  
## <center>Приложения в пакете 'shiny'</center>



<!-- Нижний колонтитул -->
<div class = "footer-left" style = "font-size: 70%; color: white; width:50%;">ГУУ, ИИС, кафедра ММЭУ</div>
<div class = "footer-right" style = "font-size: 70%; color: white; width:50%;">весенний семестр 2017/2018</div>

Приложения в shiny  
========================================================

- Скрипт на R -> интерактивная html-страница  
- Знание html необязательно  
- Можно размещать онлайн на ресурсах Gist, shinyapps.io, публиковать как пакеты для R или просто отсылать архивом   
- Примеры приложений: [https://shiny.rstudio.com/](https://shiny.rstudio.com/)   
- Ещё примеры: [https://shiny.rstudio.com/gallery/](https://shiny.rstudio.com/gallery/)   

<!-- Нижний колонтитул -->

<div class = "footer-left" style = "font-size: 70%;"><em>ДПВ "Аналитический пакет R": Приложения в пакете shiny</em></div>
<div class = "footer-right" style = "font-size: 70%;">2</div>

Приложения в shiny  
========================================================

- Архитектура: два файла: `ui.R` и `server.R` (хотя можно в одном)  
- Файл `ui.R` содержит описание элементов интерфейса  
- Файл `server.R` -- всё, что происходит при взаимодействия пользователя с интерфейсом   
- Связующие объекты-списки: input и output  
- **Выравнивание и форматирование текста скриптов очень важно!**  

<!-- Нижний колонтитул -->

<div class = "footer-left" style = "font-size: 70%;"><em>ДПВ "Аналитический пакет R": Приложения в пакете shiny</em></div>
<div class = "footer-right" style = "font-size: 70%;">3</div>

План практики 
========================================================

- Приложение с гистограммами на данных iris    
- Приложение с графиками разброса и модели на данных airquality  
- Агрегирование данных средствами data.table и dplyr  
- Приложение для интерактивной фильтрации и агрегирования данных по импорту масла в РФ  

<!-- Нижний колонтитул -->

<div class = "footer-left" style = "font-size: 70%;"><em>ДПВ "Аналитический пакет R": Приложения в пакете shiny</em></div>
<div class = "footer-right" style = "font-size: 70%;">4</div>
