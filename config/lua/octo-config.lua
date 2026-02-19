local ok, octo = pcall(require, "octo")
if not ok then
  return
end

octo.setup({
  github_hostname = "gitent.corp.nuro.team",
  ssh_aliases = {},
  default_to_projects_v2 = false,
  suppress_missing_scope = {
    projects_v2 = true,
  },
  picker = "telescope",
})
