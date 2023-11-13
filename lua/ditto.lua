local M={}
M.ditto_is_on=false
M.matches={}
function M.get_words(buf)
    local wordcount={}
    local wordspos={}
    for lines,i in pairs(vim.api.nvim_buf_get_lines(buf,0,-1,false)) do
        for j in i:gmatch'%w+' do
            if #j<vim.g.ditto_min_word_length then goto continue end
            wordcount[j]=(wordcount[j] or 0)+1
            if wordcount[j]<vim.g.ditto_min_repetitions then goto continue end
            wordspos[j]=wordspos[j] or {}
            table.insert(wordspos[j],lines)
            ::continue::
        end
        if vim.g.ditto_mode=='paragraph' then wordcount={} end
    end
    return wordspos

end
function M.clear_matches(_)
    for _,v in ipairs(M.matches) do
        vim.fn.matchdelete(v)
    end
    M.matches={}
end
function M.create_matches(buf)
    buf=buf or vim.api.nvim_get_current_buf()
    M.clear_matches(buf)
    for word,linenrs in pairs(M.get_words(buf)) do
        local spec=vim.g.ditto_mode=='paragraph' and '\\('..table.concat(vim.tbl_map(function(v) return '\\%'..v..'l' end,linenrs),'\\|')..'\\)' or ''
        table.insert(M.matches,vim.fn.matchadd(vim.g.ditto_hlgroup,spec..word))
    end
end
function M.ditto_on()
    M.ditto_is_on=true
    M.create_matches()
    M.au=vim.api.nvim_create_autocmd(vim.g.ditto_autocmds,{callback=M.ditto_update})
end
function M.ditto_off()
    if M.ditto_is_on==false then return end
    M.ditto_is_on=false
    vim.api.nvim_del_autocmd(M.au)
    M.clear_matches()
end
function M.toggle_ditto()
    if M.ditto_is_on then M.ditto_off() else M.ditto_on() end
end
function M.ditto_update()
    if M.ditto_is_on then M.create_matches() end
end
M.ditto=M.ditto_on
M.no_ditto=M.ditto_off
return M
