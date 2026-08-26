FILES = secrets/* src/meta.dg src/world.dg src/topology.dg src/interface.dg src/ai.dg src/input.dg src/actions.dg src/quips.dg src/prizes.dg lib/quipmachinery.dg lib/prizemachinery.dg lib/automap.dg lib/versalink.dg lib/draclib.dg lib/dialog/stdlib.dg
OPTIONS = -r resources -vv
OPTIONS_DBG =
VERSION = 5

debug: $(FILES) platform/debug.dg
	dgdebug $(OPTIONS_DBG) platform/debug.dg $(FILES)

rat.z5: $(FILES) platform/z.dg
	dialogc -t z5 -o rat.z5 $(OPTIONS) platform/z.dg $(FILES)

rat.aastory: $(FILES) platform/web.dg
	dialogc -t aa -o rat.aastory $(OPTIONS) platform/web.dg $(FILES)

web: rat.aastory modweb
	rm -rf web
	aambundle -t web rat.aastory -o web
	cp -r modweb/* web/
	mv web/play.html web/index.html

itch.zip: web
	rm -f itch.zip
	( cd web && zip -r ../itch.zip . )

itch: itch.zip rat.z5
	mv itch.zip itch_$(VERSION).zip
	mv rat.z5 z5_$(VERSION).z5
	cp itch_$(VERSION).zip web_$(VERSION).zip
	butler push itch_$(VERSION).zip dercomai/rat:online
	butler push z5_$(VERSION).z5 dercomai/rat:z
	butler push web_$(VERSION).zip dercomai/rat:download

vvv.log: $(FILES)
	dgdebug -vvv $(OPTIONS_DBG) $(FILES) > vvv.log

regress.out: $(FILES) platform/debug.dg regress.in
	dgdebug -qD -s 1234 $(OPTIONS_DBG) platform/debug.dg $(FILES) <regress.in >regress.out

regress: regress.out
	meld regress.out regress.gold

ifcomp.zip: web rat.z5 hints.html cover.png
	rm -f ifcomp.zip
	rm -rf ifcomp
	mkdir ifcomp
	cp -r web ifcomp/
	cp rat.z5 ifcomp/zmachine.z5
	cp README.ifcomp ifcomp/
	cp cover.png ifcomp/
	cp hints.html ifcomp/
	cp index.html ifcomp/
	( cd ifcomp && zip -r ../ifcomp.zip . )
	cp ifcomp.zip ifcomp_$(VERSION).zip

PWD := $(shell pwd)
hints.html: hints.clu
	( cd ~/Projects/Invisiclues && python3 maker.py $(PWD)/hints )
