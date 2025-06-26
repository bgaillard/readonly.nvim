local M = {}

-- Default options
M.opts = {
  pattern = {}
}

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

        vim.api.nvim_buf_add_highlight(args.buf, ns, "Error", 1, 0, -1)
        vim.api.nvim_buf_add_highlight(args.buf, ns, "Error", 3, 0, -1)
        vim.api.nvim_buf_add_highlight(args.buf, ns, "Command", 5, 0, -1)

        vim.api.nvim_set_option_value("modifiable", false, { buf = args.buf })
        vim.api.nvim_set_option_value("readonly", true, { buf = args.buf })
      end,
      group = M.augroup,
      pattern = options.pattern,
    }
  )
end

return M
