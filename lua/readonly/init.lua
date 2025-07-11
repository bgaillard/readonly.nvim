local M = {}

-- Default options
M.opts = {

  display_modes = {

    buffer = {
      enabled = false,
    },

    command_line = {
      enabled = true
    },

    notification = {

      --- Whether to enable notifications
      enabled = false,

      --- Default options for "rcarriga/nvim-notify"
      ---
      --- see https://github.com/rcarriga/nvim-notify/blob/master/lua/notify/config/init.lua
      opts = {
        level = vim.log.levels.ERROR,
        timeout = 5000,
        max_width = nil,
        max_height = nil,
        stages = "fade_in_slide_out",
        render = "default",
        background_colour = "#000000",
        on_open = nil,
        on_close = nil,
        minimum_width = 50,
        fps = 30,
        top_down = true,
        merge_duplicates = true,
        time_formats = {
          notification_history = "%FT%T",
          notification = "%T",
        },
        icons = {
          ERROR = "",
          WARN = "",
          INFO = "",
          DEBUG = "",
          TRACE = "✎",
        },
      }

    }

  },

  --- Patterns to match secured files
  pattern = {}
}


--- Display for "Buffer mode".
---
--- @param args table arguments passed to the callback function of the "BufReadCmd" autocommand.
local function display_buffer(args)
  local ns = vim.api.nvim_create_namespace("readonly_nvim")
  vim.api.nvim_set_hl_ns(ns)

  vim.api.nvim_set_hl(ns, "Error", { fg = "red" })
  vim.api.nvim_set_hl(ns, "Command", { fg = "yellow" })

  vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, {
    "",
    "This file is marked as secured, you cannot edit it with a Neovim instance having plugins loaded.",
    "",
    "Instead use the following command to edit it securely.",
    "",
    "  nvim -u NONE " .. args.file,
    "",
  })

  vim.api.nvim_buf_set_extmark(args.buf, ns, 1, 0, {hl_group = "Error", end_row = 2})
  vim.api.nvim_buf_set_extmark(args.buf, ns, 3, 0, {hl_group = "Error", end_row = 4})
  vim.api.nvim_buf_set_extmark(args.buf, ns, 5, 0, {hl_group = "Command", end_row = 6})
end


--- Display for "Command line mode".
---
--- @param args table arguments passed to the callback function of the "BufReadCmd" autocommand.
local function display_command_line(args)
  vim.notify("Secured file, open it with `nvim -u NONE " .. args.file .. "`", vim.log.levels.WARN)
end


--- Display for "Notification mode".
---
--- @param args table arguments passed to the callback function of the "BufReadCmd" autocommand.
local function display_notification(args)
  local success, notify = pcall(require, "notify")

  if success then
    notify.setup(M.opts.display_modes.notification.opts)
    notify.notify(
      "This file is marked as secured, you cannot edit it with a Neovim instance having plugins loaded.\n" ..
      "Instead use the following command to edit it securely:\n\n" ..
      "  nvim -u NONE " .. args.file,
      "error",
      {
        title = "Sensitive file",
        timeout = 10000,
      }
    )
  else
    display_command_line(args)
  end
end


function M.setup(options)
  M.opts = vim.tbl_deep_extend("force", M.opts, options or {})

  if M.opts.pattern == nil or M.opts.pattern == '' then
    M.opts.pattern = {}
  end

  -- If no patterns are provided, do nothing (otherwise our autocmd would match every file)
  if next(M.opts.pattern) == nil then
    return
  end

  M.augroup = vim.api.nvim_create_augroup("readonly_nvim", {})

  -- Create an autocommand that will trigger on BufReadCmd for the specified patterns
  vim.api.nvim_create_autocmd(
    "BufReadCmd",
    {
      callback = function(args)

        --- Display mode "buffer"
        if M.opts.display_modes.buffer.enabled then
          display_buffer(args)
        else
          local filetype = vim.filetype.match({buf = args.buf, filename = args.file})

          if filetype then
              vim.bo.filetype = filetype
          end

          local file_lines = vim.fn.readfile(args.file)
          vim.fn.setline(1, file_lines)
        end

        --- Display mode "command_line"
        if M.opts.display_modes.command_line.enabled then
          display_command_line(args)
        end

        --- Display mode "notification"
        if M.opts.display_modes.notification.enabled then
          display_notification(args)
        end

        vim.api.nvim_set_option_value("modifiable", false, { buf = args.buf })
        vim.api.nvim_set_option_value("readonly", true, { buf = args.buf })

      end,
      group = M.augroup,
      pattern = options.pattern,
    }
  )
end

return M
