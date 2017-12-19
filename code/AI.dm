var/list/miners = list()
var/list/axemans = list()
var/list/civilians = list()

proc/mob_controller()
	for(var/mob/living/dwarf/D in world) if(!D.key) spawn() D.AI()
	spawn(10) mob_controller()

/////MINERS*start*/////
/mob/living/dwarf/proc/minerThoughts()
	if(!target)
		step_rand(src)
		for(var/turf/walls/rock/R in orange(1,src))
			getTarget(R)
	else
		if(get_dist(src, target)>1) step_to(src,target,0)
		else mine(target)

/mob/living/dwarf/proc/mine(var/turf/Target)
	msg("[src.name] digs up [Target]!")
	target = null
	del(Target)
/////MINERS*end*/////

/////AXEMANS*start*/////
/mob/living/dwarf/proc/axemanThoughts()
	if(!target)
		step_rand(src)
		for(var/obj/flora/tree/T in range(3,src))
			getTarget(T)
	else
		if(get_dist(src, target)>1) step_to(src,target,0)
		else chop(target)

/mob/living/dwarf/proc/chop(var/obj/Target)
	msg("[src.name] chops [Target] to pieces!")
	target = null
	del(Target)
/////AXEMANS*end*/////

/mob/living/dwarf/proc/civilianThoughts()
	step_rand(src)

/mob/living/dwarf/proc/getTarget(var/atom/newTarget)
	target = newTarget

/mob/living/dwarf/proc/AI()
	if(src in miners) if(isMiner) spawn() minerThoughts()
	if(src in axemans) if(isAxeman) spawn() axemanThoughts()
	if(src in civilians) spawn() civilianThoughts()