module("luci.controller.owxbyz", package.seeall)

function index()
  entry({"admin", "services", "owxbyz"}, alias("admin", "services", "owxbyz", "config"), _("Yizhan - Edge Computing"), 29).dependent = true
  entry({"admin", "services", "owxbyz", "config"}, cbi("owxbyz"))
end
