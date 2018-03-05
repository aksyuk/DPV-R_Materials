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

Аксюк Светлана Андреевна  
Рубежный контроль: зачёт  



<!-- Нижний колонтитул -->
<div class = "footer-left" style = "font-size: 70%; color: white; width:50%;">ГУУ, ИИС, кафедра ММЭУ</div>
<div class = "footer-right" style = "font-size: 70%; color: white; width:50%;">весенний семестр 2017/2018</div>

Темы практик
========================================================

- Загрузка данных из различных источников  
- Графические системы R  
- Создание приложений в пакете shiny   
- Работа с картами  

<!-- Нижний колонтитул -->

<div class = "footer-left" style = "font-size: 70%;"><em>ДПВ "Аналитический пакет R": Графические системы в R</em></div>
<div class = "footer-right" style = "font-size: 70%;">2</div>

Практика №1: загрузка данных
========================================================

- .csv  
- xml  
- html   
- API на примере базы UN COMTRADE   

<!-- Нижний колонтитул -->

<div class = "footer-left" style = "font-size: 70%;"><em>ДПВ "Аналитический пакет R": Графические системы в R</em></div>
<div class = "footer-right" style = "font-size: 70%;">3</div>

Принципы работы с данными
========================================================

1. Не задавайте явно рабочую директорию  
1. Сохраняйте данные в отдельную директорию внутри рабочей  
1. Сохраняйте время и дату загрузки  
1. Снабжайте данные описанием (справочником)  

Цель: обеспечить воспроизводимость кода  

<!-- Нижний колонтитул -->

<div class = "footer-left" style = "font-size: 70%;"><em>ДПВ "Аналитический пакет R": Графические системы в R</em></div>
<div class = "footer-right" style = "font-size: 70%;">4</div>

С чем будем работать сегодня 
========================================================

1. Пакеты R:  
 - `XML`  
 - `RCurl`  
 - `jsonlite`  

1. github.com (для размещения результатов упражнения №1)   

<!-- Нижний колонтитул -->

<div class = "footer-left" style = "font-size: 70%;"><em>ДПВ "Аналитический пакет R": Графические системы в R</em></div>
<div class = "footer-right" style = "font-size: 70%;">5</div>
