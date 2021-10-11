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

[ -z $1 ] && printf "\nuse: $0 <mapname>\n\n" && exit 0

[ ! -f $TOOLSDIR/mkgmap/mkgmap.jar ] && printf "\nERROR: mkgmap not found!\n\n" && ABANDON=true

[ -x /usr/bin/sha1sum ] && sum=/usr/bin/sha1sum
[ -x /sbin/sha1 ] && sum="/sbin/sha1 -r"

TILESNUM=`printf $1 | $sum | tr -d "a-z0" | cut -c -5`000
SHORTMAP=`printf $1 | tr -d " " | cut -c -11`

[ ! -z $ABANDON ] && exit 0

echo "Cleaning old maps..."
([ -d $BASEDIR/img.$1 ] && rm -rf $BASEDIR/img.$1/*) || mkdir $BASEDIR/img.$1
[ ! -d $BASEDIR/map ] && mkdir $BASEDIR/map
echo "Done."

echo "Create Garmin IMG..."
java -jar $TOOLSDIR/mkgmap/mkgmap.jar --verbose \
        --max-jobs=4 \
        --gmapsupp --tdbfile \
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
        --style-file=$BASEDIR/styles/maptourist \
        --remove-short-arcs \
        --drive-on=detect,right \
        --check-roundabouts \
        --output-dir=$BASEDIR/img.$1 \
        --make-poi-index --index --poi-address \
        --route \
        --draw-priority=31 \
        --bounds=$BASEDIR/bounds \
        --add-pois-to-areas \
        --precomp-sea=$BASEDIR/sea \
        --generate-sea=multipolygon \
        --housenumbers \
        $BASEDIR/styles/maptourist.txt $BASEDIR/split.$1/*.pbf
