local petruterm = require("petruterm")
local module = {}

function module.apply_to_config(config)
	config.snippets = {
		{ name = "Maven clean install",  body = "mvn clean install -DskipTests ",              trigger = "mci" },

		-- Version control
		{ name = "git log graph",        body = "git log --oneline --graph --decorate --all",  trigger = "gla" },
		{ name = "git status short",     body = "git status -s",                               trigger = "gss" },
		{ name = "git diff staged",      body = "git diff --cached",                           trigger = "gds" },

		-- Docker
		{ name = "docker run shell",     body = "docker run -it --rm ",                        trigger = "dkr" },
		{ name = "docker ps all",        body = "docker ps -a",                                trigger = "dpa" },
		{ name = "docker compose up",    body = "docker compose up -d",                        trigger = "dcu" },

		-- Kubernetes
		{ name = "kubectl get pods",     body = "kubectl get pods -A",                         trigger = "kgp" },
		{ name = "kubectl logs follow",  body = "kubectl logs -f ",                            trigger = "klf" },

		-- Processes
		{ name = "ps grep",              body = "ps aux | grep -v grep | grep ",               trigger = "psg" },
	}
end
return module
