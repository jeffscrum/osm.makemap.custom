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
WORKDIR=$BASEDIR/script
TOOLSDIR=$BASEDIR/tools
JAVAMEM="-Djava.io.tmpdir=$BASEDIR/tmp -Xms4G -Xmx5G"
MAPNAME=$1_w_contours

[ -z $1 ] && printf "\nuse: $0 <mapname>\n\n" && exit 0

[ ! -f $TOOLSDIR/mkgmap/mkgmap.jar ] && printf "\nERROR: mkgmap not found!\n\n" && ABANDON=true

[ -x /usr/bin/sha1sum ] && sum=/usr/bin/sha1sum
[ -x /sbin/sha1 ] && sum="/sbin/sha1 -r"

TILESNUM=`printf $1 | $sum | tr -d "a-z0" | cut -c -5`000
TILESNUM2=`printf $1 | $sum | tr -d "a-z0" | cut -c -5`001
SHORTMAP=`printf $1 | tr -d " " | cut -c -11`

[ ! -z $ABANDON ] && exit 0

echo "Cleaning old maps..."
([ -d $BASEDIR/img.$MAPNAME ] && rm -rf $BASEDIR/img.$MAPNAME) || mkdir $BASEDIR/img.$MAPNAME
[ ! -d $BASEDIR/img.$MAPNAME ] && mkdir $BASEDIR/img.$MAPNAME
echo "Done."

echo "Create Garmin IMG..."
java -jar ./tools/mkgmap/mkgmap.jar --verbose \
        --max-jobs=4 \
        --tdbfile \
        --gmapi \
        --mapname=$TILESNUM \
        --family-name="OpenStreetMap + ST-GIS by ValentinAK (MapTourist)" \
        --product-id=1 \
        --family-id=480 \
        --series-name="Russia" \
        --description="$SHORTMAP, https://maptourist.org, v.`date +%d.%m.%Y`" \
        --country-name="RUSSIA" --country-abbr="RUS" \
        --copyright-message="`date +%Y`, OpenStreetMap CC-BY-SA 2.0, ST-GIS CC-BY-SA 3.0, ST-GIS, ValentinAK" \
        --charset=cp1251 --code-page=1251 --lower-case \
        --name-tag-list=name:ru,name,name:en,int_name \
        --style-file=/root/OSM/styles/maptourist \
        --remove-short-arcs \
        --drive-on=detect,right \
        --check-roundabouts \
        --output-dir=/root/OSM/img.crimea_w_contours \
        --make-poi-index --index --poi-address \
        --route \
        --draw-priority=31 \
        --bounds=/root/OSM/bounds \
        --add-pois-to-areas \
        --precomp-sea=/root/OSM/sea \
        --generate-sea=multipolygon \
        --housenumbers \
$BASEDIR/styles/maptourist.txt $BASEDIR/split.$1/*.pbf \
        --family-name=$1_w_contours \
        --product-id=1 \
        --family-id=481 \
        --series-name=$MAPNAME \
        --description="SRTM Contours, v.`date +%d.%m.%Y`" \
        --lower-case \
        --style-file=/root/OSM/styles/contours \
        --remove-short-arcs \
        --check-roundabouts \
        --draw-priority=50 \
        --transparent \
$BASEDIR/styles/contours.txt $BASEDIR/split.$1_contours/*.pbf

