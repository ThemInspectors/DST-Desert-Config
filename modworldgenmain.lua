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
require("map/startlocations")

local blockersets = require("map/blockersets")

local LOCKS = GLOBAL.LOCKS
local KEYS = GLOBAL.KEYS

local GROUND = GLOBAL.GROUND
local LEVELTYPE = GLOBAL.LEVELTYPE

local Layouts = GLOBAL.require("map/layouts").Layouts
local StaticLayout = GLOBAL.require("map/static_layout")


Layouts["desert_start"] = StaticLayout.Get("map/static_layouts/desert_start")

local randomDesertTasks = {
  "",
}

AddRoomPreInit("PondyGrass", function(room) room.contents.distributeprefabs.pond = 0.05 end)

local function removeTasks(taskset,name)
  for index,key in ipairs(taskset.tasks) do
    if key == name then
      table.remove(taskset.tasks, index)
      print("DST-Desert-Config: Removed task: "..name)
      break
    end
  end
end
local function addDesertTasks(taskset)
  if taskset.location ~= "forest" then return end --early return for caves
  if GetModConfigData("desutil") then
      print("DST-Desert-Config: Desert Utility: Enabled")
      table.insert(taskset.tasks, "Desert King")
--      table.insert(taskset.tasks, "Moon Oasis") -- Is crashing
      if GetModConfigData ("remdupe") then
        print("DST-Desert-Config: Remove Dupelicates: Enabled")
        removeTasks(taskset, "Speak to the king")
        removeTasks(taskset, "Forest hunters")
      end
  end
  if GetModConfigData("desopt") > 0 then
    for i = math.random(1, #randomDesertTasks), GetModConfigData("desopt") do
      table.insert(level.tasks, randomDesertTasks[i])
      table.remove(randomDesertTasks, i)
    end
  end
end

AddTaskSetPreInitAny(addDesertTasks)
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
AddTask("Moon Oasis",  {
    locks={ LOCKS.ROCKS, LOCKS.TIER3 },
    keys_given={ KEYS.GOLD, KEYS.TEIR4, KEYS.SPIDERS, KEYS.CHESSMEN, KEYS.WALRUS, KEYS.TEIR5}, -- Future Release?
    room_choices = {
        ["Moon Magic"] = 1,
        ["BGBadlands"] = 2,
    },
    room_bg=GROUND.DIRT,
    background_room="BGBadlands",
    colour={r=1,g=1,b=0,a=1}
    }
)

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

AddTask("Desert King", {
    locks = {LOCKS.TIER3, LOCKS.SPIDERS_DEFEATED, LOCKS.PIGGIFTS}, -- set it to none because of crashing ):
    keys_given = {KEYS.TEIR4}, -- set it to none because of crashing ):
    entrance_room=blockersets.pigs_hard,
    entrance_room_chance=0.75,
    room_choices = {
        ["PigCity"] = 1,
        ["BGBadlands"] = 1,
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

AddRoom("Moon Magic", {
    colour ={r=0,g=.9,b=0,a=.50},
    value = GROUND.DECIDUOUS,
    contents = {
        countstaticlayouts={
          ["MoonbaseOne"]=1,
          ["MagicalDeciduous"] = 1,
        },
        distributepercent = 0.3,
        distributeprefabs = {
          grass = .03,
          sapling=1,
          twiggytree=0.4,
          berrybush=1,
          berrybush_juicy = 0.05,
          red_mushroom = 2,
          blue_mushroom = 2,
          green_mushroom = 2,

          fireflies = 4,
          flower=5,

          molehill = 2,
          catcoonden = .25,

          berrybush = 3,
          berrybush_juicy = 1.5,
      },
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
