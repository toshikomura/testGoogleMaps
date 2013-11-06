# coding: utf-8
module AgendamentosHelper
  def profissional_executor
    unless @agendamento.escala.nil?
      profissional = Profissional.where(:id =>
                     @agendamento.escala.profissional_executor_id).first
      if profissional.nil?
        return nil
      else
        return profissional.nome
      end
    end
  end

  def profissional_responsavel
    unless @agendamento.escala.nil?
      profissional = Profissional.where(:id =>
                     @agendamento.escala.profissional_responsavel_id).first
      if profissional.nil?
        return nil
      else
        return profissional.nome
      end
    end
  end

  def cidadao_bloqueado?(cidadao_num_agendamentos, situacao_bloqueio)
    unless situacao_bloqueio.nil?
      if situacao_bloqueio.data_expira > Date.today
        return true
      end
    end

    unless cidadao_num_agendamentos.nil?
      if cidadao_num_agendamentos > CidadaosController::MAX_AGENDAMENTOS
        return true
      end
    end

    return false
  end

  def eh_passado?(data_agendamento)
      if data_agendamento <= DateTime.now
        return true
      else
        return false
      end
  end
end
