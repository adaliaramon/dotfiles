require("packer").startup(function(use)
        use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
        use "adaliaramon/copilot.vim"
        use "nvim-lualine/lualine.nvim"
end)

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.o.clipboard = 'unnamedplus'
vim.o.expandtab = true
vim.o.laststatus = 2
vim.o.number = true
vim.o.spell = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.swapfile = false
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.termguicolors = true
vim.o.undofile = true
vim.o.wildmode = 'longest,list,full'

-- Highlight trailing whitespace
vim.cmd("match TrailingWhitespace /\\s\\+$/")
vim.cmd("highlight TrailingWhitespace ctermbg=red guibg=red")

vim.cmd("highlight StatusLine cterm=None gui=None")
vim.cmd("highlight StatusLineNC cterm=None gui=None")

require("nvim-treesitter.configs").setup {
        highlight = { enable = true }
}
require("lualine").setup {
        options = {
                theme = "material",
                component_separators = "",
                section_separators = "",
                icons_enabled = false,
        }
}

local build_commands = {
  markdown = 'make || pandoc % -o %:r.pdf',
  python = 'python %',
  rmd = 'echo "rmarkdown::render(\'%\')" | R --vanilla',
  rust = 'cargo build',
  -- tex = 'pdflatex -shell-escape %',
  tex = 'make || tectonic -p %',
  uiua = 'uiua run %',
}
local open_commands = {
  rmd = 'zathura %:r.pdf || xdg-open %:r.pdf',
  tex = 'zathura %:r.pdf || xdg-open %:r.pdf',
  markdown = 'zathura %:r.pdf || xdg-open %:r.pdf',
  rust = 'cargo run --quiet',
}
local format_commands = {
  python = { 'reorder-python-imports %', 'pyupgrade %', 'ruff format %' },
  rust = { 'cargo fix --allow-dirty', 'cargo clippy --fix --allow-dirty', 'cargo fmt' },
  uiua = { 'uiua fmt %' },
}

vim.api.nvim_create_user_command('Build', function()
  vim.cmd('write')
  local filetype = vim.bo.filetype
  local build_command = build_commands[filetype]
  if build_command then
    vim.cmd('!' .. build_command)
  else
    print('No build command for filetype ' .. filetype)
  end
end, { desc = 'Build/Run current buffer' })

vim.api.nvim_create_user_command('Open', function()
  vim.fn.execute('write')
  local filetype = vim.bo.filetype
  local open_command = open_commands[filetype]
  if open_command then
    vim.cmd('!' .. open_command)
  else
    print('No open command for filetype ' .. filetype)
  end
end, { desc = 'Open current buffer' })

vim.api.nvim_create_user_command('Format', function()
  vim.fn.execute('write')
  local filetype = vim.bo.filetype
  if format_commands[filetype] then
    for _, format_command in ipairs(format_commands[filetype]) do
      vim.fn.execute('silent !' .. format_command)
    end
  else
    print('No formatter for filetype ' .. filetype)
  end
end, { desc = 'Format current buffer' })

vim.api.nvim_set_keymap('n', '<leader>b', ':Build<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>o', ':Open<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>f', ':Format<CR>', { noremap = true, silent = true })
