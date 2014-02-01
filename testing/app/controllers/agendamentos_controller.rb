# encoding: utf-8
class AgendamentosController < ApplicationController
  before_filter :authenticate_profissional!
  load_and_authorize_resource
  before_filter :valid_profissional_associations
  before_filter :agendamento_valido, :only => [:edit,:update]

  # GET /agendamentos
  # GET /agendamentos.json
  def index
    @search = Agendamento.search(params[:q])
    @tipo_situacao = TipoSituacao.find_by_descricao("Vago")
    @agendamentos = @search.result
      .joins(:escala => { :orgao => :profissionais })
      .where(:profissionais => { :id => current_profissional.id })
      .where(:tipo_situacao_id => @tipo_situacao.id)
      .where("escalas.data_execucao >= ?", Date.today)
      .order("horario_inicio_consulta ASC")
      .paginate(:page => params[:page], :per_page => 25)

    if params[:cpf].nil?
      @cidadao = Cidadao.where(:cpf => session[:cpf]).first unless session[:cpf].nil?
    else
      @cidadao = Cidadao.where(:cpf => params[:cpf]).first
      session[:cpf] = params[:cpf] unless @cidadao.nil?
    end

    if @cidadao.nil? and params[:cpf]
      @form_error = "O CPF digitado é inválido ou o cidadão não foi cadastrado!"
    end

    if params[:clear_cpf]
      session[:cpf] = nil unless session[:cpf].nil?
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @agendamentos }
    end
  end

  # GET /agendamentos/1
  # GET /agendamentos/1.json
  def show
    @agendamento = Agendamento.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @agendamento }
    end
  end

  # GET /agendamentos/new
  # GET /agendamentos/new.json
  #def new
  #  @agendamento = Agendamento.new
  #
  #  respond_to do |format|
  #    format.html # new.html.erb
  #    format.json { render json: @agendamento }
  #  end
  #end

  # GET /agendamentos/1/edit
  def edit
    @agendamento = Agendamento.find(params[:id])
    @max_agendamentos = Prefeitura.first.max_agendamentos
    @cidadao = Cidadao.where(:cpf => session[:cpf]).first
    if @cidadao.nil?
      session[:cpf] = nil
      @bloqueio = nil
      @cidadao_agendamentos = nil
    else
      @cidadao_agendamentos = Agendamento.where("cidadao_id = ?", @cidadao.id).count
      @bloqueio = Bloqueio.where("cidadao_id = ?", @cidadao.id).order("data_expira DESC").first
    end
  end

  # POST /agendamentos
  # POST /agendamentos.json
  #def create
  #  @agendamento = Agendamento.new(params[:agendamento])
  #
  #  respond_to do |format|
  #    if @agendamento.save
  #      format.html { redirect_to @agendamento, notice: 'Agendamento was successfully created.' }
  #      format.json { render json: @agendamento, status: :created, location: @agendamento }
  #    else
  #      format.html { render action: "new" }
  #      format.json { render json: @agendamento.errors, status: :unprocessable_entity }
  #    end
  # end
  #end

  # PUT /agendamentos/1
  # PUT /agendamentos/1.json
  def update
    if params[:cancelar_agendamento]
        return redirect_to agendamentos_path
    end

    @agendamento = Agendamento.find(params[:id])
    @cidadao = Cidadao.where(:cpf => session[:cpf]).first

    params[:agendamento][:cidadao_id] = @cidadao.id unless @cidadao.nil?
    params[:agendamento][:tipo_situacao_id] = TipoSituacao.where(:descricao => "Agendado").first.id unless @cidadao.nil?

    respond_to do |format|
      if (@agendamento.update_attributes(params[:agendamento])) and (@agendamento.cidadao_id != nil)
        format.html { redirect_to @agendamento, notice: 'Agendamento confirmado com sucesso.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @agendamento.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /agendamentos/1
  # DELETE /agendamentos/1.json
  #def destroy
  #  @agendamento = Agendamento.find(params[:id])
  #  @agendamento.destroy
  #
  #  respond_to do |format|
  #    format.html { redirect_to agendamentos_url }
  #    format.json { head :no_content }
  #  end
  #end

  # GET /agendamentos/atendimento
  def atendimento
    @profissional = current_profissional
    @data = Date.today
    @search = Agendamento.search(params[:q])
    @agendamentos = @search.result
      .where(:orgao_id => @profissional.orgao_id)
      .order("horario_inicio_consulta ASC")
      .paginate(page: params[:page], per_page: 25)

    respond_to do |format|
      format.html # atendimento.html.erb
        format.js   # atendimento.js.erb
      format.json {render json: @agendamentos}
    end
  end

  # PUT /agendamentos/atendimento_update
  # POST /agendamentos/atendimento_update
  def atendimento_update
    @agendamento = Agendamento.find(params[:id])
    situacao = TipoSituacao.find(params[:agendamento][:tipo_situacao_id])
    cidadao_id = @agendamento.cidadao.id
    respond_to do |format|
      if ((situacao.id != @agendamento.tipo_situacao_id) && (@agendamento.tipo_situacao.descricao == "Agendado"))
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
          format.html {redirect_to agendamentos_atendimento_path,
          notice: "Situação do agendamento atualizada como: #{@agendamento.tipo_situacao.descricao}."}
        else
          format.html {redirect_to agendamentos_atendimento_path,
          warning: "Erro: Situação do agendamento não pode ser atualizada."}
        end
      else
        format.html {redirect_to agendamentos_atendimento_path}
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

    def agendamento_valido
      agendamento = Agendamento.find(params[:id])
      if agendamento.nil?
        redirect_to agendamentos_path,
        alert: "Agendamento inválido"
      end
      unless agendamento.escala.data_execucao >= Date.today
        redirect_to agendamentos_path,
        alert: "Agendamento inválido"
      end
    end
end
