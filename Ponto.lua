local Ponto = {}

Ponto.new = function(_id, ponto, diaTrabalho)
	local self = {}
	local id = _id
    local punch = ponto
	local workDay = diaTrabalho
	function self.getId()
		return id
	end
	function self.getPonto()
		return punch
	end
	function self.getDiaTrabalho()
		return workDay
	end
	function self.setId(novoId)
        id = novoId
    end
	function self.setPonto(novoPonto)
        punch = novosPonto
    end
	function self.setDiaTrabalho(novoDiaTrabalho)
        workDay = novoDiaTrabalho
    end
    function self.toString()
        return "Punch [id= " .. id .. ", punch= " .. punch .. ", " .. workDay.toString() .. "]"
    end
    return self
end

return Ponto
