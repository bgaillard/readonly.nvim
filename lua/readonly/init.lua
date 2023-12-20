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
  vim.api.nvim_create_autocmd(
    "BufReadCmd",
    {
      callback = function(args)
        vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, {
          "This file is marked as secured, you cannot edit it with a Neovim instance having plugins loaded.",
          "",
          "Instead use the following command to edit it securely.",
          "",
          "nvim -u NONE " .. args.file
        })

        vim.api.nvim_buf_set_option(args.buf, "modifiable", false)
        vim.api.nvim_buf_set_option(args.buf, "readonly", true)
      end,
      group = M.augroup,
      pattern = options.pattern,
    }
  )
end

return M
