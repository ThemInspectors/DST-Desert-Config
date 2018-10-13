name = "Desert Enhancement"
description = "Enhance your deserts, Config is here!"

author = "ThemInspectors"
version = "2.0"
forumthread = ""
api_version = 10

icon_atlas = "modicon.xml"
icon = "modicon.tex"
all_clients_require_mod = false
client_only_mod = false
dst_compatible = true
server_filter_tags = {}

configuration_options = {
  {
		name = "desutil",
		label = "Utility Deserts",
			hover = "Spawn Deserts such as the \"Magical\", \"Bee\" and \"Pig King\" Deserts?",
		options =	{
						{description = "Disabled", data = false, hover = "Doesn't Spawn Utility Deserts!"},
            {description = "Enabled", data = true, hover = "Spawns Utility Deserts!"},
					},
		default = false,
	},
  {
    name = "remdupe",
    label = "Remove Duplicates",
      hover = "Removes duplicate Utility Biomes if Utility Deserts are enabled.",
      options =	{
              {description = "Disabled", data = false, hover = "Keeps Utility Biomes!"},
              {description = "Enabled", data = true, hover = "Removes Utility Biomes!"},
            },
    default = true,
  },

  {
  name = "desopt",
  label = "Optional Deserts",
    --hover = "How many optional deserts to spawn.\ncurrently only works for Desert-Only Worlds.",
    hover = "Coming soon.",
  options = {
        {description = "Blocked", data = false, hover = "Coming soon!"},
      --{description = "None", data = false, hover = "No Optional Deserts will spawn."},
      --{description = "1", data = 1, hover = "Spawns 1 Optional Desert!"},
      --{description = "2", data = 2, hover = "Spawns 2 Optional Deserts!"},
      --{description = "3", data = 3, hover = "Spawns 3 Optional Deserts!"},
    },
  default = false,
  },
}
