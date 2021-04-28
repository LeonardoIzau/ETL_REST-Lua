--Código escrito com o auxílio da biblioteca open-source "LuaLogging", desenvolvido por Daniel Tuler, Thiago Ponte e André Carregal. Link para download: <neopallium.github.io/lualogging/index.html>.--
local Transformer={}
require "logging.console"
local logger = logging.console()
EmpregadoClasse = require "Empregado"
DiaTrabalhoClasse = require "DiaTrabalho"

function mysplit(inputstr, sep) --Foi necessário criar essa função pois não há implementação do método split na biblioteca de strings do Lua.--
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for str in string.gmatch(inputstr, "([^" ..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end

function Transformer.transform(registros)
	result = {}
	empregados = {}
	idEmployee, idPunch, idWorkDay = 1, 1, 1
	for i, v in pairs(registros) do
		empregadoString = v[1]
		dataString = v[2]
		horasString = v[3]
		empregadoBusca = empregados[empregadoString]
		if(empregadoBusca == nil) then
			e = EmpregadoClasse.new(idEmployee, empregadoString)
			idEmployee = idEmployee + 1
			empregados[empregadoString] = e
		end
		data = dataString .. "/19"
		dt = DiaTrabalhoClasse.new(idWorkDay, e, data)
		idWorkDay = idWorkDay + 1
		pontos = mysplit(horasString, " ")
		for i, v in pairs (pontos) do
			dt.punch(idPunch, v)
			idPunch = idPunch + 1
		end
		table.insert(result, dt)
		--logger:debug(dt.toString())
		punches = dt.getPontos()
		for j, t in pairs (punches) do
			--logger:debug(t.toString())
		end
	end
	logger:info("Processo de transformação concluído. Foram transformados " .. #result .. " elementos.")
	return result
end

return Transformer
