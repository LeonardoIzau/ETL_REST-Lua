--Código escrito com o auxílio da biblioteca open-source "LuaLogging", desenvolvido por Daniel Tuler, Thiago Ponte e André Carregal. Link para download: <neopallium.github.io/lualogging/index.html>.--
--Código escrito com o auxílio da biblioteca open-source "LuaSQL". Link para download: <keplerproject.github.io/luasql/>.--
--O banco de dados foi construído a partir do programa MySQL, instalado previamente na máquina.--
local Loader={}
require "logging.console"
local logger = logging.console()
local luasql = require "luasql.mysql"
EmpregadoClasse = require "Empregado"
DiaTrabalhoClasse = require "DiaTrabalho"
PontoClasse = require "Ponto"

function Loader.load(diasTrabalho)
	nomeBD = "ALPLoader"
	--Cria objeto de ambiente--
	env = assert (luasql.mysql())
	--Conecta ao banco de dados padrão do MySQL com nome de usuário "root" e senha "root"--
	con = assert (env:connect("mysql", "root", "root"))
	--Reseta o banco de dados--
	res = con:execute(string.format("DROP DATABASE %s", nomeBD))
	--Cria o banco e conecta o programa--
	res = con:execute(string.format("CREATE DATABASE %s", nomeBD))
	res = con:execute(string.format("USE %s", nomeBD))
	--Reseta as tabelas do banco--
	res = con:execute("DROP TABLE Ponto")
	res = con:execute("DROP TABLE DiaTrabalho")
	res = con:execute("DROP TABLE Empregado")
	--Cria as tabelas--
	res = assert (con:execute[[
		CREATE TABLE Empregado(
			id  integer PRIMARY KEY,
		 	nome  varchar(50)
	    )
	]])
	res = assert (con:execute[[
		CREATE TABLE DiaTrabalho(
			id  integer PRIMARY KEY, 
		 	data  date,
		    idEmpregado  integer,
		    FOREIGN KEY(idEmpregado) REFERENCES Empregado(id)
	    )
	]])
	res = assert (con:execute[[
		CREATE TABLE Ponto(
			id  integer  PRIMARY KEY, 
		 	ponto  time,
		    idDiaTrabalho  integer,
		    FOREIGN KEY(idDiaTrabalho) REFERENCES DiaTrabalho(id)
	    )
	]])
	
	for i, v in pairs(diasTrabalho) do
		novoEmpregado = v.getEmpregado()
		novoId = novoEmpregado.getId()
		novoNome = novoEmpregado.getNome()
		cur = assert (con:execute(string.format([[SELECT id, nome FROM Empregado WHERE nome = '%s']], novoNome)))
		--A variável 'row' faz a iteração de tuplas retornadas por 'cur' como resultado da consulta--
		row = cur:fetch ({}, "a")
		repeat
			--Verifica se o resultado da consulta está vazio--
			if row == nil then
				res = con:execute(string.format([[INSERT INTO Empregado VALUES (%d, '%s')]], novoId, novoNome))
				empregadoBD = novoEmpregado
			--Verifica se o empregado foi encontrado ou o nome está duplicado--
			else
				if row.id == novoId or row.nome == novoNome then
					empregadoBD = EmpregadoClasse.new(row.id, row.nome)
				else
					logger:error ("Nome duplicado para empregado: " .. novoNome)
				end
				row = cur:fetch (row, "a")
			end			
		until row == nil
		v.setEmpregado(empregadoBD)
		novoId = empregadoBD.getId()
		--Foi necessário converter a data para o formato aceito pelo MySQL.--
		res = assert (con:execute(string.format([[INSERT INTO DiaTrabalho VALUES (%d, STR_TO_DATE('%s', '%%d/%%m/%%y'), %d)]], v.getId(), v.getData(), novoId)))
		pontos = v.getPontos()
		for j, t in pairs(pontos) do
			novoDiaTrabalho = t.getDiaTrabalho()
			res = assert (con:execute(string.format([[INSERT INTO Ponto VALUES (%d, '%s', %d)]], t.getId(), t.getPonto(), novoDiaTrabalho.getId())))
		end
	end
	--Consulta teste para verificar a criação do banco.--
	cur = assert (con:execute("SELECT e.nome as name, p.ponto as punch, d.data as date FROM Empregado e JOIN DiaTrabalho d ON e.id = d.idEmpregado JOIN Ponto p ON d.id=p.idDiaTrabalho"))
	consulta = cur:fetch({}, "a")
	while consulta do
		logger:debug ("{Nome: " .. consulta.name .. ", Ponto: " .. consulta.punch .. ", Data: " .. consulta.date .. "}")
		consulta = cur:fetch(consulta, "a")
	end
	logger:info ("Processo de carregamento concluído.")
	--Fecha o cursor, a conexão com o banco e o objeto de ambiente--
	cur:close()
	con:close()
	env:close()
end

return Loader
