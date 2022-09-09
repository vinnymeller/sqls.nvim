local M = {}

local api = vim.api

M.on_attach = function(client, bufnr)
    if vim.fn.has('nvim-0.8.0') == 1 then
        client.server_capabilities.executeCommandProvider = true
        client.server_capabilities.codeActionProvider = {resolveProvider = false}
    else
        client.resolved_capabilities.execute_command = true
    end

    client.commands = M.commands
    api.nvim_buf_create_user_command(bufnr, 'SqlsExecuteQuery', function(args)
        require('sqls.commands').exec('executeQuery', args.mods, args.range ~= 0, nil, args.line1, args.line2)
    end, { range = true })
    api.nvim_buf_create_user_command(bufnr, 'SqlsExecuteQueryOnCursor', function(args)
        require('sqls.commands').exec('executeQuery', args.mods, args.range ~= 0, nil, args.line1, args.line2, true)
    end, { range = true })
    api.nvim_buf_create_user_command(bufnr, 'SqlsExecuteQueryVertical', function(args)
        require('sqls.commands').exec('executeQuery', args.mods, args.range ~= 0, '-show-vertical', args.line1, args.line2)
    end, { range = true })
    api.nvim_buf_create_user_command(bufnr, 'SqlsShowDatabases', function(args)
        require('sqls.commands').exec('showDatabases', args.mods)
    end, {})
    api.nvim_buf_create_user_command(bufnr, 'SqlsShowSchemas', function(args)
        require('sqls.commands').exec('showSchemas', args.mods)
    end, {})
    api.nvim_buf_create_user_command(bufnr, 'SqlsShowConnections', function(args)
        require('sqls.commands').exec('showConnections', args.mods)
    end, {})
    api.nvim_buf_create_user_command(bufnr, 'SqlsShowTables', function(args)
        require('sqls.commands').exec('showTables', args.mods)
    end, {})
    -- Not yet supported by the language server:
    -- api.nvim_buf_create_user_command(bufnr, 'SqlsDescribeTable', function(args)
    --     require('sqls.commands').exec('describeTable', args.mods)
    -- end, {})
    api.nvim_buf_create_user_command(bufnr, 'SqlsSwitchDatabase', function(args)
        require('sqls.commands').switch_database(args.args ~= '' and args.args or nil)
    end, { nargs = '?' })
    api.nvim_buf_create_user_command(bufnr, 'SqlsSwitchConnection', function(args)
        require('sqls.commands').switch_connection(args.args ~= '' and args.args or nil)
    end, { nargs = '?' })

    api.nvim_buf_set_keymap(bufnr, 'n', '<Plug>(sqls-execute-query)', "<Cmd>set opfunc=v:lua.require'sqls.commands'.query<CR>g@", {silent = true})
    api.nvim_buf_set_keymap(bufnr, 'x', '<Plug>(sqls-execute-query)', "<Cmd>set opfunc=v:lua.require'sqls.commands'.query<CR>g@", {silent = true})
    api.nvim_buf_set_keymap(bufnr, 'n', '<Plug>(sqls-execute-query-vertical)', "<Cmd>set opfunc=v:lua.require'sqls.commands'.query_vertical<CR>g@", {silent = true})
    api.nvim_buf_set_keymap(bufnr, 'x', '<Plug>(sqls-execute-query-vertical)', "<Cmd>set opfunc=v:lua.require'sqls.commands'.query_vertical<CR>g@", {silent = true})
end

M.commands = {
    executeQuery = function(_, _)
        require('sqls.commands').exec('executeQuery')
    end,
    showDatabases = function(_, _)
        require('sqls.commands').exec('showDatabases')
    end,
    showSchemas = function(_, _)
        require('sqls.commands').exec('showSchemas')
    end,
    showConnections = function(_, _)
        require('sqls.commands').exec('showConnections')
    end,
    showTables = function(_, _)
        require('sqls.commands').exec('showTables')
    end,
    describeTable = function(_, _)
        require('sqls.commands').exec('describeTable')
    end,
    switchConnections = function(_, _)
        require('sqls.commands').switch_connection()
    end,
    switchDatabase = function(_, _)
        require('sqls.commands').switch_database()
    end,
}

return M
