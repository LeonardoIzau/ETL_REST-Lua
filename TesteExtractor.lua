extractor = require "Extractor"
vo = extractor.extract("RelExtraPorPeriodo.csv")
assert(vo ~= nil, "Tabela de TimeEntries vazia!")
assert(#vo == 72, "Tabela de TimeEntries não contém 72 registros!")
for i, v in pairs(vo) do
	assert(v[1] ~= nil, "Não há empregado!")
	assert(v[2] ~= nil, "Não há data de trabalho!")
	assert(v[3] ~= nil, "Não há horas trabalhadas no dia!")
end

	
