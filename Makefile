SAXON=/usr/local/share/SaxonHE12-4J/saxon-he-12.4.jar
LANG=ar

#FIXME: also pass directory path containing article
ART=aljabr

.PHONY : pre tashkeel

pre:
	./bin/pretashkeel.sed raw/p${PG}.raw > raw/p${PG}.raw.txt

tashkeel:
	./bin/tashkeel.sed tmp/p${PG}.tmp > txt/p${PG}.txt

2col:
	java -jar ${SAXON} \
	-xi:on \
	-s:xml/aljabr.${LANG}.xml \
	-xsl:../xsl/sib.${LANG}2tex.2col.xsl \
	-o:tmp/aljabr.tex \
	artid=${ART};
	(cd tmp && xelatex \
	aljabr.tex);

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

