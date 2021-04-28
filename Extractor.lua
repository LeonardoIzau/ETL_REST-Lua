--Código escrito com o auxílio da biblioteca open-source "LuaLogging", desenvolvido por Daniel Tuler, Thiago Ponte e André Carregal. Link para download: <neopallium.github.io/lualogging/index.html>.--
local Extractor = {}
require "logging.console"
local logger = logging.console()
employeeRegex = ";Empregado:;;;;([A-za-zÁ-Úá-ú ]+);*"
workDayRegex = "(%d%d/%d%d) %- (%l%l%l);;;([0-9: ]*).*"

function Extractor.extract(nomeArquivo)
	registros = {}
	assert(io.input(nomeArquivo), "Arquivo inexistente")
	for line in io.lines() do
		nomeEmpregado = string.match(line, employeeRegex)
		if(nomeEmpregado ~= nil) then
			empregado = nomeEmpregado
		end
		diaTrabalho, diaSemana, horarios = string.match(line, workDayRegex)
		if((diaTrabalho ~= nil) and (horarios ~= nil)) then
			if(horarios ~= "") then
				vo = {empregado, diaTrabalho, horarios}
				table.insert(registros, vo)
				--logger:debug("TimeEntryVO [employee=" .. vo[1] .. ", date=" .. vo[2] .. ", hours=" .. vo[3] .. "]")
			end
		end
	end
	logger:info("Processo de extração concluído. Foram extraídos " .. #registros .. " elementos.")
	return registros
end

return Extractor
