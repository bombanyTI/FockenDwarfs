var/list/miners = list()
var/list/axemans = list()
var/list/civilians = list()
var/list/dig_target = list(0)

proc/mob_controller()
	for(var/mob/living/dwarf/D in world) if(!D.key) spawn() D.AI()
	spawn(10) mob_controller()

/////MINERS*start*/////
/mob/living/dwarf/proc/minerThoughts()
	if(!target)
		step_rand(src)
		getTarget()
	else
		checkPath(target)
		if(get_dist(src, target)>1) step_to(src,target,0)
		else
			if(target in dig_target) target.act_by_item(src,"pickaxe")

/mob/living/dwarf/proc/checkPath(var/atom/Target)
	for(var/turf/walls/rock/R in orange(1,src)) if(R in dig_target) R.act_by_item(src,"pickaxe")
/////MINERS*end*/////

/////AXEMANS*start*/////
/mob/living/dwarf/proc/axemanThoughts()
	if(!target)
		step_rand(src)
		for(var/obj/flora/tree/T in range(3,src)) getTarget(T)
	else
		if(get_dist(src, target)>1) step_to(src,target,0)
		else target.act_by_item(src,"axe")
/////AXEMANS*end*/////

/mob/living/dwarf/proc/civilianThoughts()
	step_rand(src)

/mob/living/dwarf/proc/getTarget(var/atom/newTarget)
	if(isMiner)
		if(dig_target == 0) target = newTarget
		else
			if(dig_target != 0) target = pick(dig_target)
	else target = newTarget

proc/get_turf(atom/movable/AM)
    if(istype(AM)) return locate(/turf) in AM.locs
    else if(isturf(AM)) return AM

/mob/living/dwarf/proc/AI()
	if(src in miners) if(isMiner) spawn() minerThoughts()
	if(src in axemans) if(isAxeman) spawn() axemanThoughts()
	if(src in civilians) spawn() civilianThoughts()