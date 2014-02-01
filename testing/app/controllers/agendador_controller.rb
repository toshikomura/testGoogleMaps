class AgendadorController < ApplicationController
  # GET /municipios.json?id=1
  def municipios
    @municipios = Tmibge.where("tufibge_id = ?", params[:id])
    respond_to do |format|
      format.json { render json: @municipios }
    end
  end
  # GET /profissionais.json?id=1
  def profissionais_executores
    @profissionais = Profissional.where("orgao_id = ?", params[:id])
    respond_to do |format|
      format.json { render json: @profissionais }
    end
  end
  def tipo_atendimentos_local_de_atendimento
    @tipo_atendimentos = TipoAtendimento.where("tipo_atendimentos.ativo = ?", true)
    respond_to do |format|
      format.json { render json: @tipo_atendimentos }
    end
  end
  def contato
    @prefeitura = Prefeitura.first
  end
  def reportar
    @prefeitura = Prefeitura.first
  end
end
