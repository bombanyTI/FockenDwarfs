#define VOR_REGION_ICON 'grass.dmi'
#define VOR_BORDER_ICON 'dirt.dmi'
#define VOR_WATER_ICON 'water.dmi'

var
	vorResX
	vorResY
	vorSkipProb
	vorRegionCount
	vorMinimumDistance
	list
		vorRegions = list()
		vorCardinalDirs = list(1, 2, 4, 8)
		vorAllDirs = list(1, 2, 4, 8, 5, 6, 10, 9)
		vorAdjacentRegions = list()

/area/vorRegion/var/list/expandable = list()

/area/proc/SetTurf(G) for(var/turf/T in contents) if(!T.density) new G(T)

proc
	vorSetGridResolution(resX, resY)
		vorResX = resX
		vorResY = resY

	vorSetSkipProbability(skipProb)
		vorSkipProb = skipProb

	vorSetMinimumDistance(myDist)
		vorMinimumDistance = myDist

	vorSetRegionCount(myCount)
		vorRegionCount = myCount

	vorBuildLand()
		var
			curx; cury
		for(var/i in 1 to vorRegionCount)
			while(1)
				curx = rand(1, world.maxx)
				cury = rand(1, world.maxy)
				var/turf/T = locate(curx, cury, 1)
				var/bad = 0
				for(var/turf/neighbor in oview(T, vorMinimumDistance - 1))
					if(istype(neighbor.loc, /area/vorRegion))
						bad = 1
						break
				if(!bad)
					vorCreateRegion(T)
					break
	vorBuildGrid()
		var
			curx; cury
		for(curx = round(vorResX / 2); curx <= world.maxx; curx += vorResX)
			for(cury = round(vorResY / 2); cury <= world.maxy; cury += vorResY)
				var/turf/T = locate(curx, cury, 1)
				if(!prob(vorSkipProb)) vorCreateRegion(T)

	vorCreateRegion(turf/T)
		var/area/vorRegion/A = new()
		A.contents += T
		vorRegions += A
		A.SetTurf(/turf/grass)

	vorExpandRegions()
		var/expanded = 1
		var/iExpanded
		var/list/growable = vorRegions.Copy()
		for(var/area/vorRegion/R in growable) R.expandable = R.contents.Copy()
		while(expanded)
			expanded = 0
			for(var/area/vorRegion/R in growable)
				iExpanded = 0
				var/list/newExpandable = list()
				for(var/turf/T in R.expandable)
					var/turfExpanded = 0
					for(var/turf/neighbor in vorGetNeighbors(T, vorAllDirs))
						if(!istype(neighbor.loc, /area/vorRegion))
							expanded = 1
							iExpanded = 1
							turfExpanded = 1
							R.contents += neighbor
							newExpandable += neighbor
							R.SetTurf(/turf/grass)
					if(!turfExpanded) R.expandable -= T
				if(!iExpanded) growable -= R
				else R.expandable += newExpandable

	vorOutlineRegions(drawOutline)
		for(var/area/vorRegion/R in world) vorAdjacentRegions[R] = list()
		for(var/turf/T in world)
			for(var/turf/neighbor in vorGetNeighbors(T, vorAllDirs))
				if(neighbor.loc != T.loc && !T.density)
					if(drawOutline) T.icon = VOR_BORDER_ICON
					if(!(neighbor.loc in vorAdjacentRegions[T.loc])) vorAdjacentRegions[T.loc] += neighbor.loc

	vorGetNeighbors(turf/T, dirlist)
		var/list/L = list()
		for(var/curDir in dirlist)
			var/turf/neighbor = get_step(T, curDir)
			if(neighbor) L += neighbor
		return L

	vorCreateLake(maxsize)
		var/list/allRegions = list()
		for(var/area/vorRegion/R in world) allRegions += R
		var/area/vorRegion/R = pick(allRegions)
		R.SetTurf(/turf/water)
		for(var/i in 2 to maxsize)
			R = pick(vorAdjacentRegions[R])
			R.SetTurf(/turf/water)

	vorCreateMountain(maxsize)
		var/list/allRegions = list()
		for(var/area/vorRegion/R in world) allRegions += R
		var/area/vorRegion/R = pick(allRegions)
		R.SetTurf(/turf/walls/rock)
		for(var/i in 2 to maxsize)
			R = pick(vorAdjacentRegions[R])
			R.SetTurf(/turf/walls/rock)
