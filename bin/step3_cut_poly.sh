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

[ -z $1 ] && printf "\nuse: $0 <mapname>\n\n\tset SOURCE=/path/to/planet.pbf to overwrite source\n\t\t(default is $BASEDIR/source.osm.pbf)\n\n" && exit 0

[ -x /usr/bin/sha1sum ] && sum=/usr/bin/sha1sum
[ -x /sbin/sha1 ] && sum="/sbin/sha1 -r"

[ -z "$sum" ] && printf "\nERROR: SHA1 tools not found!\n\tCheck you coreutils installation for sha1sum (sha1) tool.\n\n" && ABANDON=true

if [ -z $SOURCE ]
then SOURCE=$BASEDIR/source.osm.pbf && [ ! -f $SOURCE ] && printf "\nERROR: Source file $SOURCE not found!\n\tCreate a symbolic link from planet.osm.pbf or local.osm.pbf\n\tto $BASEDIR/source.osm.pbf or set SOURCE=/path/to/your/source.osm.pbf\n\n" && ABANDON=true
else [ ! -f $SOURCE ] && printf "\nERROR: file in SOURCE not found!\n\tSOURCE set to $SOURCE\n\n" && ABANDON=true
fi

[ ! -f $BASEDIR/poly/$1.poly ] && printf "\nERROR: Poly file $BASEDIR/poly/$1.poly not found!\n\n" && ABANDON=true

TILESNUM=`printf $1 | $sum | tr -d "a-z0" | cut -c -5`000
SHORTMAP=`printf $1 | tr -d " " | cut -c -11`

[ ! -z $ABANDON ] && exit 0

echo "Cutting $1 poly from $SOURCE..."
$TOOLSDIR/osmconvert/osmconvert64 $SOURCE -B=$BASEDIR/poly/$1.poly --complex-ways -o=$BASEDIR/pbf/$1.pbf

echo "Done."
echo "Сleaning temporary files..."
rm $WORKDIR/osmconvert_tempfile.* 
echo "Done."

