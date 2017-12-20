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

proc/sDel(var/atom/A)
	for(var/mob/living/dwarf/D in world) if(D.target == src) D.target = null
	if(A in dig_target) dig_target -= A
	del(A)

proc/dir4()
	return pick(NORTH, SOUTH, EAST, WEST)

proc/dir8()
	return pick(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)

/mob/living
	icon = 'mob.dmi'
	var/canMove = 1
	var/canAct = 1

/mob/living/dwarf
	var/isMiner = 0
	var/isAxeman = 0
	var/atom/target = null
	New()
		icon_state = "dwarf_[pick("1","2","3","4")]"
		population++
		civilians += src

/obj/flora/tree
	icon = 'flora.dmi'
	icon_state = "tree"
	density = 1
	New()
		dir = dir4()
	act_by_item(var/mob/living/dwarf/D,var/tool)
		if(tool == "axe")
			msg("[D.name] chops [src] to pieces!")
			if(D.target) D.target = null
			sDel(src)

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
