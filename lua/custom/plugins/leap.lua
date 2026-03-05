return {
  url = 'https://codeberg.org/andyg/leap.nvim',
  config = function()
    vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')
    vim.keymap.set('n', 'S', '<Plug>(leap-from-window)')

    vim.api.nvim_create_autocmd('CmdlineLeave', {
      group = vim.api.nvim_create_augroup('LeapOnSearch', {}),
      callback = function()
        local ev = vim.v.event
        local is_search_cmd = (ev.cmdtype == '/') or (ev.cmdtype == '?')
        local cnt = vim.fn.searchcount().total
        if is_search_cmd and (not ev.abort) and (cnt > 1) then
          -- Allow CmdLineLeave-related chores to be completed before
          -- invoking Leap.
          vim.schedule(function()
            -- We want "safe" labels, but no auto-jump (as the search
            -- command already does that), so just use `safe_labels`
            -- as `labels`, with n/N removed.
            local labels = require('leap').opts.safe_labels:gsub('[nN]', '')
            -- For `pattern` search, we never need to adjust conceallevel
            -- (no user input). We cannot merge `nil` from a table, but
            -- using the option's current value has the same effect.
            local vim_opts = { ['wo.conceallevel'] = vim.wo.conceallevel }
            require('leap').leap {
              pattern = vim.fn.getreg('/'),  -- last search pattern
              windows = { vim.fn.win_getid() },
              opts = { safe_labels = '', labels = labels, vim_opts = vim_opts, }
            }
          end)
        end
      end,
    })
  end,
}
