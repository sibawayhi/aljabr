## PDF sources are in editions/pdfpages

## procedure:
## 0. OCR page at https://www.i2ocr.com/free-online-arabic-ocr
##    output to raw/pxxx.raw
## 1. make pre PG=xxx
##    takes raw/pxxx.raw to raw/pxxx.raw.txt, fixes misspellings
## 2. Edit raw/pxxx.raw.txt
## 3. use https://www.tashkil.net/tashkil for tashkeel
##    put output in raw/pxxx.xlit
##obsolete: https://ahmadai.com/shakkala/lang_en
## 4. make tashkeel PG=xxx fixes some stuff, writes txt/pxxx.txt
## 5. Edit txt/pxxx.txt to add XML markup, then discard prev stuff

JAVA=java -Dsun.stdout.encoding="UTF-8" -Dsun.stderr.encoding="UTF-8"
SAXON=/usr/local/share/SaxonHE12-4J/saxon-he-12.4.jar
XERCES=/usr/local/share/xerces

XINCL=-Dorg.apache.xerces.xni.parser.XMLParserConfiguration=org.apache.xerces.parsers.XIncludeParserConfiguration

CLASSP=${SAXON}:${XERCES}/xercesImpl.jar:${XERCES}/resolver.jar:${XERCES}/xml-apis.jar:${XERCES}/xalan.jar

ENSRC=${PWD}/../work/en
SRCDIR=xml

LANG=ar
XSL=../../kitab/work/xsl
XMLTOOLS=../../xmltools

DRAFT=
TRANS=1
IGT=
CMT=
IMG=0
MULTILING=

#FIXME: also pass directory path containing article
ART=aljabr


2col:
	${JAVA} \
	${XINCL} \
	-cp ${CLASSP} \
        net.sf.saxon.Transform  \
	-x:org.apache.xerces.parsers.SAXParser \
	-xsl:${XSL}/book2tex.2col.xsl \
	-s:xml/aljabr.${LANG}.xml \
	-o:tmp/aljabr.tex \
	artid=${ART} \
	argitrev=`cd ${SRCDIR} && git rev-parse --short HEAD` \
	engitrev=`git rev-parse --short HEAD` \
	ensrc=${ENSRC}/aljabr.en.xml \
	draft=${DRAFT} \
	translate=${TRANS} \
	igt=${IGT} \
	commentary=${CMT} \
	images=${IMG} \
	multiling=${MULTILING};
	(cd tmp && xelatex aljabr.tex \
	2>&1 > log.latex);

idx:
	(cd tmp && makeindex -s ../aridx.ist aridx.idx); \

bib:
	(cd tmp && biber aljabr);

gloss:
	(cd tmp && makeglossaries aljabr);

xel:
	(cd tmp && xelatex aljabr.tex \
	2>&1 > log.latex); \


x2col:
	java -jar ${SAXON} \
	-xi:on \
	-xsl:${XSL}/book2tex.2col.xsl \
	-s:xml/aljabr.${LANG}.xml \
	-o:tmp/aljabr.tex \
	artid=${ART} \
	argitrev=`cd ${SRCDIR} && git rev-parse --short HEAD` \
	engitrev=`git rev-parse --short HEAD` \
	ensrc=${ENSRC}/aljabr.en.xml \
	draft=${DRAFT} \
	translate=${TRANS} \
	igt=${IGT} \
	commentary=${CMT} \
	multiling=${MULTILING};
	(cd tmp && xelatex \
	aljabr.tex \
	2>&1 > log.latex);

	# -xsl:${XSL}/sib.bab2tex.2col.xsl \

.PHONY : pre tashkeel

pre:
	./bin/pretashkeel.sed raw/p${PG}.raw > raw/p${PG}.raw.txt

tashkeel:
	./bin/tashkeel.sed raw/p${PG}.xlit > xml/p${PG}.ar.xml

segnum:
	cp xml/aljabr.${LANG}.xml ./backups;
	chmod u+w ./backups/aljabr.${LANG}.xml;
	java -jar ${SAXON} \
	-s:xml/aljabr.${LANG}.xml \
	-xsl:${XMLTOOLS}/tools/sib.${LANG}.segnum.xsl \
	-o:tmp/segnum/aljabr.${LANG}.xml \
	artid=aljabr;
	bin/fixspace.sed tmp/segnum/aljabr.${LANG}.xml > xml/aljabr.${LANG}.xml

ar2en:
	${JAVA} -jar ${SAXON} \
	-s:xml/p${P}.ar.xml \
	-xsl:${XMLTOOLS}/tools/sib.ar2en.xsl \
	artid=${P};

clean:
	-rm tmp/*.aux tmp/*.bbl tmp/*.bcf tmp/*.blg;
	-rm tmp/*.idx tmp/*.lof tmp/*.log tmp/*.run.xml tmp/*.toc
