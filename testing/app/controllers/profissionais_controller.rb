# encoding: UTF-8
class ProfissionaisController < ApplicationController
  before_filter :authenticate_profissional!
  load_and_authorize_resource
  before_filter :valid_profissional_associations, :only =>
[:escalas,:atendimento,:atendimento_update]

  # GET /profissionais
  # GET /profissionais.json
  def index
    @search = Profissional.search(params[:q])
    @profissionais = @search.result

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
    @escalas = @search.result.where("profissional_executor_id = ?",
current_profissional.id).order("data_execucao ASC")

    respond_to do |format|
      format.html # escalas.html.erb
      format.js   # escalas.js.erb 
      format.json { render json: @escalas }
    end
  end

  # GET /profissionais/atendimento
  def atendimento
    @search = Agendamento.search(params[:q])
	@profissional = current_profissional
    @data = Date.today
	@agendamentos = @search.result.joins(:escala).where("
        profissional_executor_id = ? AND
        horario_inicio_consulta >= ? AND
        horario_fim_consulta <= ?",
        @profissional.id,@data.beginning_of_day,
        @data.end_of_day).order("horario_inicio_consulta ASC")

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
            bloqueio = Bloqueio.new(:data_entrada => DateTime.now,
                                 :data_expira => prefeitura.dias_bloqueio.days.from_now,
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
end
