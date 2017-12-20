/turf
	icon = 'turfs.dmi'
	var/build = 0
	var/Overlay/o_mark

/turf/grass
	name = "ground"
	icon_state = "grass"
	New()
		dir = dir8()

/turf/water
	icon = 'water.dmi'

/turf/walls
	density = 1
	opacity = 1
	act_by_item(var/mob/living/dwarf/D,var/tool)
		if(tool == "pickaxe" && D.canAct)
			msg("[D.name] digs up [name]!")
			if(D.target) D.target = null
			D.canAct = 0
			spawn(7) D.canAct = 1
			sDel(src)

/turf/walls/wall
	icon_state = "wall"

/turf/walls/rock
	icon_state = "rock"