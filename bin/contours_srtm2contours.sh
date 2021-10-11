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
TOOLSDIR=$BASEDIR/tools

usage() {
  cat <<EOF # remove the space between << and EOF, this is due to web plugin issue
Usage: $(basename "${BASH_SOURCE[0]}") -t -l -b -r -s 

Flags:
-t    Top line of bounding-box
-l    Left line of bounding-box
-b    Bottom line of bounding-box
-r    Right line of bounding-box
-s    Elevation Step (in meters)
EOF
  exit
}



if [ $# == 0 ] ; then
    usage;
    exit 1;
fi

while getopts t:l:b:r:s: flag
do
    case "${flag}" in
        t) top=${OPTARG};;
        l) left=${OPTARG};;
        b) bottom=${OPTARG};;
	r) right=${OPTARG};;
	s) step=${OPTARG};;
    esac
done

echo "Top: $top";
echo "Left: $left";
echo "Bottom: $bottom";
echo "Right: $right";
echo "Step: $step meters"


mono $TOOLSDIR/srtm2osm/Srtm2Osm.exe \
    -bounds1 $top $left $bottom $right \
    -step $step \
    -cat 1000 100 \
    -large \
    -corrxy 0.0005 0.0005 \
    -o $BASEDIR/osm/contours.osm \
    > $BASEDIR/tmp/srtm2osm_`date +%H%M%S`.log


