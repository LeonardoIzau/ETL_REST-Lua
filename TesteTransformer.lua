extractor = require "Extractor"
transformer = require "Transformer"
vo = extractor.extract("RelExtraPorPeriodo.csv")
diasTrabalho = transformer.transform(vo)
assert(diasTrabalho ~= nil, "Tabela de WorkDays vazia!")
assert(#diasTrabalho == 72, "Tabela de WorkDays não contém 72 registros!")

for i, v in pairs(diasTrabalho) do
	assert(v.getEmpregado() ~= nil, "Não há empregado!")
	assert(v.getData() ~= nil, "Não há data de trabalho!")
	assert(v.getPontos() ~= nil, "Não há horas trabalhadas no dia!")
	assert(#(v.getPontos()) > 0, "Não há horas trabalhadas no dia!")
end
