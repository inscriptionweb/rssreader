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

# Kill program if $1==stop
if [ "$1" == "stop" ]; then
  killall -9 rsstail
else

# Kill all rsstail instances before continuing
./reader.sh stop
clear

# Start rsstail
for url in "${array[@]}"
do
  # for each link in te list above, start an rsstail
  #   send output to $feedfile
  rsstail -r -u $url >> $feedfile &
done

# Loop over $feedfile and output to console
while true; do
  # Read first line of $feedfile
  INPUT=$(head -n 1 $feedfile | sed 's/^Title: //')
  # Set a randon wait time in no. of spins
  WAIT=$(( ( RANDOM % 10 )  + 1 ))
  # For each random number of spins, spin the cursor
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

  # If $feedfile is empty, or input is empty, just keep spinnin'
  #   we don't enter the output phase
  if [ ! -z "$INPUT" ]; then
  # go back in line and get ready for input
  echo -ne "\r";

  # Read input line character by character
  #   and output to console
  for (( i=0; i<${#INPUT}; i++ )); do
    echo -n "${INPUT:$i:1}"
    # wait 0.025 between each character outputs
    sleep 0.025
  done
  # Output empty line and delete first line in file (the one we just read)
  echo ""
  sed -i '1d' $feedfile
  fi
done
fi
