local module = {}

function module.apply_to_config(config)
	config.notifications = { style = "native" }
	-- petruterm.on("tab_created", function()
	-- petruterm.notify("New tab opened", 2000)
	-- end)

	-- petruterm.on("ai_response", function()
	-- petruterm.notify("AI done ✓")
	-- end)
end
return module
