#!/bin/sh

cp $1 $1.bak
# First: double-quotes between whitespace and non-whitespace
perl -pi -e "s/(\S)\"(\s|$)/\1”\2/g" $1
perl -pi -e "s/(\s)\"(\S)/\1“\2/g" $1
# Second: single-quotes between whitespace and non-whitespace
perl -pi -e "s/(\s)\'(\S)/\1‘\2/g" $1
# The following one is more broad to hit "they're" etc
perl -pi -e "s/(\S)\'/\1’/g" $1
# Third: double-quotes in parentheses
perl -pi -e "s/\"\)/”\)/g" $1
perl -pi -e "s/\(\"/\(“/g" $1
# Fourth: double-quotes between words and any other punctuation
perl -pi -e "s/(\w)\"(\W)/\1”\2/g" $1
perl -pi -e "s/(\W)\"(\w)/\1“\2/g" $1
grep "[\"']" $1 && exit 1
meld $1.bak $1
