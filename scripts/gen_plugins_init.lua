local base_dir = vim.env.LUNARVIM_BASE_DIR

vim.opt.rtp:append(base_dir)

require("lvim.bootstrap"):init(base_dir)

local opt_keys = require("packer.compile").opt_keys
local plugin_dir = join_paths(vim.env.CMAKE_BINARY_DIR, "plugins")

local function get_destination(plugin)
	local function is_optional()
		for _, key in ipairs(opt_keys) do
			if plugin[key] ~= nil then
				return true
			end
		end

		return false
	end

	local name = require("packer.util").get_plugin_short_name(plugin)

	return join_paths(plugin_dir, is_optional() and "opt" or "start", name)
end

local plugins = require("lvim.plugins")

print("installing " .. #plugins, " plugins...")

for i, plugin in ipairs(plugins) do
	local url = string.format("https://github.com/%s.git", plugin[1])
	local destination = get_destination(plugin)
	print(string.format("[%d/%d] %s -> %s", i, #plugins, plugin[1], destination))

	local clone_cmd = { "git", "clone", url, destination }
	local checkout_cmd = string.format("cd %s && git checkout --detach %s", destination, plugin.commit)
	print(vim.fn.system(clone_cmd))
	print(vim.fn.system(checkout_cmd))
end

vim.cmd("quitall")
