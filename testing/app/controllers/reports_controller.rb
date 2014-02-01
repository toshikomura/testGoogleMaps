# encoding: UTF-8
class ReportsController < ApplicationController
  before_filter :authenticate_profissional!
  load_and_authorize_resource

  # GET /reports
  def index

    redirect_to reports_relatorio_tipo_relatorio_path

  end

  # GET /reports/tipo_relatorio
  def schedule_select_type_report

    unless params[:tipo_relatorio].nil?
      redirect_to reports_path
    else
      respond_to do |format|
        format.html
      end
    end

  end

  def select_type_report

    unless params[:report][:id].nil? or params[:report][:id].empty?

      @type_report = Report.find(params[:report][:id])
      unless @type_report.nil?

        if @type_report.description == "Profissionais"
          redirect_to reports_relatorio_profissionais_relatorio_path
        elsif @type_report.description == "Cidadaos"
          redirect_to reports_relatorio_cidadaos_relatorio_path
        elsif @type_report.description == "Escalas"
          redirect_to reports_relatorio_escalas_relatorio_path
        elsif @type_report.description == "Agendamentos"
          redirect_to reports_relatorio_agendamentos_relatorio_path

        else

         respond_to do |format|
            format.pdf { redirect_to reports_path, notice: "Relatório de #{ @type_report.description} inexistente" }
          end

        end
      end

    else

      respond_to do |format|
        format.pdf { redirect_to reports_path, notice: "Relatório nulo" }
      end

    end

  end


  def schedule_select_profissionais_report

    @search = Profissional.search(params[:q])

    @profissionais = @search.result

    @search.build_sort

    respond_to do |format|
      format.html
    end

  end

  def generate_profissionais_report

    respond_to do |format|
      format.pdf {

        @prefeitura = Prefeitura.first

        if current_profissional.orgao.nil?
          @orgao = ""
        else
          @orgao = current_profissional.orgao
        end

        @search = Profissional.search(params[:q])

        @profissionais = @search.result

        # Se foi escolhido um cpf profissional
        unless params["q"]["cpf_eq"].nil? or params["q"]["cpf_eq"].empty?
          @p_profissional = Profissional.where("cpf = ?", params["q"]["cpf_eq"]).first
        end

        # Se foi escolhido um local de atendimento
        unless params["q"]["orgao_id_eq"].nil? or params["q"]["orgao_id_eq"].empty?
          @p_local_atendimento = Orgao.find(params["q"]["orgao_id_eq"])
        end

        # Se foi escolhido uma permissão
        unless params["q"]["role_eq"].nil? or params["q"]["role_eq"].empty?
          @p_permissao = params["q"]["role_eq"]
        end

        # Se foi escolhido uma ocupação
        unless params["q"]["tcbo_id_eq"].nil? or params["q"]["tcbo_id_eq"].empty?
          @p_ocupacao = Tcbo.find(params["q"]["tcbo_id_eq"])
        end

        # Se foi escolhido uma situação
        unless params["q"]["ativo_eq"].nil? or params["q"]["ativo_eq"].empty?
          @p_situacao = params["q"]["ativo_eq"]
        end

        report = ProfissionaisReport.new(:page_size => [595.28, 841.89]).to_pdf( @prefeitura, @orgao, @profissionais, @p_profissional, @p_local_atendimento, @p_permissao, @p_ocupacao, @p_situacao)
        send_data report, filename: "profissionais.pdf",
                          type: "application/pdf"
      }
    end
  end

  def schedule_select_cidadaos_report

    @search = Cidadao.search(params[:q])

    @cidadaos = @search.result

    @search.build_sort

    respond_to do |format|
      format.html
    end

  end

  def generate_cidadaos_report

    respond_to do |format|
      format.pdf {

        @prefeitura = Prefeitura.first

        if current_profissional.orgao.nil?
          @orgao = ""
        else
          @orgao = current_profissional.orgao
        end

        @search = Cidadao.search(params[:q])

        @cidadaos = @search.result

        # Se foi escolhido um cpf cidadão
        unless params["q"]["cpf_eq"].nil? or params["q"]["cpf_eq"].empty?
          @p_cidadao = Cidadao.where("cpf = ?", params["q"]["cpf_eq"]).first
        end

        report = CidadaosReport.new(:page_size => [595.28, 841.89]).to_pdf( @prefeitura, @orgao, @cidadaos, @p_cidadao)
        send_data report, filename: "cidadaos.pdf",
                          type: "application/pdf"
      }
    end
  end

  def schedule_select_escalas_report

    @search = Escala.search(params[:q])
    @escalas = @search.result.where("orgao_id = ?",
    current_profissional.orgao.id)

    @search.build_sort

    respond_to do |format|
      format.html
    end

  end

  def generate_escalas_report

    respond_to do |format|
      format.pdf {

        @prefeitura = Prefeitura.first

        @search = Escala.search(params[:q])
        if current_profissional.orgao.nil?
          @escalas = []
          @orgao = ""
        else
          @escalas = @search.result.where("orgao_id = ?",
          current_profissional.orgao.id)

          @orgao = current_profissional.orgao
        end

        @data_inicio = Date.new(
                                params["q"]["data_execucao_gteq(1i)"].to_i,
                                params["q"]["data_execucao_gteq(2i)"].to_i,
                                params["q"]["data_execucao_gteq(3i)"].to_i
                                )
        @data_fim = Date.new(
                                params["q"]["data_execucao_lteq(1i)"].to_i,
                                params["q"]["data_execucao_lteq(2i)"].to_i,
                                params["q"]["data_execucao_lteq(3i)"].to_i
                                )

        # Se foi escolhido um profissional
        unless params["q"]["profissional_executor_id_eq"].nil? or params["q"]["profissional_executor_id_eq"].empty?
          @p_profissional = Profissional.find(params["q"]["profissional_executor_id_eq"])
        end

        # Se foi escolhido um tipo de atendimento
        unless params["q"]["tipo_atendimento_id_eq"].nil? or params["q"]["tipo_atendimento_id_eq"].empty?
          @p_tipo_atendimento = TipoAtendimento.find(params["q"]["tipo_atendimento_id_eq"])
        end

        # Se foi escolhido um tipo de ação
        unless params["q"]["tipo_acao_id_eq"].nil? or params["q"]["tipo_acao_id_eq"].empty?
          @p_tipo_acao = TipoAcao.find(params["q"]["tipo_acao_id_eq"])
        end

        report = EscalasReport.new(:page_size => [595.28, 841.89]).to_pdf( @prefeitura, @orgao, @escalas, @data_inicio, @data_fim, @p_profissional, @p_tipo_atendimento, @p_tipo_acao)
        send_data report, filename: "escalas.pdf",
                          type: "application/pdf"
      }
    end
  end

  def schedule_select_agendamentos_report

    @search = Agendamento.search(params[:q])
    @agendamentos = @search.result

    @search.build_sort

    respond_to do |format|
      format.html
    end
  end

  def generate_agendamentos_report
    respond_to do |format|
      format.pdf {

        @prefeitura = Prefeitura.first

        if current_profissional.orgao.nil?
          @orgao = ""
        else
          @orgao = current_profissional.orgao
        end

        @search = Agendamento.search(params[:q])

        @agendamentos = @search.result

        @data_inicio = Date.new(
                                params["q"]["escala_data_execucao_gteq(1i)"].to_i,
                                params["q"]["escala_data_execucao_gteq(2i)"].to_i,
                                params["q"]["escala_data_execucao_gteq(3i)"].to_i
                                )
        @data_fim = Date.new(
                                params["q"]["escala_data_execucao_lteq(1i)"].to_i,
                                params["q"]["escala_data_execucao_lteq(2i)"].to_i,
                                params["q"]["escala_data_execucao_lteq(3i)"].to_i
                                )

        # Se foi escolhido um cpf cidadão
        unless params["q"]["cidadao_cpf_eq"].nil? or params["q"]["cidadao_cpf_eq"].empty?
          @p_cidadao = Cidadao.where("cpf = ?", params["q"]["cidadao_cpf_eq"]).first
        end

        # Se foi escolhido um tipo de atendimento
        unless params["q"]["escala_tipo_atendimento_id_eq"].nil? or params["q"]["escala_tipo_atendimento_id_eq"].empty?
          @p_tipo_atendimento = TipoAtendimento.find(params["q"]["escala_tipo_atendimento_id_eq"])
        end

        # Se foi escolhido um tipo de situação
        unless params["q"]["tipo_situacao_id_eq"].nil? or params["q"]["tipo_situacao_id_eq"].empty?
          @p_tipo_situacao = TipoSituacao.find(params["q"]["tipo_situacao_id_eq"])
        end

        report = AgendamentosReport.new(:page_size => [595.28, 841.89]).to_pdf( @prefeitura, @orgao, @agendamentos, @data_inicio, @data_fim, @p_cidadao, @p_tipo_atendimento, @p_tipo_situacao)
        send_data report, filename: "agendamentos.pdf",
                          type: "application/pdf"
        }
    end
  end

end
