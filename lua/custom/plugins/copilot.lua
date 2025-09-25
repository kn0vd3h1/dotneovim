return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  config = function()
    require('copilot').setup {
      suggestion = {
        keymap = {
          accept = '<Tab>',
          next = '<M-j>',
          prev = '<M-k>',
        },
      },
      filetypes = {
        yaml = true,
        markdown = true,
        gitcommit = true,
      },
    }

    -- Function to toggle Copilot suggestions
    function CopilotEnable()
      require('copilot.suggestion').toggle_auto_trigger()
      print 'Copilot auto-trigger enabled ✅'
    end

    -- Create user commands to call the functions
    vim.api.nvim_create_user_command('CopilotEnable', CopilotEnable, { desc = 'Enable Copilot suggestions' })
  end,
}
