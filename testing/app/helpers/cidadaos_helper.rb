module CidadaosHelper
  def cidadao_bloqueado?(agendamentos_agendados, max_agendamentos, ultimo_bloqueio)
    unless ultimo_bloqueio.nil?
      if Date.current < ultimo_bloqueio.data_expira
        return true
      end
    end
  
    if agendamentos_agendados >= max_agendamentos
      return true
    end
    
    return false
  end
end
