local DiaTrabalho = {}
PontoClasse = require "Ponto"

DiaTrabalho.new = function(_id, empregado, data)
	local self = {}
	local id = _id
	local employee = empregado
	local date = data
    	local punches = {}
	function self.punch(id, ponto)
		punch = PontoClasse.new(id, ponto, self)
		table.insert(punches, punch)
	end
	function self.getId()
		return id
	end
	function self.setId(novoId)
        	id = novoId
   	end
	function self.getEmpregado()
		return employee
	end
	function self.getData()
		return date
	end
	function self.getPontos()
		return punches
	end
    	function self.setEmpregado(novoEmpregado)
        	employee = novoEmpregado
    	end
	function self.setData(novaData)
        	date = novaData
    	end
	function self.setPontos(novosPontos)
        	punches = novosPontos
    	end
    	function self.toString()
       		return "WorkDay [id= " .. id .. ", "  .. employee.toString() .. ", date=" .. date .. "]"
    	end
    	return self
end

return DiaTrabalho
