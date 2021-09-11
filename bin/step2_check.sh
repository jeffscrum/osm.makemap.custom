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

echo "Checking all tools and dirs..."

[ ! -f $TOOLSDIR/mkgmap/mkgmap.jar ] && printf "\nERROR: mkgmap not found!\n\n" && ABANDON=true
[ ! -f $TOOLSDIR/osmconvert/osmconvert64 ] && printf "\nERROR: osmconvert not found!\n\n" && ABANDON=true
[ ! -f $TOOLSDIR/splitter/splitter.jar ] && printf "\nERROR: splitter not found!\n\n" && ABANDON=true
[ ! -f $TOOLSDIR/srtm2osm/Srtm2Osm.exe ] && printf "\nERROR: srtm2osm not found!\n\n" && ABANDON=true

[ ! -f $BASEDIR/bounds/version.txt ] && printf "\nERROR: bounds-file not found!\n\n" && ABANDON=true
[ ! -f $BASEDIR/sea/version.txt ] && printf "\nERROR: sea-file not found!\n\n" && ABANDON=true
[ ! -f $BASEDIR/cities5000.txt ] && printf "\nERROR: cities-file not found!\n\n" && ABANDON=true


[ ! -z $ABANDON ] && exit 0

echo "Done. OK."