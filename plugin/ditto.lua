local ditto=require'ditto'
vim.g.ditto_min_word_length=vim.g.ditto_min_word_length or 4
vim.g.ditto_min_repetitions=vim.g.ditto_min_repetitions or 3
vim.g.ditto_hlgroup=vim.g.ditto_hlgroup or 'SpellRare'
vim.g.ditto_mode=vim.g.ditto_mode or 'paragraph'
vim.g.ditto_autocmds=vim.g.ditto_autocmds or {'InsertLeave','TextChanged'}

vim.api.nvim_create_user_command('Ditto',ditto.ditto,{nargs=0})
vim.api.nvim_create_user_command('NoDitto',ditto.no_ditto,{nargs=0})
vim.api.nvim_create_user_command('DittoOn',ditto.ditto_on,{nargs=0})
vim.api.nvim_create_user_command('DittoOff',ditto.ditto_off,{nargs=0})
vim.api.nvim_create_user_command('ToggleDitto',ditto.toggle_ditto,{nargs=0})
vim.api.nvim_create_user_command('DittoUpdate',ditto.ditto_update,{nargs=0})
