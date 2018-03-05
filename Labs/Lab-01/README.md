
# Загрузка и предобработка данных 

<span style="color:#000099">**Лабораторная работа №1**</span>

### Загрузка данных   

* Загрузка .csv из сети   
* Разбор XML   
* Разбор HTML   
* Загрузка данных с помощью API (на примере API баз данных UN COMTRADE)   
* Загрузка данных из других форматов    

### Очистка и предобработка данных   
* Объекты `data.frame` и `data.table`   
* Нормализация данных   
* Предобработка заголовков столбцов   
* Создание справочника к данным   

### Публикация результатов   
* Сервис Github   
* Сервис rpubs.com   

### Упражнение 1   
Сбор данных из выдачи поисковика по аналогиии с [Future Timeline](https://xkcd.com/887/) [Рэндела Манро](https://ru.wikipedia.org/wiki/%D0%9C%D0%B0%D0%BD%D1%80%D0%BE,_%D0%A0%D1%8D%D0%BD%D0%B4%D0%B5%D0%BB).     

### Источники   

1. R Core Team (2015). R: A language and environment for statistical computing. R Foundation for Statistical Computing, Vienna, Austria. URL [https://www.R-project.org/](https://www.R-project.org/)    
1. Jeffrey Leek. Материалы курса «Getting and Cleaning Data» Университета Джонса Хопкинса на портале coursera.org, доступные в репозитории на github.com: [https://github.com/jtleek/modules/tree/master/03_GettingData](https://github.com/jtleek/modules/tree/master/03_GettingData)   
1. XPath Syntax. URL: [http://www.w3schools.com/xsl/xpath_syntax.asp](http://www.w3schools.com/xsl/xpath_syntax.asp)   
1. Duncan Temple Lang and the CRAN Team (2015). XML: Tools for Parsing and Generating XML Within R and S-Plus. R package version 3.98-1.3. [https://CRAN.R-project.org/package=XML](https://CRAN.R-project.org/package=XML)   
1. Jeff Gentry (2015). twitteR: R Based Twitter Client. R package version 1.1.9. [https://CRAN.R-project.org/package=twitteR](https://CRAN.R-project.org/package=twitteR)   
1. Pablo Barbera and Michael Piccirilli (2015). Rfacebook: Access to Facebook API via R. R package version 0.6. [https://CRAN.R-project.org/package=Rfacebook](https://CRAN.R-project.org/package=Rfacebook)   
1. Raymond McTaggart, Gergely Daroczi and Clement Leung (2015). Quandl: API Wrapper for Quandl.com. R package version 2.7.0. [https://CRAN.R-project.org/package=Quandl](https://CRAN.R-project.org/package=Quandl)   
1. Jeffrey A. Ryan (2015). quantmod: Quantitative Financial Modelling Framework. R package version 0.4-5. [https://CRAN.R-project.org/package=quantmod](https://CRAN.R-project.org/package=quantmod)   
1. Введение в JSON. URL: [http://www.json.org/json-ru.html](http://www.json.org/json-ru.html)   
1. Alex Couture-Beil (2014). rjson: JSON for R. R package version 0.2.15. [https://CRAN.R-project.org/package=rjson](https://CRAN.R-project.org/package=rjson)   
1. Adrian A. Dragulescu (2014). xlsx: Read, write, format Excel 2007 and Excel 97/2000/XP/2003 files. R package version 0.5.7. [https://CRAN.R-project.org/package=xlsx](https://CRAN.R-project.org/package=xlsx)   
1. Gerrit-Jan Schutten (2014). readODS: Read ODS files and puts them into data frames. R package version 1.4. [https://CRAN.R-project.org/package=readODS](https://CRAN.R-project.org/package=readODS)   
1. R Core Team (2015). foreign: Read Data Stored by Minitab, S, SAS, SPSS, Stata, Systat, Weka, dBase, .... R package version 0.8-66. [https://CRAN.R-project.org/package=foreign](https://CRAN.R-project.org/package=foreign)   
1. Jeroen Ooms, David James, Saikat DebRoy, Hadley Wickham and Jeffrey Horner (2015). RMySQL: Database Interface and 'MySQL' Driver for R. R package version 0.10.7. [https://CRAN.R-project.org/package=RMySQL](https://CRAN.R-project.org/package=RMySQL)   
1. Brian Ripley and Michael Lapsley (2015). RODBC: ODBC Database Access. R package version 1.3-12. [https://CRAN.R-project.org/package=RODBC](https://CRAN.R-project.org/package=RODBC)   
1. Tommy Chheng (2013). RMongo: MongoDB Client for R. R package version 0.0.25. [https://CRAN.R-project.org/package=RMongo](https://CRAN.R-project.org/package=RMongo)   
1. Ben Stabler (2013). shapefiles: Read and Write ESRI Shapefiles. R package version 0.7. [https://CRAN.R-project.org/package=shapefiles](https://CRAN.R-project.org/package=shapefiles)   
1. Roger Bivand, Tim Keitt and Barry Rowlingson (2015). rgdal: Bindings for the Geospatial Data Abstraction Library. R package version 1.1-3. [https://CRAN.R-project.org/package=rgdal](https://CRAN.R-project.org/package=rgdal)   
1. Roger Bivand and Colin Rundel (2015). rgeos: Interface to Geometry Engine - Open Source (GEOS). R package version 0.3-15. [https://CRAN.R-project.org/package=rgeos](https://CRAN.R-project.org/package=rgeos)   
1. Robert J. Hijmans (2015). raster: Geographic Data Analysis and Modeling. R package version 2.5-2. [https://CRAN.R-project.org/package=raster](https://CRAN.R-project.org/package=raster)   
2. Simon Urbanek (2014). jpeg: Read and write JPEG images. R package version 0.1-8. [https://CRAN.R-project.org/package=jpeg](https://CRAN.R-project.org/package=jpeg)   
1. Simon Urbanek (2013). png: Read and write PNG images. R package version 0.1-7. [https://CRAN.R-project.org/package=png](https://CRAN.R-project.org/package=png)   
1. Gregory Jefferis (2014). readbitmap: Simple Unified Interface to Read Bitmap Images (BMP,JPEG,PNG). R package version 0.1-4. [https://CRAN.R-project.org/package=readbitmap](https://CRAN.R-project.org/package=readbitmap)   
1. Uwe Ligges, Sebastian Krey, Olaf Mersmann, and Sarah Schnackenberg (2013). tuneR: Analysis of music. URL: [http://r-forge.r-project.org/projects/tuner/](http://r-forge.r-project.org/projects/tuner/)   
1. Sueur J., Aubin T., Simonis C. (2008). Seewave: a free modular tool for sound analysis and synthesis. Bioacoustics, 18: 213-226. URL: [https://CRAN.R-project.org/package=seewave](https://CRAN.R-project.org/package=seewave)   
1. M Dowle, A Srinivasan, T Short, S Lianoglou with contributions from R Saporta and E Antonyan (2015). data.table: Extension of Data.frame. R package version 1.9.6 [https://CRAN.R-project.org/package=data.table](https://CRAN.R-project.org/package=data.table)   
1. Hadley Wickham and Romain Francois (2015). dplyr: A Grammar of Data Manipulation. R package version 0.4.3. [https://CRAN.R-project.org/package=dplyr](https://CRAN.R-project.org/package=dplyr)   
1. M Dowle, A Srinivasan, T Short, S Lianoglou with contributions from R Saporta, E Antonyan. Package 'data.table' Reference Manual, September 19, 2015. URL: [https://cran.r-project.org/web/packages/data.table/data.table.pdf](https://cran.r-project.org/web/packages/data.table/data.table.pdf)   
1. Markdown / Википедия – свободная энциклопедия. URL: [https://ru.wikipedia.org/wiki/Markdown](https://ru.wikipedia.org/wiki/Markdown)   
1. Markdown синтаксис по-русски / Сайт http://rukeba.com/. URL: [http://rukeba.com/by-the-way/markdown-sintaksis-po-russki/](http://rukeba.com/by-the-way/markdown-sintaksis-po-russki/)   
1. Сайт проекта Markdown. URL: [http://daringfireball.net/projects/markdown/](http://daringfireball.net/projects/markdown/)   
1. Руководство по стилю программирования на R от Google. URL: [https://sites.google.com/a/kiber-guu.ru/r-practice/links/R_style_from_Google.pdf?attredirects=0&d=1](https://sites.google.com/a/kiber-guu.ru/r-practice/links/R_style_from_Google.pdf?attredirects=0&d=1)   
