--Código escrito com o auxílio da biblioteca open-source "LuaLogging", desenvolvido por Daniel Tuler, Thiago Ponte e André Carregal. Link para download: <neopallium.github.io/lualogging/index.html>.--
--Código escrito com o auxílio da biblioteca open-source "LuaSQL". Link para download: <keplerproject.github.io/luasql/>.--
--Código escrito com o auxílio da biblioteca open-source "Lua CJSON". Link para download: <www.kyne.com.au/~mark/software/lua-cjson.php>.--
--O banco de dados foi construído a partir do programa MySQL, instalado previamente na máquina.--

local DiaTrabalhoServiceController = {}
require "logging.console"
local logger = logging.console()
local cjson = require "cjson"
local luasql = require "luasql.mysql"

function rows (connection, sql_statement)
	local cursor = assert (connection:execute(sql_statement))
	return function ()
		return cursor:fetch()
	end
end

function DiaTrabalhoServiceController.list()
	result = {}
	nomeBD = "ALPLoader"
	--Cria objeto de ambiente--
	env = assert (luasql.mysql())
	--Conecta ao banco de dados padrão do MySQL com nome de usuário "root" e senha "root"--
	con = assert (env:connect("mysql", "root", "root"))
	--Conecta ao banco de dados da aplicacao--
	res = con:execute(string.format("USE %s", nomeBD))
	consultaSQL = "SELECT e.nome as name, p.ponto as punch, d.data as date FROM Empregado e JOIN DiaTrabalho d ON e.id = d.idEmpregado JOIN Ponto p ON d.id=p.idDiaTrabalho"
	--Chama o iterador de linhas da tabela--
	for name, punch, date in rows (con, consultaSQL) do
		table.insert(result, {nome=name, ponto=punch, data=date})
		print(string.format ("%s   %s   %s", name, punch, date))
	end
	--Codifica a tabela da consulta em uma string JSON.--
	json = cjson.encode(result)
	logger:info ("Processo de parsing para JSON concluido.")
	--Fecha a conexão com o banco e o objeto de ambiente--
	con:close()
	env:close()
	return json
end

return DiaTrabalhoServiceController
