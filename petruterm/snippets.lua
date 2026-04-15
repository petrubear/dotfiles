local petruterm = require("petruterm")
local module = {}

function module.apply_to_config(config)
	config.snippets = {
		{ name = "Maven clean install", body = "mvn clean install -DskipTests ", trigger = "mci" },
	}
end
return module
