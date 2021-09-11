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

[ -z $1 ] && printf "\nuse: $0 <mapname>\n\n" && exit 0


echo "Cleaning old maps..."
([ -d $BASEDIR/split.$1 ] && rm -rf $BASEDIR/split.$1/*) || mkdir $BASEDIR/split.$1
echo "Done."

echo ""
echo "Splitting map $BASEDIR/pbf/$1.pbf on tiles..."
echo ""
java -jar $TOOLSDIR/splitter/splitter.jar --max-nodes=1200000 \
  --overlap=12000 \
  --output-dir=$BASEDIR/split.$1 \
  --write-kml=$BASEDIR/tiles/$1-tiles.kml \
  --geonames-file=$BASEDIR/cities5000.txt \
  --output=pbf \
  --keep-complete=false \
  $BASEDIR/pbf/$1.pbf

gpsbabel -i kml -o osm -f $BASEDIR/tiles/$1-tiles.kml -F $BASEDIR/tiles/$1-tiles.osm

echo ""
echo "Done."