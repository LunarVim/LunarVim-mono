local base_dir = vim.env.LUNARVIM_BASE_DIR

vim.opt.rtp:append(base_dir)

require("lvim.bootstrap"):init(base_dir)

local repos = vim.tbl_map(function(plugin)
	local url = string.format("https://github.com/%s.git", plugin[1])
	return { url = url, commit = plugin.commit }
end, require("lvim.plugins"))

vim.pretty_print(repos)

vim.cmd("quitall")
