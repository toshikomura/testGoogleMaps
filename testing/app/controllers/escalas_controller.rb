# encoding: UTF-8
class EscalasController < ApplicationController
  before_filter :authenticate_profissional!
  load_and_authorize_resource
  before_filter :valid_profissional_associations
  before_filter :escala_valida_para_alteracao, :only => [:edit,:update]

  $array_escalas = Array.new

  # GET /escalas
  # GET /escalas.json
  def index
    @search = Escala.search(params[:q])
    if current_profissional.orgao.nil?
      @escalas = []
    else
      @escalas = @search.result.where("orgao_id = ?",
current_profissional.orgao.id).order("data_execucao ASC")
    end

    respond_to do |format|
      format.html # index.html.erb
      format.js   # index.js.erb
      format.json { render json: @escalas }
    end
  end

  # GET /escalas/1
  # GET /escalas/1.json
  def show
    @escala = Escala.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @escala }
    end
  end

  # GET /escalas/new
  # GET /escalas/new.json
  def new
    @escala = Escala.new

    if params[:escala].nil? == false
		  dia = params[:escala]["data_execucao(3i)"].to_i

     	mes = params[:escala]["data_execucao(2i)"].to_i
     	ano = params[:escala]["data_execucao(1i)"].to_i
     	hi = params[:escala]["horario_inicio_execucao(4i)"].to_i
     	mi = params[:escala]["horario_inicio_execucao(5i)"].to_i
     	hf = params[:escala]["horario_fim_execucao(4i)"].to_i
     	mf = params[:escala]["horario_fim_execucao(5i)"].to_i
     	hora_inicio = Time.zone.local(ano,mes,dia,hi,mi,0)
     	hora_fim = Time.zone.local(ano,mes,dia,hf,mf, 0)

      $array_escalas.push(params[:escala])


    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @escala }
    end
   end
  end

  # GET /escalas/1/edit
  def edit
    @escala = Escala.find(params[:id])
  end

  # POST /escalas
  # POST /escalas.json
  def create
	 flash[:scale_alert] = nil;
   @ind = 0
   for i in 0..($array_escalas.size-1)
    @escala = Escala.new($array_escalas[@ind])
    @escala.numero_sequencia = 1
    #@escala.profissional_responsavel_id = $responsavel
    @escala.tipo_acao_id = TipoAcao.where("descricao = ?","Inclusão").first.id
    if @escala.save
    	#Cria entradas da tabela agendamento para cada escala
    	minutos = @escala.horario_fim_execucao - @escala.horario_inicio_execucao #em segundos
    	minutos = minutos / 60
    	intervalo = minutos / @escala.numero_atendimentos
    	for j in 0..(@escala.numero_atendimentos-1)
     		@agendamento = Agendamento.new
     		@agendamento.orgao_id = @escala.orgao_id
     		@agendamento.escala_id = @escala.id
            @agendamento.tipo_situacao_id = TipoSituacao.where("descricao = ?", "Vago").first.id

     		@agendamento.horario_inicio_consulta = @escala.horario_inicio_execucao + (j*intervalo*60)
     		fim_consulta = j + 1
     		@agendamento.horario_fim_consulta = @escala.horario_inicio_execucao + (fim_consulta*intervalo*60)
     		@agendamento.save
    	end
      $array_escalas.delete_at(@ind)
		else
			@ind = @ind + 1
		end
	end
		if $array_escalas.size == 0
				respond_to do |format|
					format.html { redirect_to escalas_url, notice: "Escala(s) criada(s) com sucesso" }
					format.json { render json: @escala, status: :created, location: @escala}
					end
  	else
      flash[:scale_alert] = "Uma ou mais escala(s) possuem conflito de horário com uma escala já criada."
			respond_to do |format|
				format.html { redirect_to new_escala_path}
				format.json { render json: @escala.errors, status: unprocessable_entity }
			end
   	end
   end

  # PUT /escalas/1
  # PUT /escalas/1.json
  def update
    @escala = Escala.find(params[:id])
    sequencia = @escala.numero_sequencia.to_i
    sequencia = sequencia + 1
    @escala.numero_sequencia = sequencia

    if @escala.data_execucao < Date.today

    end

    status = @escala.update_attributes(params[:escala])


    if (@escala.tipo_acao.descricao == 'Alteração') or (@escala.tipo_acao.descricao == 'Remoção')
     agendamentos = Agendamento.where('escala_id = ?',@escala.id)
     agendamentos.each do |agendamento|

      #########################################
      #MANDA EMAIL PARA agendamento.cidadao_id#
      #########################################

      agendamento.tipo_situacao_id = TipoAcao.where("descricao = ?","Alteração").first.id
      agendamento.save
     end

     if (@escala.tipo_acao.descricao == 'Alteração' ) #Se Alteracao, refaz a agenda
      #Cria entradas da tabela agendamento para cada escala
      minutos = @escala.horario_fim_execucao - @escala.horario_inicio_execucao #em segundos
      minutos = minutos / 60
      intervalo = minutos / @escala.numero_atendimentos
      for j in 0..(@escala.numero_atendimentos-1)
       @agendamento = Agendamento.new
       @agendamento.orgao_id = @escala.orgao_id
       @agendamento.escala_id = @escala.id
       @agendamento.tipo_situacao_id = TipoSituacao.where("descricao = ?", "Vago").first.id
       @agendamento.horario_inicio_consulta = @escala.horario_inicio_execucao + (j*intervalo*60)
       fim_consulta = j + 1
       @agendamento.horario_fim_consulta = @escala.horario_inicio_execucao + (fim_consulta*intervalo*60)
       @agendamento.save
      end
     end
    end

    respond_to do |format|
      if status
        format.html { redirect_to @escala, notice: 'Escala atualizada com sucesso.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @escala.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /escalas/1
  # DELETE /escalas/1.json
  def destroy
    @escala = Escala.find(params[:id])
    @escala.tipo_acao_id = TipoAcao.where("descricao = ?","Remoção").first.id

		if (@escala.update_attributes(params[:escala]))

    	respond_to do |format|
      	format.html { redirect_to escalas_url }
      	format.json { head :no_content }
    	end
		end
  end

  def remove_escala
    $array_escalas.delete_at(params[:escala_pos].to_i)

    respond_to do |format|
      format.html { redirect_to new_escala_path, notice: 'Escala removida com sucesso.' }
    end
  end

  private
    def valid_profissional_associations
      if current_profissional.orgao.nil?
        redirect_to root_url, alert: "Você não está relacionado a
nenhum local de atendimento, por favor contate o suporte!"
      end
      unless current_profissional.orgao.ativo
        redirect_to root_url, alert: "Você está relacionado a
um local de atendimento inativo (#{current_profissional.orgao.nome}), por favor contate o suporte!"
      end
    end

    def escala_valida_para_alteracao
      escala = Escala.find(params[:id])
      if escala.nil?
        redirect_to escalas_path,
        alert: "Escala inválida"
      end
      unless escala.data_execucao >= Date.today
        redirect_to escalas_path,
        alert: "Escala inválida"
      end
    end
end
