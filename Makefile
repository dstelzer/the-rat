FILES = src/meta.dg src/world.dg src/topology.dg src/interface.dg src/ai.dg src/input.dg src/actions.dg src/quips.dg src/prizes.dg lib/quipmachinery.dg lib/prizemachinery.dg lib/automap.dg lib/versalink.dg lib/draclib.dg lib/dialog/stdlib.dg

debug: $(FILES) platform/debug.dg
	dgdebug platform/debug.dg $(FILES)

rat.z5: $(FILES) platform/z.dg
	dialogc -t z5 -o rat.z5 

rat.aastory: $(FILES) platform/web.dg
	dialogc -t aa -o rat.aastory platform/web.dg $(FILES)

web: rat.aastory modweb
	rm -rf web
	aambundle -t web rat.aastory -o web
	cp -r modweb/* web/

vvv.log: $(FILES)
	dgdebug -vvv $(FILES) > vvv.log
