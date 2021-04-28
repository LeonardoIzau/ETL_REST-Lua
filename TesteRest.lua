dtsc = require "DiaTrabalhoServiceController"
json = dtsc.list()
local file = io.open("RelExtraPorPeriodo.json",'w')
file:write(json)
file:close()
