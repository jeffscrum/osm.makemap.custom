# osm.makemap.custom

Check what you downloaded and install:
	
| Component         | Download or Install                                     | Comments |
|-------------------|---------------------------------------------------------|----------|
| mkgmap            | https://www.mkgmap.org.uk/download/mkgmap.html          | Copy to OSM/tools/mkgmap |
| splitter          | https://www.mkgmap.org.uk/download/splitter.html        | Copy to OSM/tools/splitter |
| osmconvert64      | https://wiki.openstreetmap.org/wiki/Osmconvert#Linux    | Copy to OSM/tools/osmconvert |
| gpsbabel          | sudo apt-get install gpsbabel                           | - |
| srtm2osm          | https://wiki.openstreetmap.org/wiki/Srtm2Osm#Download   | Copy to OSM/tools/srtm2osm |
| cities5000.zip    | http://download.geonames.org/export/dump/cities5000.zip | Unpack to OSM |
| bounds-latest.zip | http://osm.thkukuk.de/data/bounds-latest.zip            | Unpack to OSM/bounds |
| sea-latest.zip    | http://osm.thkukuk.de/data/sea-latest.zip               | Unpack to OSM/sea |



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
 ├── bounds/
 ├── cities5000.txt
 ├── osm/
 ├── pbf/
 ├── poly/
 ├── sea/
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
     ├── mkgmap/
     ├── osmconvert/
     ├── osmosis/
     ├── splitter/
     └── srtm2osm/
```