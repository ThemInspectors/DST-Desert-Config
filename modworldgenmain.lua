--[=====[ 
 
 Copyright (C) 2017 ThemInspectors

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program. If not, see <http://www.gnu.org/licenses/>.

--]=====]


local require = GLOBAL.require
require("map/lockandkey")
require("map/tasks")
require("map/rooms")
require("map/terrain")
require("map/level")

local blockersets = require("map/blockersets")

local LOCKS = GLOBAL.LOCKS
local KEYS = GLOBAL.KEYS

local GROUND = GLOBAL.GROUND
local LEVELTYPE = GLOBAL.LEVELTYPE

AddTaskSetPreInitAny(function(tasksetdata)
	print("Starting Worldgen...")
		if tasksetdata.location ~= "forest" then
			return
		end

	GLOBAL.dumptable(tasksetdata)
end)


--Tasksets!
AddTaskSet("desertonly", {
		name = Desert!,
        location = "forest",
		tasks = {
			"Make a pick", --Starting, Important
		--	"Dig that rock", --Rocky area, maybe used.
		--	"Great Plains",
		--	"Squeltch",
		--	"Beeeees!",
		--	"Speak to the king",
		--	"Forest hunters",
			"Badlands", -- Desert, important
		--	"For a nice walk",
			"Lightning Bluff", -- Derset, Important
		},
		numoptionaltasks = 5,
		optionaltasks = {
--			"Befriend the pigs",
--			"Kill the spiders",
--			"Killer bees!",
--			"Make a Beehat",
--			"The hunters",
--			"Magic meadow",
--			"Frogs and bugs",
--			"Mole Colony Deciduous",
--			"Mole Colony Rocks",
--			"MooseBreedingTask", 
		},
        valid_start_tasks = {
            "Make a pick",
        },
--[=====[
		set_pieces = { 
			["ResurrectionStone"] = { count = 2, tasks={"Make a pick", "Dig that rock", "Great Plains", "Squeltch", "Beeeees!", "Speak to the king", "Forest hunters", "Badlands" } },
			["WormholeGrass"] = { count = 16, tasks={"Make a pick", "Dig that rock", "Great Plains", "Squeltch", "Beeeees!", "Speak to the king", "Forest hunters", "Befriend the pigs", "For a nice walk", "Kill the spiders", "Killer bees!", "Make a Beehat", "The hunters", "Magic meadow", "Frogs and bugs", "Badlands"} },
			["MooseNest"] = { count = 9, tasks={"Make a pick", "Beeeees!", "Speak to the king", "Forest hunters", "Befriend the pigs", "For a nice walk", "Make a Beehat", "Magic meadow", "Frogs and bugs"} },
			["CaveEntrance"] = { count = 10, tasks={"Make a pick"} }, 
		},

	})
--]=====] -- Later.


















--[=====[ 
AddTaskSet("moarbananas", { -- ID of Task Set, not shown to the user
		name = More Bananas, -- Name of Task Set, shown to the user in world generation options under Worldgen:Biomes 
        location = "forest", --location area of biomes, either "caves" or "forest"
		tasks = { -- list of Forest Tasks forced to spawn. The caves ones are in the in DST files under data/scripts/map/tasksets/caves.lua
			"Make a pick", -- starting area
			"Dig that rock", -- quarry
			"Great Plains", -- ???
			"Squeltch", -- swamp
			"Beeeees!", -- beequeen area
			"Speak to the king", -- self-explainatory
			"Forest hunters", -- MacTusk camp in a forest
			"Badlands", -- DFly Desert
			"For a nice walk", -- odd
			"Lightning Bluff", -- Antlion Desert
		},
		numoptionaltasks = 5,
		optionaltasks = {
			"Befriend the pigs", -- Pig Village?
			"Kill the spiders", -- uhhh?
			"Killer bees!", -- KB field?
			"Make a Beehat", -- ???
			"The hunters", -- triple mactusk area; Rockyland w/ tallbirds, grassland and savanna
			"Magic meadow", -- ???
			"Frogs and bugs", -- ???
			"Mole Colony Deciduous", -- ???
			"Mole Colony Rocks", -- ???
			"MooseBreedingTask", area with lotso moose nests
		},
        valid_start_tasks = {
            "Make a pick",
        },
		set_pieces = { --set pieces
			["ResurrectionStone"] = { count = 2, tasks={"Make a pick", "Dig that rock", "Great Plains", "Squeltch", "Beeeees!", "Speak to the king", "Forest hunters", "Badlands" } },
			["WormholeGrass"] = { count = 16, tasks={"Make a pick", "Dig that rock", "Great Plains", "Squeltch", "Beeeees!", "Speak to the king", "Forest hunters", "Befriend the pigs", "For a nice walk", "Kill the spiders", "Killer bees!", "Make a Beehat", "The hunters", "Magic meadow", "Frogs and bugs", "Badlands"} },
			["MooseNest"] = { count = 9, tasks={"Make a pick", "Beeeees!", "Speak to the king", "Forest hunters", "Befriend the pigs", "For a nice walk", "Make a Beehat", "Magic meadow", "Frogs and bugs"} },
			["CaveEntrance"] = { count = 10, tasks={"Make a pick"} }, 
		},

	})

--AddTask("Banana Jungle",	{	locks={  }, --Locks go here    
					keys_given={  }, --keys go here | used to link some Tasks together    
						room_choices =
							{
								["BG_BANANA_LAND"] = 2,
								["BananaKingdom"] = 1,-							},
						room_bg=GROUND.BRICK,
						background_room="BG_BANANA_LAND", -- background 
						colour={r=0,g=0,b=0,a=0}, copy the colour from a related biome in the game's files XD
					}
	)

AddRoom("BG_BANANA_LAND",	{
			colour={r=0.3,g=0.2,b=0.1,a=0.3}, --copy colour
			value = GROUND.BANANA, --copy value (whatever it means)
			contents =	{
					distributepercent = 0.15, -- how much combined terrain should be covered with prefabs, percent in decimal
						distributeprefabs =
							{
								cave_banana_tree = 0.45, --prefab, percent in decimals
							}
					}
				}
	)




--]=====]
