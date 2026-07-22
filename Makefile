FILES = src/meta.dg src/world.dg src/topology.dg src/interface.dg src/ai.dg src/input.dg src/actions.dg src/quips.dg src/prizes.dg lib/quipmachinery.dg lib/prizemachinery.dg lib/automap.dg lib/versalink.dg lib/draclib.dg lib/dialog/stdlib.dg
OPTIONS = -r resources

debug: $(FILES) platform/debug.dg
	dgdebug $(OPTIONS) platform/debug.dg $(FILES)

rat.z5: $(FILES) platform/z.dg
	dialogc -t z5 -o rat.z5 $(OPTIONS) platform/z.dg $(FILES)

rat.aastory: $(FILES) platform/web.dg
	dialogc -t aa -o rat.aastory $(OPTIONS) platform/web.dg $(FILES)

web: rat.aastory modweb
	rm -rf web
	aambundle -t web rat.aastory -o web
	cp -r modweb/* web/

vvv.log: $(FILES)
	dgdebug -vvv $(OPTIONS) $(FILES) > vvv.log

regress.out: $(FILES) platform/debug.dg regress.in
	dgdebug -qD -s 1234 $(OPTIONS) platform/debug.dg $(FILES) <regress.in >regress.out

regress: regress.out
	meld regress.out regress.gold
