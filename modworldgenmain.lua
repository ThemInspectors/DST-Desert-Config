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
 along with this program. If not, see <http://w...content-available-to-author-only...u.org/licenses/>.

--]=====]


local require = GLOBAL.require
require("map/lockandkey")
require("map/tasks")
require("map/rooms")
require("map/terrain")
require("map/level")
require("map/startlocations")

local blockersets = require("map/blockersets")

local LOCKS = GLOBAL.LOCKS
local KEYS = GLOBAL.KEYS

local GROUND = GLOBAL.GROUND
local LEVELTYPE = GLOBAL.LEVELTYPE

local Layouts = GLOBAL.require("map/layouts").Layouts
local StaticLayout = GLOBAL.require("map/static_layout")


Layouts["desert_start"] = StaticLayout.Get("map/static_layouts/desert_start")

AddTaskSetPreInitAny(function(tasksetdata)
    GLOBAL.dumptable(tasksetdata)
end)

AddRoomPreInit("PondyGrass", function(room) room.contents.distributeprefabs.pond = 0.05 end)

-- Custom Tasks, Rooms, Tasksets, starting areas and alot of things.

--Tasksets!
AddTaskSet("desertonly", {
    name = "Desert-Only",
    location = "forest",
    tasks = {
        "Desert Start",
        "Badlands", -- Desert, important
        "Lightning Bluff", -- Derset, Important
        "Oasis", -- A cool desert addition
        "Quarrelious Desert", -- custom Desert Area
        "Don't Speak to the King!"
    },
--    numoptionaltasks = 0,
--    optionaltasks = {},
    valid_start_tasks = {
        "Desert Start"
    },

set_pieces = { --set pieces
    ["ResurrectionStone"] = { count = 2, tasks={ "Badlands", "Oasis", "Desert Start", "Lightning Bluff", "Quarrelious Desert" } },
    ["WormholeGrass"] = { count = 8, tasks={"Badlands", "Oasis", "Desert Start", "Lightning Bluff", "Quarrelious Desert"} },
--    ["MooseNest"] = { count = 9, tasks={"Make a pick", "Beeeees!", "Speak to the king", "Forest hunters", "Befriend the pigs", "For a nice walk", "Make a Beehat", "Magic meadow", "Frogs and bugs"} },
    ["CaveEntrance"] = { count = 10, tasks={"Badlands", "Oasis", "Desert Start", "Lightning Bluff", "Quarrelious Desert"} },
    },
})

-- Tasks
AddTask("Quarrelious Desert",  {
    locks={ LOCKS.ROCKS, LOCKS.TIER3 },
    keys_given={ KEYS.GOLD, KEYS.TEIR4, KEYS.SPIDERS, KEYS.CHESSMEN, KEYS.WALRUS, KEYS.TEIR5}, -- Future Release?
    room_choices = {
        ["ChessArea"] = 1,
        ["WalrusHut_Desert"] = 2,
        ["SpiderVillageDesert"] = 1
    },
    room_bg=GROUND.DIRT,
    background_room="BGBadlands",
    colour={r=1,g=1,b=0,a=1}
    }
)

AddTask("Desert Start",  {
    locks = { LOCKS.NONE },
    keys_given={ KEYS.TEIR2, KEYS.GOLD, KEYS.PICKAXE, KEYS.AXE },
    room_choices = {
        ["Rocky"] = 1,
        ["BGBadlands"] = 1,
    },
    room_bg=GROUND.DIRT,
    background_room="BGBadlands",
    colour={r=1,g=0.6,b=1,a=1}
})

AddTask("Don't Speak to the King!", {
    locks = {LOCKS.NONE}, -- set it to none because of crashing ):
    keys_given = {KEYS.NONE}, -- set it to none because of crashing ):
    entrance_room=blockersets.pigs_hard,
    room_choices = {
        ["PigCity"] = 1,
    },
    room_bg=GROUND.GRASS,
    background_room="BGBadlands",
		colour={r=0,g=1,b=0.3,a=1}
})
-- rooms


AddRoom("SpiderVillageDesert", {
    colour={r=.30,g=.20,b=.50,a=.50},
    value = GROUND.DIRT_NOISE,
    contents =  {
        countprefabs= {
            goldnugget = function() return 3 + math.random(3) end,
            spiderden = function () return 5 + math.random(3) end
            },
        distributepercent = 0.1,
        distributeprefabs = {
            rock1 = 1,
            rock2 = 1,
            rocks = 1,
        },
        prefabdata = {
            spiderden = function() if math.random() < 0.2 then
                return { growable={stage=2}}
                    else
                        return { growable={stage=1}}
                    end
                end,
        },
    }
})

AddRoom("WalrusHut_Desert", {
    colour ={r=0.3,g=0.2,b=0.1,a=0.3},
    value = GROUND.DIRT_NOISE,
    contents = {
        countprefabs = {
            walrus_camp = 1
        },
        distributepercent = 0.07,
        distributeprefabs = {
            marsh_bush = 0.05,
            marsh_tree = 0.2,
            rock_flintless = 1,
            grass = 0.1,
            grassgekko = 0.4,
            houndbone = 0.2,
            cactus = 0.2,
            tumbleweedspawner = .05,
        }
    }
})

-- Custom desert start location with chest
AddStartLocation("desertstart", {
    name = "Desert",
    location = "forest",
    start_setpeice = "desert_start",
    start_node = {"BGBadlands"}
})

-- Custom desert preset with
AddLevel(LEVELTYPE.SURVIVAL, {
    id = "DESERTONLY",
    name = "Desert-Only",
    desc = "Desert-Only Challenge!",
    location = "forest",
    version = 2,
    overrides = {
        task_set = "desertonly",
        start_location = "desertstart",
        roads = "never",
        ordered_story_setpieces = {
            "Sculptures_1",
            "Maxwell5",
        },
        numrandom_set_pieces = 4,
        random_set_pieces = {
            "Sculptures_2",
            "Sculptures_3",
            "Sculptures_4",
            "Sculptures_5",
            "Chessy_1",
            "Chessy_2",
            "Chessy_3",
            "Chessy_4",
            "Chessy_5",
            "Chessy_6",
            "Maxwell1",
            "Maxwell2",
            "Maxwell3",
            "Maxwell4",
            "Maxwell6",
            "Maxwell7",
            "Warzone_1",
            "Warzone_2",
            "Warzone_3",
        },
    },
})
-- Templates.
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
      "MooseBreedingTask", -- area with lotso moose nests
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

AddTask("Banana Jungle",  {
      locks={  }, --Locks go here
      keys_given={  }, --keys go here | used to link some Tasks together
      entrance_room_chance=0.5,
      entrance_room="",
      room_choices =
              {
                ["BG_BANANA_LAND"] = 2,
                ["BananaKingdom"] = 1,-              },
            room_bg=GROUND.BRICK,
            background_room="BG_BANANA_LAND", -- background
            colour={r=0,g=0,b=0,a=0}, copy the colour from a related biome in the game's files XD
          }
  )

AddRoom("BG_BANANA_LAND",  {
      tags = {}, -- Tags for marking during worldgen, for example, road poison or chester eyeybone
      contents =  {
                      distributepercent = .2,
                      distributeprefabs=
                      {
                        deciduoustree=6,

                    pighouse=1,

                          },
                      }
          })
--]=====]
