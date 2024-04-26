#!/usr/bin/sed -f
#

s/تُرُدّ/تَرُدّ/g

s/تَثْنَّى/تُثَنَّى/g
s/تَثَلُثُ/تُثَلَّثُ/g

s/\([^ُ]\)ون/\1ُوْنَ/

s/\([^َ]\)اْت/\1َاْت/g

s/>و/>وَ/g
s/>وََ/>وَ/g
s/ و/ وَ/g
s/ وََ/ وَ/g

s/ ويا / وَيَا /g
s/ يا / يَا /g

s/اً/ِا/g

s/>ف/>فَ/g
s/>فََ/>فَ/g

## fix tashkeel ordering (legacy)
s/َِ/َ/g
# damma shadda
s/ُّ/ُّ/g
# dammatun shadda
s/ٌّ/ٌّ/g
# fatha shadda
s/َّ/َّ/g
# kasra shadda
s/ِّ/ِّ/g

# restore xml decl
s/<xml version="1.0" encoding="utf-8">/<?xml version="1.0" encoding="utf-8"?>/g