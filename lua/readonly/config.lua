local M = {}


-- Default options
M.opts = {
  secured_files = {}
}

function M.setup(user_opts)
  M.opts = vim.tbl_deep_extend("force", M.opts, user_opts or {})

  assert(vim.tbl_islist(M.opts.secured_files), 'secured_files must be a list of strings')
end


return M
