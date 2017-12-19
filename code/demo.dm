world
	name = "Roguelike"
	fps = 30
	icon_size = 16
	view = 7
	turf = /turf/grass
	mob = /mob/player
	New()
		testland()
		mob_controller()

proc/floraset()
	for(var/turf/grass/G in world)
		if(prob(2) && !G.loc.density) new/obj/flora/tree(G)
		if(prob(2) && !G.loc.density) new/obj/flora/grass(G)
		if(prob(1) && !G.loc.density) new/obj/flora/krasnogrib(G)

proc/testland()
	vorSetMinimumDistance(3)
	vorSetRegionCount(50)
	vorBuildLand()
	vorExpandRegions()
	vorOutlineRegions(1)
	vorCreateLake(5)
	vorCreateMountain(10)
	floraset()

proc/dir4()
	return pick(NORTH, SOUTH, EAST, WEST)

proc/dir8()
	return pick(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)

/turf/grass
	name = "ground"
	icon = 'grass.dmi'
	New()
		dir = dir8()

/turf/walls
	icon = 'flora.dmi'
	density = 1
	opacity = 1

/turf/walls/rock
	icon_state = "rock"

/mob/living
	icon = 'mob.dmi'
	var/canMove = 1

/mob/player
	icon = 'mob.dmi'
	icon_state = "player"
	density = 0
	rundelay = 1

var/population

/mob/player/verb/dwarf()
	for(var/atom/A in loc)
		if(!loc.density && !A.density) new/mob/living/dwarf(src.loc)
		else to_chat(usr,"You can't create a dwarf in here.")

/mob/player/verb/make_miner()
	for(var/mob/living/dwarf/D in src.loc)
		if(!D.isMiner && !D.isAxeman)
			D.isMiner = 1
			civilians -= D
			miners += D
			D.overlays += "pickaxe"
		else to_chat(usr,"[D.name] already has a job!")

/mob/player/verb/make_axeman()
	for(var/mob/living/dwarf/D in src.loc)
		if(!D.isMiner && !D.isAxeman)
			D.isAxeman = 1
			civilians -= D
			axemans += D
			D.overlays += "axe"
		else to_chat(usr,"[D.name] already has a job!")

/mob/player/verb/possess()
	for(var/mob/living/dwarf/D in src.loc)
		if(!D.key)
			D.key = key
			del src
		else to_chat(usr,"You are being unable to possess this dwarf.")

/mob/living/dwarf
	var/isMiner = 0
	var/isAxeman = 0
	var/atom/target = null
	New()
		icon_state = "dwarf_[pick("1","2","3","4")]"
		population++
		civilians += src

/mob/living/dwarf/verb/release()
	new/mob/player(src.loc)
	for(var/mob/player/P in src.loc) if(!P.key) P.key = key

/turf/water
	icon = 'water.dmi'

/obj/flora/tree
	icon = 'flora.dmi'
	icon_state = "tree"
	density = 1
	New()
		dir = dir4()

/obj/flora/krasnogrib
	icon = 'flora.dmi'
	icon_state = "krasnogrib"

/obj/flora/grass
	icon = 'flora.dmi'
	icon_state = "grass"
	New()
		dir = dir4()

mob
	step_size = 16
	var/speeding = 0
	var/rundelay = 2.5

obj
	step_size = 16

client/Move()
	if(mob.speeding <= 0)
		mob.speeding = 1
		..()
		sleep(mob.rundelay)
		mob.speeding = 0
	else return

mob/Login()
	speeding = 0
	..()
