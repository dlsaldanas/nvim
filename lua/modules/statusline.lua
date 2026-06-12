vim.o.showmode = false
-- Make statusline global (laststatus=3) to span across all windows
vim.o.laststatus = 3

vim.pack.add({
  {
    src = 'https://github.com/nvim-mini/mini.nvim',
  }
})

local statusline = require('mini.statusline')
-- set use_icons to true if you have a Nerd Font
statusline.setup({
  use_icons = true,
  -- Set content hooks to show current buffer info dynamically
  content = {
    active = function()
      -- Get current buffer info
      local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
      local git = statusline.section_git({ trunc_width = 40 })
      local diff = statusline.section_diff({ trunc_width = 75 })
      local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
      local filename = statusline.section_filename({ trunc_width = 140 })
      local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
      local location = statusline.section_location()
      local search = statusline.section_searchcount({ trunc_width = 75 })

      return statusline.combine_groups({
        { hl = mode_hl,                  strings = { mode } },
        { hl = 'statuslineDevinfo',  strings = { git, diff, diagnostics } },
        '%<', -- Mark general truncate point
        { hl = 'statuslineFilename', strings = { filename } },
        '%=', -- End left alignment
        { hl = 'statuslineFileinfo', strings = { fileinfo } },
        { hl = mode_hl,                  strings = { search, location } },
      })
    end,
    inactive = function()
      -- Show minimal info for inactive windows (though with laststatus=3, this may not be used)
      local filename = statusline.section_filename({ trunc_width = 140 })
      return statusline.combine_groups({
        { hl = 'statuslineInactive', strings = { filename } },
      })
    end,
  },
})

-- You can configure sections in the statusline by overriding their
-- default behavior. For example, here we set the section for
-- cursor location to LINE:COLUMN
---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function()
  return '%2l:%-2v'
end

