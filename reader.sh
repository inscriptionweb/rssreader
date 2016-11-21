#!/bin/bash
#
# Animated RSS Reader - grabs headlines from rss feeds and shows
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# ###
#
# This script is dependent on rsstail
#

# Feedfile is the place for out tempoary file
feedfile=/tmp/rssfeed.rss
# One RSS feed per line, for each rss feed an rsstail will be started
array=(
  "http://mashable.com/rss/"
  "http://gizmodo.com/rss"
  "http://feeds.bbci.co.uk/news/world/rss.xml"
  "http://feeds.foxnews.com/foxnews/latest?format=xml"
  "https://www.wired.com/feed/"
  "http://www.b.dk/seneste/rss"
  "http://www.business.dk/seneste/rss"
  "http://www.bt.dk/bt/seneste/rss"
  "http://rss.cnn.com/rss/edition.rss"
  "http://feeds.bbci.co.uk/news/world/rss.xml"
)

if [ "$1" == "stop" ]; then
  killall -9 rsstail
else

./reader.sh stop
clear

# Start rsstail
for url in "${array[@]}"
do
  rsstail -r -u $url >> $feedfile &
done

# Loop over $feedfile and output to console
while true; do
  INPUT=$(head -n 1 $feedfile | sed 's/^Title: //')
  WAIT=$(( ( RANDOM % 10 )  + 1 ))
  for l in $(seq $WAIT); do
    echo -ne "\r\\"
    sleep 0.05
    echo -ne "\r|"
    sleep 0.05
    echo -ne "\r/"
    sleep 0.05
    echo -ne "\r-"
    sleep 0.05
  done

  # Keep spinning cursor till we got input
  if [ ! -z "$INPUT" ]; then
  echo -ne "\r";

  for (( i=0; i<${#INPUT}; i++ )); do
    echo -n "${INPUT:$i:1}"
    sleep 0.025
  done
  echo ""
  sed -i '1d' $feedfile
  fi
done
fi
