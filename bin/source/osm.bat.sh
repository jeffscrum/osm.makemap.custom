Создание карты Garmin из данных OSM с помощью Mkgmap
Создание карты Garmin из данных OSM с помощью Mkgmap происходит в 5 этапов:
1.	Загрузка данных OSM и сопутствующих файлов.
2.	Вырезание из данных OSM необходимой области.
3.	Создание файлов границ.
4.	Разрезание данных OSM необходимой области на части.
5.	Непосредственно создание карты.
Некоторые этапы (2, 3, 4) могут быть пропущены или заменены специальными файлами.
Я буду описывать как я создаю карты под системой Windows 7, 10 64-разрядной. Разница с 32-разрядной заключается в количестве выделяемой памяти и соответственно разрядности приложения JAVA.


Загрузка данных OSM и сопутствующих файлов.
Загрузку я осуществляю с помощью программы wget запуская 1_run_download.bat файл.
Ссылку на весь комплект программ я приведу ниже или можете самостоятельно поискать в интернете.
@echo off
set BASEDIR=%CD%
:: =============================================================
echo .
echo .   OSM data download files
echo .
cd %BASEDIR%\input
rem Скачиваем файл данных OSM с http://download.geofabrik.de/index.html
 "%BASEDIR%\wget\bin\wget.exe" "http://download.geofabrik.de/russia-latest.osm.pbf" –N

rem Скачиваем файл данных OSM с http://gis-lab.info/projects/osm_dump/
 "%BASEDIR%\wget\bin\wget.exe" "http://data.gis-lab.info/osm_dump/dump/latest/local.osm.pbf" –N

rem Скачиваем файлы данных границ и береговых линий
 "%BASEDIR%\wget\bin\wget.exe" "http://osm2.pleiades.uni-wuppertal.de/bounds/latest/bounds.zip" -N
 "%BASEDIR%\wget\bin\wget.exe" "http://osm2.pleiades.uni-wuppertal.de/sea/latest/sea.zip" –N
 
rem Скачиваем файлы данных географических имен (нужен какой-нибудь один, а можно и никакой)
 "%BASEDIR%\wget\bin\wget.exe" "http://download.geonames.org/export/dump/cities1000.zip" -N
 "%BASEDIR%\wget\bin\wget.exe" "http://download.geonames.org/export/dump/cities5000.zip" -N
 "%BASEDIR%\wget\bin\wget.exe" "http://download.geonames.org/export/dump/cities15000.zip" -N
 "%BASEDIR%\wget\bin\wget.exe" "http://download.geonames.org/export/dump/RU.zip" –N

Вы можете закоментировать строки с ненужными файлами или добавить по данному шаблону свои регионы. Я скачиваю всю Россию, а потом вырезаю из нее то что мне надо (два федеральных округа или набор областей). Вы вольны выбирать то что Вам надо зайдя на сайты gis-lab.info или download.geofabrik.de и затем изменив названия файлов в 1_run_download.bat скачивать только то что надо


Вырезание из данных OSM необходимой области.
С помощью программы osmosis запуская файл 2_run_cut_poly.bat вырезаем нужную нам область (территорию).
@echo off
set BASEDIR=%CD%
:: =============================================================
cls
echo .
echo .
echo Введите номер - соответствующей выбранной территории
echo 1 - Северо-Западный Федеральный округ и Тверская область
echo 2 - Северо-Западный и Центральный Федеральные округа
echo 3 - области: Ленинградская, Псковская, Новгородская, Тверская и Карелия
echo 4 - 8 областей - 5 областей + Вологодская, Ярославская и Московская
echo 5 - 11 областей - 8 областей + Костромская, Ивановская и Владимирская
echo 0 - Exit -
echo .
set /p pset="Enter № My-Poly - "
echo My-Poly is - %pset%
if %pset%==1 set MYPOLY=szfo_tve.poly
if %pset%==2 set MYPOLY=szfo_cfo.poly
if %pset%==3 set MYPOLY=5-obl-buf20.poly
if %pset%==4 set MYPOLY=8-obl-buf20.poly
if %pset%==5 set MYPOLY=11-obl-buf20.poly
if %pset%==0 goto EOS
:: =============================================================
rem Вырезаем из файла OSM данных нужную площадь
echo .
echo .   cut out the desired data file OSM area
echo .
 call %BASEDIR%\osmosis\bin\osmosis ^
   --read-pbf file=%BASEDIR%\input\local.osm.pbf ^
   --bounding-polygon file=%BASEDIR%\poly\%MYPOLY% completeWays=yes ^
   --write-pbf file=%BASEDIR%\input\MAP.osm.pbf

Обратите внимание на строку    --read-pbf file=%BASEDIR%\input\local.osm.pbf ^
Здесь вместо local.osm.pbf надо указать то имя файла которое Вам надо. 
Например russia-latest.osm.pbf
Poly файлы можно скачать с http://be.gis-lab.info/data/osm_dump/poly/ или сделать самостоятельно.
Чтобы создать самостоятельно, надо в навигаторе или программах BaseCamp или MapSource создать маршрут по границе территории которая Вам нужна и сохранить в формате GPX. Затем зайти на сайт по ссылке http://www.geocaching-dresden.de/tools/gpx-to-poly/index.php и преобразовать маршрут в poly файл. Маршрут должен быть кольцевым (замкнутым, первая точка, она-же и последняя)


Создание файлов границ.
Я создаю файлы границ с помощью программ osmosis и mkgmap запуская файл 3_run_boundary.bat,
@echo off
 set BASEDIR=%CD%
:: =============================================================
rem Очистка целевых каталогов
echo .
echo .   Cleaning the target directory
echo .
 del /q /s %BASEDIR%\boundary\*.*
:: =============================================================
rem Создаём файлы границ из данных OSM Osmosis.
echo .
echo .   Osmosis create boundary out of file OSM data
echo .

call %BASEDIR%\osmosis\bin\osmosis ^
   --read-pbf file=%BASEDIR%\input\MAP.osm.pbf outPipe.0=1 ^
   --buffer inPipe.0=1 outPipe.0=2 ^
   --tag-filter reject-relations inPipe.0=2 outPipe.0=3 ^
   --tag-filter accept-ways boundary=administrative,postal_code inPipe.0=3 outPipe.0=4 ^
   --used-node inPipe.0=4 outPipe.0=5 ^
   ^
   --read-pbf file=%BASEDIR%\input\MAP.osm.pbf outPipe.0=6 ^
   --buffer inPipe.0=6 outPipe.0=7 ^
   --tag-filter accept-relations boundary=administrative,postal_code inPipe.0=7 outPipe.0=8 ^
   --used-way inPipe.0=8 outPipe.0=9 ^
   --used-node inPipe.0=9 outPipe.0=10 ^
   ^
   --merge inPipe.0=5 inPipe.1=10 outPipe.0=11 ^
   --write-pbf file=%BASEDIR%\boundary\local-boundaries.osm.pbf omitmetadata=true compress=deflate inPipe.0=11 

 java -cp %BASEDIR%\mkgmap\mkgmap.jar ^
     uk.me.parabola.mkgmap.reader.osm.boundary.BoundaryPreprocessor ^
     %BASEDIR%\boundary\local-boundaries.osm.pbf %BASEDIR%\boundary\local

 но можно и воспользоваться уже готовым файлом bounds.zip и переименовав в папке styles файл optionsfile3.args или optionsfile4.args в optionsfile.args


Разрезание данных OSM необходимой области на части.
Бывают довольно большие osm-файлы, mkgmap на них будет ругаться, с сообщением:
There is not enough room in a single garmin map for all the input data
   The .osm file should be split into smaller pieces first.
Такие файлы предварительно надо нарезать splitter-ом
Я это делаю запустив 4_run_splitting.bat.
@echo off
set BASEDIR=%CD%
:: =============================================================
rem Очистка целевых каталогов
echo .
echo .   Cleaning the target directory
echo .
 del /q /s %BASEDIR%\output\*.*
 del /q /s %BASEDIR%\tiles\*.*
:: =============================================================
rem Разбиваем файл данных OSM на плитки Splitter-ом.
echo .
echo .   Splitting a file OSM data
echo .
rem java -Xmx512m -jar %BASEDIR%\splitter\splitter.jar ^
 java -Xmx3G -jar %BASEDIR%\splitter\splitter.jar ^
  --max-nodes=1600000 ^
  --overlap=0 ^
  --output-dir=%BASEDIR%\output ^
  --write-kml=%BASEDIR%\tiles\tiles.kml ^
  --output=pbf ^
  --keep-complete=true ^
  --no-trim ^
  %BASEDIR%\input\MAP.osm.pbf > %BASEDIR%\splitter\logs\splitter.log

 "%PROGRAMFILES(x86)%\GPSBabel\gpsbabel" -i kml -o osm -f %BASEDIR%\tiles\tiles.kml -F %BASEDIR%\tiles\tiles.osm
 "%PROGRAMFILES(x86)%\GPSBabel\gpsbabel" -i kml -o gpx -f %BASEDIR%\tiles\tiles.kml -F %BASEDIR%\tiles\tiles.gpx
 "%PROGRAMFILES(x86)%\GPSBabel\gpsbabel" -i kml -o gdb -f %BASEDIR%\tiles\tiles.kml -F %BASEDIR%\tiles\tiles.gdb

Если Вам не нужны (для исследования) файлы tiles.* то надо удалить последние строки начинающиеся с  "%PROGRAMFILES(x86)%\GPSBabel\gpsbabel"….,
 а также строку   --write-kml=%BASEDIR%\tiles\tiles.kml ^ 
Для использования геоданных надо добавить в параметры следующую строку
--geonames-file=%BASEDIR%\input\cities15000.zip ^
Или cities1000.zip, или cities5000.zip, или RU.zip – кому что нравится

Создание карты.
Запускаем 5_run_create.bat.
@echo off
 set BASEDIR=%CD%
:: =============================================================
echo .
echo .
echo Введите номер - соответствующего выбранного стиля
echo создоваемой карты
echo 1 - maptourist - стиль карт с http://maptourist.org/file/category/3-garmin/
echo 2 - stranger - стиль карт с http://velo100.ru/gps/download
echo 3 - My-style - стиль карт Mkgmap default + J-Typ-v161.typ
echo .
set /p NAME="Enter NAME Style - "
echo NAME Style is - %NAME%
if %NAME%==1 goto style1
if %NAME%==2 goto style2
if %NAME%==3 goto style3

goto EOS

rem set MYSTYLE=      - Имя папки со стилем, имя стиля
rem set MYFID=        - FID карты
rem set MYTYP=        - Имя TYP файла без расширения

:style1
 set MYSTYLE=maptourist
 set MYFID=480
 set MYTYP=M00001e0
goto pusk

:style2
 set MYSTYLE=stranger
 set MYFID=43
 set MYTYP=M000002b
goto pusk

:style3
 set MYSTYLE=My-style
 set MYFID=1000
 set MYTYP=J-Typ-v161
goto pusk


:default
 set MYSTYLE=%MYSTYLE%
 set MYFID=%MYFID%
 set MYTYP=%MYTYP%

:pusk
:: =============================================================
rem Очистка целевых каталогов
echo .
echo .    Cleaning the target directory for Creating.
echo .
 del /q /s %BASEDIR%\_Garmin\%MYSTYLE%.img
 del /q /s %BASEDIR%\_MapSource\%MYSTYLE%\*.*
 rmdir /q %BASEDIR%\_MapSource\%MYSTYLE%\
 mkdir %BASEDIR%\_MapSource\%MYSTYLE%
:: =============================================================
rem Создаем карту с помощью MKGMAP
echo .
echo .    Create a map using MKGMAP...
echo .
 cd "%BASEDIR%\output\"
rem java -Xmx1024m -jar "%BASEDIR%\mkgmap\mkgmap.jar" ^
 java -Xmx3G -jar "%BASEDIR%\mkgmap\mkgmap.jar" ^
 --output-dir=%BASEDIR%\_MapSource\%MYSTYLE% ^
 --description="OSM %MYSTYLE% v. %DATE%" ^
 --family-name="OpenStreetMap + %MYSTYLE%" ^
 --series-name="Russia" ^
 --overview-mapname="OSM_%MYSTYLE%" ^
 --area-name="OSM %DATE%" ^
 --copyright-message="OpenStreetMap CC-BY-SA 2.0, ST-GIS CC-BY-SA 3.0, %MYSTYLE%" ^
 --family-id=%MYFID% ^
 --keep-going ^
 --read-config=%BASEDIR%\styles\optionsfile.args ^
 --style-file=%BASEDIR%\styles\%MYSTYLE% ^
 -c %BASEDIR%\output\template.args %BASEDIR%\styles\%MYSTYLE%\%MYTYP%.typ 
pause
:: =============================================================
rem Копирование карт в выходные каталоги
echo .
echo .    Copying gmapsupp.img into output...
echo .
 cd "%BASEDIR%"
 move /y %BASEDIR%\_MapSource\%MYSTYLE%\gmapsupp.img %BASEDIR%\_Garmin
 rename %BASEDIR%\_Garmin\gmapsupp.img %MYSTYLE%.img

Вы можете изменить опции в файле %BASEDIR%\styles\optionsfile.args


Не забывам забирать готовые карты в папках:
	_Garmin		Для прибора
	_MapSource	Для программ MapSource и BaseCamp

Теперь надо поблагодарить создателей программ, скриптов и всех создавших и поддерживающих проект OpenStreetMap.

Stranger (by Max Vasilev: http://forum.openstreetmap.org/viewtopic.php?id=15613 ) за предоставленный Стиль карт для Garmin сайта velo100.ru https://github.com/MaksVasilev/stranger-garmin 
На счет вопросов распостранения карт, сгенерированных с этим стилем - обязательно консультируйтесь с автором.

Maptourist (by ValentinAK: http://forum.openstreetmap.org/viewtopic.php?id=13875  ) за предоставленный Стиль карт для Garmin сайта http://maptourist.org/file/category/3-garmin 
На счет вопросов распостранения карт, сгенерированных с этим стилем - обязательно консультируйтесь с автором.

Коллектив ( http://forum.openstreetmap.org/viewtopic.php?id=13884 )  за предоставленный Стиль карт для Garmin сайта http://freizeitkarte-osm.de/

Программа mkgmap http://www.mkgmap.org.uk/download/mkgmap.html 
Программа splitter http://www.mkgmap.org.uk/download/splitter.html 
Программа osmosis http://bretth.dev.openstreetmap.org/osmosis-build/osmosis-latest.zip 
Программа wget http://www.gnu.org/software/wget/ 
Проект OSM https://ru.wikipedia.org/wiki/OpenStreetMap 
Русскоязычный форум http://forum.openstreetmap.org/viewforum.php?id=21 