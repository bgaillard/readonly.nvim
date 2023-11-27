local config = require("readonly.config")
local M = {}


function M.setup(options)
  options = options or {}

  config.setup(options)
end

---- Check if a file is a secured one.
--
-- @param file_path The path of the file to check.
--
-- @return true if the file is secured, false otherwise.
local function is_secured_file(file_path)
  for _, secured_file in ipairs(config.opts.secured_files) do
    local absolute_secured_file = vim.fs.normalize(secured_file)
    if file_path:match(absolute_secured_file) then
      return true
    end
  end

  return false
end

function M.init()
  M.augroup = vim.api.nvim_create_augroup("readonly_nvim", {})
  vim.api.nvim_create_autocmd(
    "BufReadPre",
    {
      callback = function(args)

        if is_secured_file(args.file) then
          vim.api.nvim_buf_set_option(args.buf, "modifiable", false)
          vim.api.nvim_buf_set_option(args.buf, "readonly", true)

          require("notify")(
            "This file is marked as secured. \n\n" ..
            "You cannot edit it with a Neovim instance having plugins loaded. \n\n" ..
            "Instead use `nvim -u NONE myfile` to edit it securely.",
            "error", {
              title = "Sensible file",
              timeout = 10000,
            }
          )
        end

      end,
      group = M.augroup,
      pattern = "*",
    }
  )
end

M.init()

return M
