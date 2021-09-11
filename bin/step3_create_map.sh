#!/bin/bash
# ------------------------------------------------------------------
# [Author] Title
#          Description
#
#
# Dependency:
#       * mkgmap               Download: https://www.mkgmap.org.uk/download/mkgmap.html
#       * splitter             Download: https://www.mkgmap.org.uk/download/splitter.html
#       * osmconvert64         Download: https://wiki.openstreetmap.org/wiki/Osmconvert#Linux
#       * gpsbabel             Installation: sudo apt-get install gpsbabel
#       * srtm2osm             Download: https://wiki.openstreetmap.org/wiki/Srtm2Osm#Download
#       * cities5000.zip       Download: http://download.geonames.org/export/dump/cities5000.zip
#       * bounds-latest.zip    Download: http://osm.thkukuk.de/data/bounds-latest.zip
#       * sea-latest.zip       Download: http://osm.thkukuk.de/data/sea-latest.zip
# ------------------------------------------------------------------

BASEDIR=~/OSM
MKGMAPDIR=$BASEDIR/tools/mkgmap
SPLITTERDIR=$BASEDIR/tools/splitter
OSMCONVERTDIR=$BASEDIR/tools/osmconvert
WWWROOT=$BASEDIR/garmin
JAVAMEM="-Djava.io.tmpdir=$BASEDIR/tmp -Xms4G -Xmx5G"


usage() {
  cat <<EOF # remove the space between << and EOF, this is due to web plugin issue

Usage: $(basename "${BASH_SOURCE[0]}") <mapname> <style>

  Environment variables:
      set FEDERAL=yes to make federal distinct map (default is "custom")
      set SOURCE=/path/to/planet.pbf to overwrite source (default is $BASEDIR/source.osm.pbf)

  Mapname:
      Use the same name as poly-file. (see $BASEDIR/poly/) 

  Style:
      maptourist  - Style by ValentinAK (MapTourist), https://maptourist.org
      velo100     - Style by Maks Vasilev, http://velo100.ru/gps


Available options:

-h, --help      Print this help and exit
-v, --verbose   Print script debug info
-f, --flag      Some flag description
-p, --param     Some param description
--srtm


EOF
  exit
}

if [ $# == 0 ] ; then
    usage;
    exit 1;
fi

echo "Checking dpendency..."
[ ! -f $MKGMAPDIR/mkgmap.jar ] && printf "\nERROR: mkgmap not found!\n\n" && ABANDON=true
echo "mkgmap OK!"
[ ! -f $OSMCONVERTDIR/osmconvert64 ] && printf "\nERROR: osmconvert not found!\n\n" && ABANDON=true
echo "osmconvert OK!"
[ ! -f $SPLITTERDIR/splitter.jar ] && printf "\nERROR: splitter not found!\n\n" && ABANDON=true
echo "splitter OK!"
[ ! -f $BASEDIR/bounds/version.txt ] && printf "\nERROR: bounds-folder not found!\n\n" && ABANDON=true
echo "bounds-folder OK!"
[ ! -f $BASEDIR/sea/version.txt ] && printf "\nERROR: sea-folder not found!\n\n" && ABANDON=true
echo "sea-folder OK!"
[ ! -f $BASEDIR/cities5000.txt ] && printf "\nERROR: cities5000.txt not found!\n\n" && ABANDON=true
echo "cities5000.txt OK!"
echo "Done."


[ -x /usr/bin/md5sum ] && sum="/usr/bin/md5sum"

[ -z "$sum" ] && printf "\nERROR: md55sum tools not found!\n\tCheck you coreutils installation for md55sum (md5) tool.\n\n" && ABANDON=true

if [ -z $SOURCE ]
then SOURCE=$BASEDIR/source.osm.pbf && [ ! -f $SOURCE ] && printf "\nERROR: Source file $SOURCE not found!\n\tCreate a symbolic link from planet.osm.pbf or local.osm.pbf\n\tto $BASEDIR/source.osm.pbf or set SOURCE=/path/to/your/source.osm.pbf\n\n" && ABANDON=true
else [ ! -f $SOURCE ] && printf "\nERROR: file in SOURCE not found!\n\tSOURCE set to $SOURCE\n\n" && ABANDON=true
fi

[ ! -f $BASEDIR/poly/$1.poly ] && printf "\nERROR: Poly file $BASEDIR/poly/$1.poly not found!\n\n" && ABANDON=true

TILESNUM=`printf $1 | $sum | tr -d "a-z0" | cut -c -5`000
SHORTMAP=`printf $1 | tr -d " " | cut -c -11`

if [ -z $FEDERAL ]
then PUBLISH=$WWWROOT/custom/
else PUBLISH=$WWWROOT/federal/
fi

[ ! -z $ABANDON ] && exit 0

printf "\nok, work on map:\t$1\n\nmkgmap found in:\t$MKGMAPDIR\nosm source data:\t$SOURCE\npoly file to trim:\tpoly/$1.poly\ntrimmed source file:\tpbf/$1.pbf\noutput map file:\tmap/$1.img\ntile set number:\t$TILESNUM\npublic destination:\t$PUBLISH\n\n"




