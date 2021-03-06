#!/bin/bash

##$License$##
##
# $Revision: 952 $
# $Id: gen_master_pot.sh 952 2007-06-20 22:35:55Z ipso $
# $Date: 2007-06-20 15:35:55 -0700 (Wed, 20 Jun 2007) $
#
# File Contributed By: Open Source Consulting, S.A.   San Jose, Costa Rica.
# http://osc.co.cr
##

# This script generates the master .pot file containing english strings
# for translation.
#
# These strings are parsed from:
#   * smarty templates between {t}some text{/t} blocks  
#   * PHP Files containing TTi18n::gettext("some text") function calls.

# We could also parse from static DB text, but so far see no need for 
# doing so.

DEPTH=../..
LOCALE_ROOT=$DEPTH/interface/locale
POT_FILENAME=messages.pot

#---- Ensure pot file exists ----
touch $LOCALE_ROOT/$POT_FILENAME

#---- Extract strings from templates ----
echo "Parsing templates..."
TMP_FILE=/tmp/gen_master_pot_tmp.txt
#find $DEPTH/templates -type f -exec cat \{\} \; > $TMP_FILE && php tsmarty2c.php $TMP_FILE | xgettext --language=C --no-location --output-dir=$LOCALE_ROOT -o $POT_FILENAME -
#Need to exclude SVN dirs
find $DEPTH/templates -name "*.tpl" | grep -v "\.svn" | xargs -i php tsmarty2c.php \{\} | xgettext --no-wrap --language=C --no-location --output-dir=$LOCALE_ROOT -o $POT_FILENAME -
#rm $TMP_FILE 

#---- Extract strings from PHP Files ----
# Note that we want to extract from TTi18n::gettext() calls.  
# xgettext ignores the "TTi18n::" bit and sees the gettext(). So it works.
echo "Parsing PHP Files..."
find $DEPTH/ -name "*.php" | grep -v templates_c | grep -v "\.svn" | xargs cat | xgettext --no-wrap --keyword=getText --join-existing --language=PHP --no-location --output-dir=$LOCALE_ROOT -o $POT_FILENAME -


#---- Extract strings from DB Tables with static strings ----
###  Not necessary for TimeTrex at this time ###


#---- Done ----
echo "Done!  POT File is in " $LOCALE_ROOT/$POT_FILENAME

