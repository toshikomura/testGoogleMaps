# encoding: UTF-8
class ProfissionaisController < ApplicationController
  before_filter :authenticate_profissional!
  load_and_authorize_resource
  before_filter :valid_profissional_associations, :only =>
[:escalas,:atendimento,:atendimento_update]
  before_filter :escala_valida_para_alteracao, :only =>
[:escalas_prefeitura_edit,:escalas_prefeitura_update]

  $array_escalas = Array.new

  # GET /profissionais
  # GET /profissionais.json
  def index
    @search = Profissional.search(params[:q])
    @profissionais = @search.result
      .paginate(page: params[:page], per_page: 25)

    respond_to do |format|
      format.html # index.html.erb
      format.js   # index.js.erb
      format.json { render json: @profissionais }
    end
  end

  # GET /profissionais/1
  # GET /profissionais/1.json
  def show
    @profissional = Profissional.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @profissional }
    end
  end

  # GET /profissionais/new
  # GET /profissionais/new.json
  def new
    @profissional = Profissional.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @profissional }
    end
  end

  # GET /profissionais/1/edit
  def edit
    @profissional = Profissional.find(params[:id])
  end

  # POST /profissionais
  # POST /profissionais.json
  def create
    @profissional = Profissional.new(params[:profissional])

    respond_to do |format|
      if @profissional.save
        UserMailer.welcome_email(@profissional).deliver #Aqui ele ainda não criptografou a senha
        format.html { redirect_to @profissional, notice: "Profissional: #{@profissional.nome}, criado com sucesso." }
        format.json { render json: @profissional, status: :created, location: @profissional }
      else
        format.html { render action: "new" }
        format.json { render json: @profissional.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /profissionais/1
  # PUT /profissionais/1.json
  def update
    @profissional = Profissional.find(params[:id])

    respond_to do |format|
      if @profissional.update_attributes(params[:profissional])
        format.html { redirect_to @profissional, notice: "Profissional: #{@profissional.nome}, atualizado com sucesso." }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @profissional.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profissionais/1
  # DELETE /profissionais/1.json
  def destroy
    @profissional = Profissional.find(params[:id])
    @profissional.destroy

    respond_to do |format|
      format.html { redirect_to profissionais_url, notice: "Profissional excluído com sucesso." }
      format.json { head :no_content }
    end
  end

  # GET /profissionais/escalas
  def escalas
    @search = Escala.search(params[:q])
    @escalas = @search.result
      .where(:profissional_executor_id => current_profissional.id)
      .order("data_execucao ASC")
      .paginate(page: params[:page], per_page: 25)

    respond_to do |format|
      format.html # escalas.html.erb
      format.js   # escalas.js.erb
      format.json { render json: @escalas }
    end
  end

  # GET /profissionais/escalas_prefeitura
  # GET /profissionais/escalas_prefeitura.json  
  def escalas_prefeitura
    @search = Escala.search(params[:q])
    @escalas = @search.result
      .order("data_execucao ASC")
      .paginate(page: params[:page], per_page: 25)

    respond_to do |format|
      format.html # escalas_prefeitura.html.erb
      format.js   # escalas_prefeitura.js.erb
      format.json { render json: @escalas }
    end
  end

  # GET /profissionais/escalas_prefeitura_show/1
  # GET /profissionais/escalas_prefeitura_show/1.json  
  def escalas_prefeitura_show
    @escala = Escala.find(params[:id_escala])

    respond_to do |format|
      format.html # escalas_prefeitura_show.html.erb
      format.json { render json: @escala }
    end
  end

  # GET /profissionais/escalas_prefeitura_new
  # GET /profissionais/escalas_prefeitura_new.json
  def escalas_prefeitura_new
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
      format.html # escalas_prefeitura_new.html.erb
      format.json { render json: @escala }
    end
   end
  end

  # GET /profissionais/escalas_prefeitura/1/edit
  def escalas_prefeitura_edit
    @escala = Escala.find(params[:id_escala])
  end

  # POST /escalas_prefeitura
  # POST /escalas_prefeitura.json
  def escalas_prefeitura_create
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
                    format.html { redirect_to profissionais_escalas_prefeitura_path, notice: "Escala(s) criada(s) com sucesso" }
                    format.json { render json: @escala, status: :created, location: @escala}
                    end
    else
      flash[:scale_alert] = "Uma ou mais escala(s) possuem conflito de horário com uma escala já criada."
            respond_to do |format|
                format.html { redirect_to profissionais_escala_prefeitura_new_path}
                format.json { render json: @escala.errors, status: unprocessable_entity }
            end
    end
   end

  # PUT /profisionais/escalas_prefeitura/1
  # PUT /profissionais/escalas_prefeitura/1.json
  def escalas_prefeitura_update
    @escala = Escala.find(params[:id_escala])
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
        format.html { redirect_to profissionais_escalas_prefeitura_show_path(@escala), notice: 'Escala atualizada com sucesso.' }
        format.json { head :no_content }
      else
        format.html { render action: "escalas_prefeitura_edit" }
        format.json { render json: @escala.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profissionais/escalas_prefeitura/1
  # DELETE /profissionais/escalas_prefeitura/1.json
  def escalas_prefeitura_destroy
    @escala = Escala.find(params[:id_escala])
    @escala.tipo_acao_id = TipoAcao.where("descricao = ?","Remoção").first.id

        if (@escala.update_attributes(params[:escala]))

        respond_to do |format|
        format.html { redirect_to profissionais_escalas_prefeitura_path }
        format.json { head :no_content }
        end
        end
  end

  def escalas_prefeitura_remove_escala
    $array_escalas.delete_at(params[:escala_pos].to_i)

    respond_to do |format|
      format.html { redirect_to profissionais_escalas_prefeitura_new_path , notice: 'Escala removida com sucesso.' }
    end
  end

  # GET /profissionais/atendimento
  def atendimento
    @search = Agendamento.search(params[:q])
    @profissional = current_profissional
    @data = Date.today
    @agendamentos = @search.result
      .joins(:escala)
      .where(:escalas => { :profissional_executor_id => @profissional.id })
      .where("horario_inicio_consulta >= ?", @data.beginning_of_day)
      .where("horario_fim_consulta <= ?", @data.end_of_day)
      .paginate(page: params[:page], per_page: 25)

    respond_to do |format|
      format.html # atendimento.html.erb
      format.js   # atendimento.js.erb
      format.json {render json: @agendamentos}
    end
  end

  # PUT /profissionais/atendimento_update
  # POST /profissionais/atendimento_update
  def atendimento_update
    @agendamento = Agendamento.find(params[:agendamento_id])
    situacao = TipoSituacao.find(params[:agendamento][:tipo_situacao_id])
    cidadao_id = @agendamento.cidadao.id

    respond_to do |format|
      if ((situacao.id != @agendamento.tipo_situacao_id) &&
      (@agendamento.tipo_situacao.descricao == "Agendado"))

        if (situacao.descricao == "Não Compareceu")
          prefeitura = Prefeitura.first
          cidadao_faltas = Agendamento.cidadao_faltas(@agendamento.cidadao).periodo(prefeitura.periodo_agendamentos).count + 1
          if (cidadao_faltas >= prefeitura.max_faltas)
            bloqueio = Bloqueio.new(:data_entrada => Date.today,
                                 :data_expira => prefeitura.dias_bloqueio.days.from_now.to_date,
                                 :cidadao_id => cidadao_id)
            bloqueio.save!
          end
        end
        if (@agendamento.update_attributes(:tipo_situacao_id => situacao.id, :cidadao_id => cidadao_id))
        format.html {redirect_to profissionais_atendimento_path,
          notice: "Situação do agendamento atualizada como: #{@agendamento.tipo_situacao.descricao}."}
        else
          format.html {redirect_to profissionais_atendimento_path,
          warning: "Erro: Situação do agendamento não pode ser atualizada."}
        end
    else
        format.html {redirect_to profissionais_atendimento_path}
      end
    end
  end

  private
    def valid_profissional_associations
      if current_profissional.orgao.nil?
        redirect_to root_url,
        alert: "Você não está relacionado a nenhum local de atendimento, por favor contate o suporte!"
      end
      unless current_profissional.orgao.ativo
        redirect_to root_url,
        alert: "Você está relacionado a um local de atendimento inativo (#{current_profissional.orgao.nome}), por favor contate o suporte!"
      end
    end

    def escala_valida_para_alteracao
      escala = Escala.find(params[:id_escala])
      if escala.nil?
        redirect_to profissionais_escalas_prefeitura_path,
        alert: "Escala inválida"
      end
      unless escala.data_execucao >= Date.today
        redirect_to profissionais_escalas_prefeitura_path,
        alert: "Escala inválida"
      end
    end
end
