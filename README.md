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
 │   ├── step1_info.sh
 │   ├── step2_check.sh
 │   ├── step3_cut_poly.sh
 │   ├── step4_split.sh
 │   ├── step5_create_img_maptourist.sh
 │   └── step5_create_img_velo100.sh
 ├── bounds
 ├── cities5000.txt
 ├── garmin
 │   ├── custom
 │   └── federal
 ├── last_tested_version
 ├── map
 ├── pbf
 ├── planet.osm.pbf
 ├── poly
 ├── sea
 ├── source.osm.pbf -> planet.osm.pbf
 ├── styles
 │   ├── maptourist
 │   ├── maptourist.typ
 │   ├── stranger
 │   └── stranger.typ
 ├── tiles
 ├── tmp
 └── tools
     ├── getbound
     ├── mkgmap
     ├── osmconvert
     ├── splitter
     └── srtm2osm
```