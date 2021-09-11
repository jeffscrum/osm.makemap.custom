#!/bin/bash
# ------------------------------------------------------------------
# [Author] Title
#          Description
#
#
# Dependency:
#     http://shflags.googlecode.com/svn/trunk/source/1.0/src/shflags
# ------------------------------------------------------------------

BASEDIR=~/OSM
MKGMAPDIR=$BASEDIR/tools/mkgmap

function check_dependency() {
    cat << EOF

Check what you downloaded or install:
	1) mkgmap                   Download: https://www.mkgmap.org.uk/download/mkgmap.html
	2) splitter		    Download: https://www.mkgmap.org.uk/download/splitter.html
	3) osmconvert64             Download: https://wiki.openstreetmap.org/wiki/Osmconvert#Linux
	4) gpsbabel		    Install: sudo apt-get install gpsbabel
	5) srtm2osm		    Download: https://wiki.openstreetmap.org/wiki/Srtm2Osm#Download
	6) cities5000.zip	    Download: http://download.geonames.org/export/dump/cities5000.zip
	7) bounds-latest.zip	    Download: http://osm.thkukuk.de/data/bounds-latest.zip
	8) sea-latest.zip           Download: http://osm.thkukuk.de/data/sea-latest.zip

EOF
}

check_dependency
