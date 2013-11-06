# encoding: UTF-8
module ApplicationHelper

  def situacao(model)
    return model.ativo ? "Ativo" : "Inativo"
  end

  ERRO_ESTADO = "ERRO: não possui estado, por favor atualize!"
  def estado(model)
    return model.tufibge.nil? ? ERRO_ESTADO : model.tufibge.nome_uf
  end

  ERRO_MUNICIPIO = "ERRO: não possui município, por favor atualize!"
  def municipio(model)
    return model.tmibge.nil? ? ERRO_MUNICIPIO : model.tmibge.nome_municipio
  end 

  def any_signed_in?
    return (cidadao_signed_in? || profissional_signed_in?)
  end

  def administrador_signed_in?
    if profissional_signed_in?
        return current_profissional.administrador?
    else
        return false 
    end
  end

  def administradorsistema_signed_in?
    if profissional_signed_in?
        return current_profissional.administradorsistema?
    else 
        return false
    end
  end

  def atendente_signed_in?
    if profissional_signed_in?
        return current_profissional.atendente?
    else
        return false
    end
  end

  # Retorna o nome e sobrenome de um nome completo fornecido.
  # @param nome_completo [String] nome completo
  # @return [String] retorna nome e sobrenome do nome completo.
  # @example Nome completo "Rinaldo Victor de Lamare"
  #    divir_nome("Rinaldo Victor de Lamare") => "Rinaldo Lamare"
  def dividir_nome(nome_completo)
    nome = nome_completo.to_s.split(/\.?\s+/)

    if (nome.size < 1)
      return "Erro nome vazio"
    elsif (nome.size == 1)
      return nome.first
    else
      return (nome.first + ' ' + nome.last)
    end
  end
end
