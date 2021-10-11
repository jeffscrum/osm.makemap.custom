#!/bin/bash
# ------------------------------------------------------------------
# [Author] Title
#          Description
#
# ------------------------------------------------------------------

BASEDIR=~/OSM
TOOLSDIR=$BASEDIR/tools
SOURCE=$BASEDIR/source.osm.pbf

[ -z $1 ] && printf "\nuse: $0 <mapname>\n\n" && exit 0

[ ! -f $TOOLSDIR/osmosis/bin/osmosis ] && printf "\nERROR: osmosis not found! Check $TOOLSDIR/osmosis!\n\n" && ABANDON=true

[ ! -f $BASEDIR/poly/$1.poly ] && printf "\nERROR: Poly file $BASEDIR/poly/$1.poly not found!\n\n" && ABANDON=true

[ ! -f $BASEDIR/source.osm.pbf ] && printf "\nERROR: Source file $SOURCE not found!\n\tCreate a symbolic link from planet.osm.pbf or local.osm.pbf\n\tto $BASEDIR/source.osm.pbf!\n\n" && ABANDON=true

[ ! -z $ABANDON ] && exit 0


echo "Cutting a poly from source..."
$TOOLSDIR/osmosis/bin/osmosis --read-pbf file="$SOURCE" --bounding-polygon file="$BASEDIR/poly/$1.poly" --write-pbf file="$BASEDIR/pbf/$1.osm.pbf"

echo ""
echo "Done."

