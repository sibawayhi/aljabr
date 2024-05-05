SAXON=/usr/local/share/SaxonHE12-4J/saxon-he-12.4.jar
LANG=ar

#FIXME: also pass directory path containing article
ART=aljabr

## PDF sources are in editions/pdfpages

## procedure:
## 0. OCR page at https://www.i2ocr.com/free-online-arabic-ocr
##    output to raw/pxxx.raw
## 1. make pre PG=xxx
##    takes raw/pxxx.raw to raw/pxxx.raw.txt, fixes misspellings
## 2. Edit raw/pxxx.raw.txt
## 3. use https://ahmadai.com/shakkala/lang_en for tashkeel
##    put output in raw/pxxx.xlit
## 4. make tashkeel PG=xxx fixes some stuff, writes txt/pxxx.txt
## 5. Edit txt/pxxx.txt to add XML markup, then discard prev stuff


2col:
	java -jar ${SAXON} \
	-xi:on \
	-s:xml/aljabr.${LANG}.xml \
	-xsl:../xsl/sib.${LANG}2tex.2col.xsl \
	-o:tmp/aljabr.tex \
	artid=${ART};
	(cd tmp && xelatex \
	aljabr.tex \
	2>&1 > log.latex);

.PHONY : pre tashkeel

pre:
	./bin/pretashkeel.sed raw/p${PG}.raw > raw/p${PG}.raw.txt

tashkeel:
	./bin/tashkeel.sed raw/p${PG}.xlit > txt/p${PG}.txt

segnum:
	cp xml/aljabr.${LANG}.xml ./backups;
	chmod u+w ./backups/aljabr.${LANG}.xml;
	java -jar ${SAXON} \
	-s:xml/aljabr.${LANG}.xml \
	-xsl:../xsl/sib.${LANG}.segnum.xsl \
	-o:tmp/segnum/aljabr.${LANG}.xml \
	artid=aljabr;
	bin/fixspace.sed tmp/segnum/aljabr.${LANG}.xml > xml/aljabr.${LANG}.xml

ar2en:
	java -jar ${SAXON} \
	-s:xml/aljabr.ar.xml \
	-xsl:../xsl/sib.ar2en.xsl \
	-o:tmp/aljabr.en.xml

