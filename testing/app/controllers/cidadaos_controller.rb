# encoding: UTF-8
class CidadaosController < ApplicationController
  before_filter :authenticate_cidadao!
  before_filter :situacao_bloqueio_cidadao, :only => [:schedule_agreement,
:schedule_select_service, :schedule_select_facility, :schedule_select_month,
:schedule_select_day, :schedule_select_time, :schedule_finish, :schedule_save]

  # GET /cidadaos/agendamentos
  def index
    redirect_to cidadaos_agendamentos_termo_compromisso_path
  end

  # GET /cidadaos/agendamentos/1/confirmar
  def edit
    @agendamento = Agendamento.find(params[:id])
    @profissional_responsavel = Profissional.find(@agendamento.escala.profissional_executor_id) unless (@agendamento.nil? or @agendamento.escala.nil?)

    @tipo_situacao_agendado = TipoSituacao.find_by_descricao("Agendado").id
    @num_agendamentos = Agendamento.where("cidadao_id = ? AND tipo_situacao_id = ?", current_cidadao.id, @tipo_situacao_agendado).count
  end

  # PUT /cidadaos/agendamentos/1
  def update
    @agendamento = Agendamento.find(params[:id])
    @tipo_situacao_agendado = TipoSituacao.find_by_descricao("Agendado").id
    @num_agendamentos = Agendamento.where("cidadao_id = ? AND tipo_situacao_id = ?", current_cidadao.id, @tipo_situacao_agendado).count
    @bloqueio = Bloqueio.where("cidadao_id = ?", current_cidadao.id).order("data_expira DESC").first
    @max_agendamentos = Prefeitura.first.max_agendamentos

    unless @bloqueio.nil?
      @data_expira = @bloqueio.data_expira
    else
      @data_expira = Date.today
    end

    respond_to do |format|
      if (Date.today < @data_expira or @num_agendamentos >= @max_agendamentos)
        format.html { redirect_to cidadaos_path, notice: 'Você não pode efetuar novos agendamentos!' }
        format.json { head :no_content }
      elsif @agendamento.update_attributes(params[:agendamento])
        format.html { redirect_to cidadaos_agendamentos_historico_path, notice: 'O agendamento foi confirmado com sucesso!' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @agendamento.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cidadaos/agendamentos/1
  def destroy
    @agendamento = Agendamento.find(params[:id], :lock => true)
    unless @agendamento.nil? and @agendamento.tipo_situacao.descricao = "Agendado"
      @agendamento.tipo_situacao_id = TipoSituacao.find_by_descricao("Vago").id
      @agendamento.cidadao_id = nil
      @agendamento.observacao = ""
      @agendamento.save!
    end

    respond_to do |format|
      format.html { redirect_to cidadaos_agendamentos_historico_path }
      format.json { head :no_content }
    end
  end

  # GET /cidadaos/agendamentos/historico
  def history
    @search = Agendamento.historico(current_cidadao).search(params[:q])
    @agendamentos = @search.result.paginate(:page => params[:page], :per_page => 25)
    @num_agendamentos = Agendamento.cidadao_agendados(current_cidadao).count
    @bloqueio = Bloqueio.situacao(current_cidadao).first
    @limite_cancelamento = Prefeitura.first.limite_cancelamento
    @max_agendamentos = Prefeitura.first.max_agendamentos
    @pode_cancelar = @agendamentos.any? { |agendamento|
    agendamento.pode_cancelar?(DateTime.now + @limite_cancelamento.hours,
                               Date.today)
    }

    respond_to do |format|
      format.html # history.html.erb
      format.js   # history.js.erb 
      format.json { render json: @agendamentos }
    end
  end

  # GET /cidadaos/agendamentos/termo_compromisso
  def schedule_agreement
    @bloqueio = Bloqueio.situacao(current_cidadao).first
    @cidadao_agendamentos = Agendamento.cidadao_agendados(current_cidadao).count
    @max_agendamentos = Prefeitura.first.max_agendamentos

    unless params[:termo_aceito].nil?
      redirect_to cidadaos_agendamentos_selecionar_tipo_atendimento_path
    else
      respond_to do |format|
        format.html
      end
    end
  end

  # GET /cidadaos/agendamentos/selecionar_tipo_atendimento
  def schedule_select_service
    session[:tipo_atendimento_id] = nil
    session[:orgao_id] = nil
    session[:agendamento_mes] = nil
    session[:agendamento_data] = nil
    session[:agendamento_id] = nil
    session[:erro_salvar] = nil
    session[:erro_agendado] = nil

    if params[:anterior]
      return redirect_to cidadaos_agendamentos_termo_compromisso_path
    end

    @bloqueio = Bloqueio.situacao(current_cidadao).first
    @cidadao_agendamentos = Agendamento.cidadao_agendados(current_cidadao).count
    @max_agendamentos = Prefeitura.first.max_agendamentos
    @tipo_atendimentos = TipoAtendimento.where(:ativo => true)

    unless params[:tipo_atendimento].nil?
      unless params[:tipo_atendimento][:id].nil? or params[:tipo_atendimento][:id].empty?
        @tipo_atendimento = TipoAtendimento.where("ativo = ?", true).where("id = ?", params[:tipo_atendimento][:id]).first
        unless @tipo_atendimento.nil?
          session[:tipo_atendimento_id] = @tipo_atendimento.id
          redirect_to cidadaos_agendamentos_selecionar_orgao_path
        end
      end
    else
      respond_to do |format|
        format.html
      end
    end
  end

  # GET /cidadaos/agendamentos/selecionar_orgao
  def schedule_select_facility
    session[:orgao_id] = nil
    session[:agendamento_mes] = nil
    session[:agendamento_data] = nil
    session[:agendamento_id] = nil
    session[:erro_salvar] = nil
    session[:erro_agendado] = nil

    if params[:anterior]
      session[:orgao_id] = nil
      return redirect_to cidadaos_agendamentos_selecionar_tipo_atendimento_path
    end

    unless session[:tipo_atendimento_id].nil?
      @orgaos = Orgao.where("orgaos.ativo = ?", true).tipo_atendimento(session[:tipo_atendimento_id].to_i)

      unless params[:orgao].nil?
        unless params[:orgao][:id].nil? or params[:orgao][:id].empty?
          @orgao = Orgao.where("ativo = ?", true).where("id = ?", params[:orgao][:id]).first
          unless @orgao.nil?
            session[:orgao_id] = @orgao.id
            redirect_to cidadaos_agendamentos_selecionar_dia_path
          end
        end
      else
        respond_to do |format|
          format.html
        end
      end
    else
      session[:tipo_atendimento_id] = nil
      redirect_to cidadaos_agendamentos_selecionar_tipo_atendimento_path
    end
  end

  # GET /cidadaos/agendamentos/selecionar_dia
  def schedule_select_day
    session[:agendamento_data] = nil
    session[:agendamento_id] = nil
    session[:erro_salvar] = nil
    session[:erro_agendado] = nil

    if params[:anterior]
      session[:orgao_id] = nil
      return redirect_to cidadaos_agendamentos_selecionar_orgao_path
    elsif session[:orgao_id].nil? or session[:tipo_atendimento_id].nil?
      session[:orgao_id] = session[:tipo_atendimento] = nil
      redirect_to cidadaos_agendamentos_selecionar_tipo_atendimento_path
    else
      data = Date._strptime(params[:data_calendario], "%Y_%m") if params[:data_calendario]
      unless data.nil?
        @data_agendamento = Time.new(data[:year], data[:mon], 1)
      else
        @data_agendamento = Time.now
      end

      if params[:mes_anterior]
        @data_agendamento -= 1.month unless @data_agendamento.eql?(Time.now)
      elsif params[:mes_proximo]
        @data_agendamento += 1.month unless @data_agendamento > (Time.now + 3.months)
      elsif params[:dia_agendamento]
        session[:agendamento_data] = @data_agendamento.to_date.change(:day => params[:dia_agendamento].to_i)
        return redirect_to cidadaos_agendamentos_selecionar_horario_path
      end

      if @data_agendamento.month.eql?(Time.now.month)
        @data_agendamento = Time.now
      end

      @agendamentos = Agendamento.joins(escala: { orgao: :tipo_atendimentos })
        .where(:tipo_atendimentos => {:ativo => true, :id => session[:tipo_atendimento_id].to_i})
        .where(:orgaos => {:ativo => true, :id => session[:orgao_id].to_i})
        .where(:escalas => {:tipo_atendimento_id => session[:tipo_atendimento_id].to_i})
        .where(:agendamentos => {:tipo_situacao_id => TipoSituacao.find_by_descricao('Vago').id})
        .intervalo(@data_agendamento, @data_agendamento.end_of_month)

      respond_to do |format|
        format.html
      end
    end
  end

  # GET /cidadaos/agendamentos/selecionar_horario
  def schedule_select_time
    session[:agendamento_id] = nil
    session[:erro_salvar] = nil
    session[:erro_agendado] = nil

    if params[:anterior]
      session[:agendamento_data] = nil
      return redirect_to cidadaos_agendamentos_selecionar_dia_path
    end

    unless session[:agendamento_data].nil? or session[:tipo_atendimento_id].nil? or session[:orgao_id].nil?
      @data_agendamento = session[:agendamento_data]
      @orgao = Orgao.where("id = ?", session[:orgao_id]).first
      @tipo_atendimento = TipoAtendimento.where("id = ?", session[:tipo_atendimento_id]).first

      if Date.today.eql? @data_agendamento
        @horario_inicio = DateTime.new(@data_agendamento.year, @data_agendamento.month, @data_agendamento.day, DateTime.current.hour, DateTime.current.min)
      else
        @horario_inicio = DateTime.new(@data_agendamento.year, @data_agendamento.month, @data_agendamento.day, @data_agendamento.beginning_of_day.hour, @data_agendamento.beginning_of_day.min)
      end

      @horario_termino = @horario_inicio.change(:hour => @data_agendamento.end_of_day.hour, :min => @data_agendamento.end_of_day.min)

      if Date.valid_date?(@data_agendamento.year, @data_agendamento.month, @data_agendamento.day) and @data_agendamento >= Date.today and (not @orgao.nil?) and (not @tipo_atendimento.nil?)
        @agendamentos = Agendamento.joins(escala: {orgao: :tipo_atendimentos})
          .where(:tipo_atendimentos => {:ativo => true, :id => session[:tipo_atendimento_id].to_i})
          .where(:orgaos => {:ativo => true, :id => session[:orgao_id].to_i})
          .where(:escalas => {:tipo_atendimento_id => session[:tipo_atendimento_id].to_i})
          .where(:agendamentos => {:tipo_situacao_id => TipoSituacao.find_by_descricao('Vago').id})
          .intervalo(@horario_inicio, @horario_termino)
          .order("horario_inicio_consulta ASC")

        unless params[:agendamento].nil?
          unless params[:agendamento][:id].nil?
            @agendamentos.each do |agendamento|
              if agendamento.id == params[:agendamento][:id].to_i
                session[:agendamento_id] = params[:agendamento][:id].to_i
                break
              else
                session[:agendamento_id] = nil
              end
            end
          end
        end

        if session[:agendamento_id].nil?
          respond_to do |format|
            format.html
          end
        else
          redirect_to cidadaos_agendamentos_finalizar_path
        end

        return
      end
    end

    session[:tipo_atendimento_id] = nil
    session[:orgao_id] = nil
    session[:agendamento_mes] = nil
    session[:agendamento_data] = nil
    redirect_to cidadaos_agendamentos_selecionar_tipo_atendimento_path
  end

  # GET /cidadaos/agendamentos/finalizar
  def schedule_finish
    unless session[:agendamento_id].nil?
      @agendamento = Agendamento.find_by_id(session[:agendamento_id].to_i)

      respond_to do |format|
        format.html
      end
    else
      redirect_to cidadaos_agendamentos_selecionar_tipo_atendimento_path
    end
  end

  # PUT /cidadaos/agendamentos/salvar_agendamento
  def schedule_save
    if params[:anterior]
      session[:agendamento_id] = nil
      return redirect_to cidadaos_agendamentos_selecionar_horario_path
    end

    unless session[:agendamento_id].nil?
      @agendamento = Agendamento.find_by_id(session[:agendamento_id].to_i, :lock => true)
      @tipo_situacao_vago = TipoSituacao.find_by_descricao("Vago")
      unless @agendamento.tipo_situacao_id != @tipo_situacao_vago.id
        @tipo_situacao_agendado = TipoSituacao.find_by_descricao("Agendado")
        @agendamento.cidadao_id = current_cidadao.id
        @agendamento.tipo_situacao_id = @tipo_situacao_agendado.id
        @agendamento.observacao = params[:observacao] unless (params[:observacao].nil? or params[:observacao].empty?)

        if @agendamento.save!
          session[:tipo_atendimento_id] = nil
          session[:orgao_id] = nil
          session[:agendamento_mes] = nil
          session[:agendamento_data] = nil
          session[:agendamento_id] = nil
          session[:erro_salvar] = nil
          session[:erro_bloqueado] = nil
          session[:erro_agendado] = nil
          respond_to do |format|
            format.html { redirect_to cidadaos_agendamentos_historico_path, notice: "Agendamento confirmado com sucesso!" }
          end
        else
          session[:erro_salvar] = true
          redirect_to cidadaos_agendamentos_finalizar_path
        end
      else
        session[:erro_agendado] = true
        session[:agendamento_id] = nil
        redirect_to cidadaos_agendamentos_selecionar_horario_path
      end
    else
      redirect_to cidadaos_agendamentos_selecionar_horario_path
    end
  end

  private
    def situacao_bloqueio_cidadao
      prefeitura = Prefeitura.first
      bloqueio = Bloqueio.situacao(current_cidadao).first
      num_agendamentos = Agendamento.cidadao_agendados(current_cidadao).count
      if (bloqueio && bloqueio.data_expira > Date.today) ||
        (num_agendamentos >= prefeitura.max_agendamentos)
        redirect_to cidadaos_agendamentos_historico_path,
        alert: "Você está impedido de efetuar agendamentos"
      end
    end
end
