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
Layouts["Desert-Config-Graveyard"] = StaticLayout.Get("map/static_layouts/dev_graveyard")

local randomDesertTasks = {
  "Desert Graveyard",
  "The Runoff",
  "The Drylands",
--  "Placeholder.",
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
      table.insert(taskset.tasks, "Moon Oasis")
      table.insert(taskset.tasks, "Bee Bungaloo")
      if GetModConfigData ("remdupe") then
        print("DST-Desert-Config: Remove Dupelicates: Enabled")
        removeTasks(taskset, "Speak to the king")
        removeTasks(taskset, "Forest hunters")
        removeTasks(taskset, "Beeeees!")
      end
  end
  --[=[
  if GetModConfigData("desopt") then
    local i = 1
    while( i == GetModConfigData("desopt") ) do
        local k = math.random(1, #randomDesertTasks)
        table.insert(taskset.tasks, randomDesertTasks[k])
        table.remove(randomDesertTasks, k)
        print(randomDesertTasks[k])
        i = i + 1
      end
  end
  --]=]
end
-- Adventure Mode Hook



--local WORLDS = GLOBAL.TUNING.TELEPORTATOMOD.WORLDS

--GLOBAL.TUNING.TELEPORTATOMOD.teleportato_layouts["forest"]=nil,

local function DesertOnly(tasksetdata) -- DesertOnly
    tasksetdata.numoptionaltasks = 0
    tasksetdata.tasks = {"Desert Start","Desert King","Badlands","Lightning Bluff", "Oasis", "Quarrelious Desert"}
    tasksetdata.optionaltasks = {}
    tasksetdata.set_pieces = {
            ["ResurrectionStoneWinter"] = { count=1, tasks={"Desert Start","Desert King","Badlands","Lightning Bluff", "Oasis", "Quarrelious Desert"}},
    }
    tasksetdata.required_setpieces = {}
    tasksetdata.numrandom_set_pieces = 0
    if not tasksetdata.required_setpieces then
        tasksetdata.required_setpieces = {}
    end
    --[==[
    for _,set in pairs(GLOBAL.TUNING.TELEPORTATOMOD.teleportato_layouts["forest"]) do
        table.insert(tasksetdata.required_setpieces,set)
    end
    --]==]
    tasksetdata.random_set_pieces = {}
    tasksetdata.add_teleportato = true -- add teleportato within teleportato mod. ypu can set up _G.TUNING.TELEPORTATOMOD.teleportato_layouts to change the setpieces of them
    tasksetdata.required_prefabs = GLOBAL.ArrayUnion(required_prefabs,{"teleportato_base","teleportato_box","teleportato_crank","teleportato_ring","teleportato_potato"}) -- if ordered_story_setpieces is nil/empty, required_prefabs is set up in teleoprtato mod depending in settings there
    tasksetdata.overrides={
        wormhole_prefab = "wormhole",
        layout_mode = "LinkNodesByKeys",
        start_location = "desertstart",
        roads = "never"
    }
    return tasksetdata
end

if GLOBAL.TUNING.TELEPORTATOMOD then
    if not GLOBAL.TUNING.TELEPORTATOMOD.WORLDS then
        GLOBAL.TUNING.TELEPORTATOMOD.WORLDS = {}
    end
    table.insert(GLOBAL.TUNING.TELEPORTATOMOD.WORLDS, {name="The Badlands", taskdatafunctions={forest=DesertOnly, cave=AlwaysTinyCave}, defaultpositions={2,3,4,5},positions="2,3,4,5"})
    print("Desert Config is hooking into adveture mode")
else
    print("Desert Config is not hooking into adveture mode")
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
        "Desert Start",
        --"Desert Graveyard"
    },

set_pieces = { --set pieces
    ["ResurrectionStone"] = { count = 2, tasks={ "Badlands", "Oasis", "Desert Start", "Lightning Bluff", "Quarrelious Desert" } },
    ["WormholeGrass"] = { count = 8, tasks={"Badlands", "Oasis", "Desert Start", "Lightning Bluff", "Quarrelious Desert"} },
    ["MooseNest"] = { count = 2, tasks={"Moon Oasis", "Desert King", "Bee Bungaloo", "Desert Graveyard", "The Drylands", "The Runoff", "Oasis", "Lightning Bluff"} },
    ["CaveEntrance"] = { count = 10, tasks={"Badlands", "Oasis", "Desert Start", "Lightning Bluff", "Quarrelious Desert", "Desert King", "Moon Oasis", "Bee Bungaloo"} },
    },
})

-- Tasks
AddTask("Moon Oasis",  {
  locks={ LOCKS.TIER2, LOCKS.BASIC_COMBAT},
  keys_given={KEYS.BEEHAT, KEYS.TIER3},-- Future Release?
    room_choices = {
        ["Moon Magic"] = 1,
        ["BGBadlands"] = 2,
    },
    room_bg=GROUND.DIRT,
    background_room="BGBadlands",
    colour={r=1,g=1,b=0,a=1}
    }
)

AddTask("The Runoff", {
  locks={LOCKS.TIER4},
  keys_given={KEYS.MERMS},
  room_choices = {
    ["SlightlyMermySwamp"] = 1,
    ["BGBadlands"]= 2,
  },
  room_bg=GROUND.MARSH,
  background_room="BGBadlands",
  colour={r=1,g=1,b=0,a=1}
})

AddTask("The Drylands", {
  locks={LOCKS.TIER2},
  keys_given={KEYS.NONE},
  room_choices = {
		["BGSavanna"] = 1,
    ["BGBadlands"]= 2,
  },
  room_bg=GROUND.DIRT,
  background_room="BGBadlands",
  colour={r=1,g=1,b=0,a=1}
})

AddTask("Bee Bungaloo", {
  locks={LOCKS.TIER3, LOCKS.KILLERBEES, LOCKS.BEEHIVE},
  keys_given={KEYS.TIER4, KEYS.HONEY},
  room_choices = {
    ["Bee Oasis"] = 1,
    ["BGBadlands"]= 2,
  },
  room_bg=GROUND.DIRT,
  background_room="BGBadlands",
  colour={r=1,g=1,b=0,a=1}
})

AddTask("Quarrelious Desert",  {
    locks={ LOCKS.ROCKS, LOCKS.TIER3 },
    keys_given={ KEYS.GOLD, KEYS.TIER4, KEYS.SPIDERS, KEYS.CHESSMEN, KEYS.WALRUS, KEYS.TIER5}, -- Future Release?
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
    keys_given={ KEYS.TIER2, KEYS.GOLD, KEYS.PICKAXE, KEYS.AXE },
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
    keys_given = {KEYS.TIER4, KEYS.PIGS}, -- set it to none because of crashing ):
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
AddTask("Desert Graveyard", {
    locks={LOCKS.INNERTIER},
    keysGLOBALiven={KEYS.GOLD},
    room_choices= {
        ["MandrakeGraveyard"] = 1,
        ["BGBadlands"] = 2,
    },
    room_bg=GROUND.DIRT,
    background_room="BGBadlands",
    colour={r=0,g=1,b=0.3,a=1}
})
-- rooms
AddRoom("MandrakeGraveyard", {
  colour={r=.010,g=.010,b=.10,a=.50},
  value = GROUND.FOREST,
  tags = {"Town", "Mist"},
  contents =  {
    countstaticlayouts = {
      ["InsanePighouse"]= function() if math.random(100) > 85 then
          return 1
        else
          return 0
        end
      end,
      ["Desert-Config-Graveyard"]= function() if math.random(100) > 85 then
          return 1
        else
          return 0
        end
      end,
    },
    countprefabs= {
      evergreen = 5,
      goldnugget = function() return math.random(5) end,
      gravestone = function () return 5 + math.random(4) end,
      mound = function () return 5 + math.random(4) end,
      mandrake_planted = 3,
    }
  }
})

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
AddRoom("Bee Oasis", {
  colour ={r=0,g=.9,b=0,a=.50},
  value = GROUND.DECIDUOUS,
  contents = {
      countprefabs={
        beequeenhive=1,
        beehive = 3,
        wasphive = 5,
      },
      distributepercent = 0.7,
      distributeprefabs = {
        grass = 0.3,
        sapling=0.1,
        twiggytree=0.4,
        berrybush=0.3,
        berrybush_juicy = 0.05,
        red_mushroom = 0.07,
        blue_mushroom = 0.07,
        green_mushroom = 0.07,

        fireflies = 0.3,
        flower=5,
        beehive = 0.7,
        wasphive = 0.7,
        molehill = 0.25,
    },
  }
})
AddRoom("Moon Magic", {
    colour ={r=0,g=.9,b=0,a=.50},
    value = GROUND.DECIDUOUS,
    contents = {
        countstaticlayouts={
          ["MoonbaseOne"]=1,
          ["DeciduousPond"] = 1,
        },
        countprefabs = {
          critterlab = 1,
        },
        distributepercent = 0.2,
        distributeprefabs = {
          grass = .03,
          sapling=1,
          twiggytree=0.4,
          berrybush=0.3,
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
