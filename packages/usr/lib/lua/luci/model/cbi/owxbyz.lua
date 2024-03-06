local jsonc = require "luci.jsonc"

local m, s, o

--m = taskd.docker_map("owxbyz", "owxbyz", "/usr/libexec/istorec/owxbyz.sh",
m = Map("owxbyz",
    translate("Yizhan - Edge Computing"),
    translate("Yizhan - Rent idle device resources and earn points passively. Exchange for movie VIP, music VIP and phone calls at will.")) 
--    "驿站官网：" ..
--    ' <a href=\"https://yz.iepose.com/\" target=\"_blank\">https://yz.iepose.com/</a>')

m.apply_on_parse = true
m.on_after_apply = function(self)
    if self.changed == true then
        luci.sys.call("/etc/init.d/owxbyz reload >/dev/null 2>&1")
    end
end
s = m:section(SimpleSection, translate("Yizhan Status"), "", "owxbyz")
s:append(Template("owxbyz/status"))

s = m:section(TypedSection, "owxbyz", translate("Yizhan Configures"))
s.addremove=false
s.anonymous=true

o = s:option(Flag, "enabled", translate("Enable"))
o.rmempty = false

-- functions list all disk blocks
local xbyz_blocks = function()
  local f = io.popen("lsblk -sbo FSSIZE,MOUNTPOINT -x FSSIZE --json", "r")
  local vals = {}
  if f then
    local ret = f:read("*all")
    f:close()
    local obj = jsonc.parse(ret)
    for _, val in pairs(obj["blockdevices"]) do
      local fsize = val["fssize"]
      if fsize ~= nil and tonumber(fsize) > 50000000000 and val["mountpoint"] then
        vals[#vals+1] = val["mountpoint"]
      end
    end
  end
  return vals
end

local blks = xbyz_blocks()
local dir
o = s:option(Value, "cache_path", translate("YZ-Cache-Path").."<b> *</b>", translate("The more storage space you provide, the higher your earnings will be."))
o.rmempty = false
o.datatype = "string"
for _, dir in pairs(blks) do
    dir = dir .. "/Caches/owxbyz"
    o:value(dir, dir)
end

--if #blks > 0 then
--    o.default = blks[#blks]
--end

function o.validate(self, path, section) 
    if path and #path > 0 and path:sub(1, 1) == "/" then
        nixio.fs.mkdirr(path)
        if nixio.fs.access(path) then
            return path
        else
            return nil, translate("YZ-Cache-Path not exist or permission deny")
        end
    else
        return nil, translate("YZ-Cache-Path invalid")
    end
end

return m
