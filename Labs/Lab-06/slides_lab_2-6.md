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

## Практика 6:  
## <center>Интерактивные карты в R: 'googleVis' и 'leaflet'</center>



<!-- Нижний колонтитул -->
<div class = "footer-left" style = "font-size: 70%; color: white; width:50%;">ГУУ, ИИС, кафедра ММЭУ</div>
<div class = "footer-right" style = "font-size: 70%; color: white; width:50%;">весенний семестр 2018/2019</div>


Интерактивные карты в R     
========================================================

- Карта-хороплет и таблица с возможностью сортировки по статистике из базы данных Всемирного банка: пакет `googleVis`    

- Карта уровня улиц с маркерами, обозначающими расположение аптек в посёлке Уренгой (данные с Портала открытых данных РФ): `leaflet`     
- Ещё один пример карты с использованием `leaflet`: карта центров образования ТБО в Ямало-Ненецком автономном округе с радиусами, пропорциональными численности населения (данные с Портала открытых данных РФ)   

<!-- Нижний колонтитул -->

<div class = "footer-left" style = "font-size: 70%;"><em>ДПВ "Аналитический пакет R": Приложения в пакете shiny</em></div>
<div class = "footer-right" style = "font-size: 70%;">2</div>


Интерактивные карты в R     
========================================================

- генерируем html-страницу из скрипта на Rmarkdown, просматриваем в браузере    

- за отрисовку карт отвечают сторонние библиотеки, пакеты `googleVis` и `leaflet` -- только их драйвера     

- функции пакетов `googleVis` и `leaflet` генерируют html-код; чтобы он работал, в блоках кода на R нужна опция `results = 'asis'`    

- чтобы отчёт был автономным (веб-страница без внешних файлов), нужно прописать в YAML-заголовке опцию `self_contained: yes`     

- необходима последняя версия pandoc   

<!-- Нижний колонтитул -->

<div class = "footer-left" style = "font-size: 70%;"><em>ДПВ "Аналитический пакет R": Приложения в пакете shiny</em></div>
<div class = "footer-right" style = "font-size: 70%;">3</div>


Интерактивные карты в R      
========================================================

- **Leaflet** -- JavaScript библиотека для создания интерактивных карт с открытым исходным кодом. Сайт: <https://leafletjs.com/>     

- **Google Charts API** -- позволяет генерировать интерактивные графики самых разных видов; доступ предоставляется бесплатно. Галерея: <https://developers.google.com/chart/interactive/docs/gallery?hl=ru>     

<!-- Нижний колонтитул -->

<div class = "footer-left" style = "font-size: 70%;"><em>ДПВ "Аналитический пакет R": Приложения в пакете shiny</em></div>
<div class = "footer-right" style = "font-size: 70%;">4</div>


Подготовка данных для карт    
========================================================

- загрузка из базы Всемирного банка -- пакет `WDI`    

- загрузка с Портала открытых данных РФ через API, необходима регистрация     

- поиск координат объекта по адресу с помощью API Геокодера от Яндекс, необходима регистрация    

*Данные для построения карт примеров уже загружены и сохранены на github.com*.

<!-- Нижний колонтитул -->

<div class = "footer-left" style = "font-size: 70%;"><em>ДПВ "Аналитический пакет R": Приложения в пакете shiny</em></div>
<div class = "footer-right" style = "font-size: 70%;">5</div>
