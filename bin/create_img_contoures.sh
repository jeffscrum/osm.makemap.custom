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
	--family-name=Contours \
        --product-id=1 \
        --family-id=481 \
        --description="$SHORTMAP, SRTMv3, v.`date +%d.%m.%Y`" \
        --charset=cp1251 --code-page=1251 --lower-case \
        --style-file=$BASEDIR/styles/contours \
        --remove-short-arcs \
        --check-roundabouts \
        --output-dir=/root/OSM/img.$1 \
        --draw-priority=50 \
        --bounds=$BASEDIR/bounds \
        --precomp-sea=$BASEDIR/sea \
        --generate-sea=multipolygon \
	--transparent \
        $BASEDIR/styles/contours.txt $BASEDIR/split.$1/*.pbf
