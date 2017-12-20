/mob/player
	icon = 'mob.dmi'
	icon_state = "player"
	density = 0
	rundelay = 1

var/population

/atom/proc/act_by_item(var/mob/living/H,var/tool)

/mob/player/verb/dwarf()
	for(var/atom/A in loc)
		if(!loc.density && !A.density) new/mob/living/dwarf(src.loc)
		else to_chat(usr,"You can't create a dwarf in here.")

/mob/player/verb/check_target()
	for(var/mob/living/dwarf/D in loc) to_chat(usr,"[D.target.x],[D.target.y]")

/atom/Click(location,control,params,var/mob/living/dwarf/D = usr)
	params = params2list(params)
	if("left" in params)
		if(!istype(D)) return
		if(src in range(1,D))
			if(D.isMiner) act_by_item(D,"pickaxe")
			if(D.isAxeman) act_by_item(D,"axe")

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

//Build mode//
/mob/player/verb/dig()
    for(var/turf/walls/R in src.locs)
        if(!R.build)
            R.build = 1
            R.overlays += "build_mode"
            dig_target.Add(R)
            to_chat(usr,"You mark [R]")
        else
            R.build = 0
            R.overlays -= "build_mode"
            dig_target.Cut(R)
            to_chat(usr,"You demark [R]")
//Build mode end :3//

/mob/player/verb/possess()
	for(var/mob/living/dwarf/D in src.loc)
		if(!D.key)
			D.key = key
			del src
		else to_chat(usr,"You are being unable to possess this dwarf.")

/mob/living/dwarf/verb/release()
	new/mob/player(src.loc)
	for(var/mob/player/P in src.loc) if(!P.key) P.key = key

/mob/player/verb/check()
	to_chat(usr,"[x],[y]")