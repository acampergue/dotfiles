-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.cmd('autocmd VimLeave * silent! !rm -f kls_database.db')
