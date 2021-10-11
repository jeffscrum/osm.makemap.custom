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

./tools/osmosis/bin/osmosis \
--read-xml file="$BASEDIR/osm/contours.osm" \
--sort \
--write-pbf file="$BASEDIR/pbf/$1_contours.osm.pbf"
