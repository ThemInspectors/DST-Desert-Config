chestfunctions = require("scenarios/chestfunctions")

local function OnCreate(inst, scenariorunner)

    local loot =
    {
        {
            item = "pickaxe",
            count = 1,
            chance = 0.33
        },
        {
            item = "axe",
            count = 1,
            chance = 0.33
        },
        {
            item = "cutgrass",
            count = 4,
            chance = 1
        },
        {
            item = "twigs",
            count = 6,
            chance = 1
        },
        {
            item = "flint",
            count = 4,
            chance = 1
        },
    }

    chestfunctions.AddChestItems(inst, items)
end

return
{
    OnCreate = OnCreate
}

 
