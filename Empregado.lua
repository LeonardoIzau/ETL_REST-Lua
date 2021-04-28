local Empregado = {}
Empregado.new = function(_id, name)
	local self = {}
	local id = _id
	local nome = name
	function self.getId()
		return id
	end
	function self.setId(novoId)
        id = novoId
    end
	function self.getNome()
		return nome
	end
    function self.setNome(novoNome)
        nome = novoNome
    end
    function self.toString()
        return "Employee [id=" .. id .. ", name=" .. nome .. "]"
    end
    return self
end

return Empregado
