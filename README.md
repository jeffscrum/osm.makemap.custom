# osm.makemap.custom

## Для начала работы
Для работы скриптов требуется установить или скачать необходимые программы и разложить вместе со всем содержимым по каталогам:
	
| Component         | Download or Install                                     | Comments |
|-------------------|---------------------------------------------------------|----------|
| mkgmap            | https://www.mkgmap.org.uk/download/mkgmap.html          | Copy to OSM/tools/mkgmap |
| splitter          | https://www.mkgmap.org.uk/download/splitter.html        | Copy to OSM/tools/splitter |
| osmconvert        | https://wiki.openstreetmap.org/wiki/Osmconvert#Linux    | Copy to OSM/tools/osmconvert |
| gpsbabel          | sudo apt-get install gpsbabel                           | - |
| srtm2osm          | https://wiki.openstreetmap.org/wiki/Srtm2Osm#Download   | Copy to OSM/tools/srtm2osm |
| cities5000.zip    | http://download.geonames.org/export/dump/cities5000.zip | Unpack to OSM |
| bounds-latest.zip | http://osm.thkukuk.de/data/bounds-latest.zip            | Unpack to OSM/bounds |
| sea-latest.zip    | http://osm.thkukuk.de/data/sea-latest.zip               | Unpack to OSM/sea |


## Для начала работы
1) С сервера [https://download.geofabrik.de](https://download.geofabrik.de) скачиваем всю область кусок из которой нам нужен  
2) На сервере [OSM](https://www.openstreetmap.org/export) находим нужный нам регион и через "Слои" включаем "Map Data" (возможно придется сильно приблизить область). После находим Relation ID области.  
3) На сервере [http://polygons.openstreetmap.fr](http://polygons.openstreetmap.fr) по Relation ID скачиваем poly-файл. Иногда стоит скачивать файл с небольшим количеством NPoints.  
4) Кладем poly-файл в каталог poly/
5) Создаем ссылку на файл области (1) `ln -s ukraine-latest.osm.pbf source.osm.pbf`  
6) Запускем скрипт который вырезает нужную область из большой области `./bin/cut_poly_from_source.sh crimea`(имя должно совпадать с именем файла в poly/)  
7) Запускаем скрипт резки на тейлы карты `./bin/split.sh crimea` (имя должно совпадать с именем в pbf/)  
8) Запускаем скрипт создания img-файла нужного стиля `./bin/create_img_maptourist.sh crimea` или `create_img_velo100.sh crimea`(имя должно совпадать с появившемся каталогом split.crimea)


--- Опционально ---  
9) Если требуется SRTM, то через [OSM Export](https://www.openstreetmap.org/export) выделяем нужную область, смотрим координаты прямоугольника и запускаем скрипт `./bin/contours_srtm2contours.sh -t <top> -l <left> -b <bottom> -r <right> -s <step>`   
10) Запускаем сортировку содержимого osm/contours.osm `./bin/contours_osm2pbf.sh crimea`(имя карты которую мы готовим)  
11) Запускаем скрипт резки на тейлы карты `./bin/split.sh crimea_contours` (имя должно совпадать с именем в pbf/)    
12) Для получения отдельного слоя img запускаем `create_img_contoures.sh crimea_contours`


--- Опционально ---  
12) Для получения gmapi файла для Basecamp со слоем изолиний запускаем `create_gmapi_w_contours.sh crimea`(имя должно совпадать с появившемся каталогом split.) 




## Как должно выглядеть дерево
```
OSM
 ├── bin
 |    ├── contours_osm2pbf.sh
 |    ├── contours_srtm2contours.sh
 |    ├── create_gmapi_w_contours.sh
 |    ├── create_img_contoures.sh
 |    ├── create_img_maptourist.sh
 |    ├── create_img_velo100.sh
 |    ├── cut_poly_from_source.sh
 |    └── split.sh
 ├── bounds/...many_files...
 ├── cities5000.txt
 ├── osm/
 ├── pbf/
 ├── poly/
 ├── sea/...many_files...
 ├── source.osm.pbf -> ukraine-latest.osm.pbf
 ├── styles
 │   ├── contours/
 |   ├── contours.txt
 │   ├── maptourist/
 |   ├── maptourist.txt
 │   ├── velo100/
 |   └── velo100.typ
 ├── tiles/
 ├── tmp/
 └── tools
     ├── mkgmap/mkgmap.jar
     ├── osmconvert/osmconvert64
     ├── osmosis/bin/osmosis
     ├── splitter/splitter.jar
     └── srtm2osm/Srtm2Osm.exe
```
---
*Стили взяты у [MaksVasilev](https://github.com/MaksVasilev/stranger-garmin) и [MapTourist](https://maptourist.org/)*
