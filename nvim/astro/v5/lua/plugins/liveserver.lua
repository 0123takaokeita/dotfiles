-- usage
-- leader-pt up liveserver
-- leader-pd down liveserver
return {
  "barrett-ruth/live-server.nvim",
  cmd = "LiveServerStart",
  build = "yarn global add live-server",
  config = function()
    require("live-server").setup()
  end,
}
