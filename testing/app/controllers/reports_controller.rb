# encoding: UTF-8
class ReportsController < ApplicationController
  before_filter :authenticate_profissional!
  load_and_authorize_resource

  # GET /reports
  def index

    redirect_to reports_relatorio_tipo_relatorio_path

  end

  def show

    unless params[:report][:id].nil? or params[:report][:id].empty?

      @type_report = Report.find(params[:report][:id])
      unless @type_report.nil?

        @prefeitura = Prefeitura.first

        if current_profissional.orgao.nil?
          @orgao = ""
        else
          @orgao = current_profissional.orgao
        end

        if @type_report.description == "Profissionais"
          redirect_to reports_relatorio_profissionais_relatorio_path
#          respond_to do |format|
#            format.pdf {
#              @profissionais = Profissional.all

#              report = ProfissionaisReport.new(:page_size => [595.28, 841.89]).to_pdf( @prefeitura, @orgao, @profissionais)
#              send_data report, filename: "profissionais.pdf",
#                                type: "application/pdf"
#            }
#          end

        elsif @type_report.description == "Cidadaos"
          respond_to do |format|
            format.pdf {
              @cidadaos = Cidadao.all
              report = CidadaosReport.new(:page_size => [595.28, 841.89]).to_pdf( @prefeitura, @orgao, @cidadaos)
              send_data report, filename: "cidadaos.pdf",
                                type: "application/pdf"
            }
          end

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

  def schedule_select_profissionais_report

    @search = Profissional.search(params[:q])

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

        report = ProfissionaisReport.new(:page_size => [595.28, 841.89]).to_pdf( @prefeitura, @orgao, @profissionais)
        send_data report, filename: "profissionais.pdf",
                          type: "application/pdf"
      }
    end
  end

  def schedule_select_escalas_report

    @search = Escala.search(params[:q])

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
          current_profissional.orgao.id).order("data_execucao ASC")
          @orgao = current_profissional.orgao
        end
        report = EscalasReport.new(:page_size => [595.28, 841.89]).to_pdf( @prefeitura, @orgao, @escalas)
        send_data report, filename: "escalas.pdf",
                          type: "application/pdf"
      }
    end
  end

  def schedule_select_agendamentos_report

    @search = Agendamento.search(params[:q])

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

        @agendamentos = @search.result.order("horario_inicio_consulta ASC")

        @data_inicio = params[:q][:escala_data_execucao_gteq]
        @data_fim = params[:q][:escala_data_execucao_lteq]

        Rails.logger.info "#{@data_inicio.inspect}"

        report = AgendamentosReport.new(:page_size => [595.28, 841.89]).to_pdf( @prefeitura, @orgao, @agendamentos, @data_inicio, @data_fim)
        send_data report, filename: "agendamentos.pdf",
                          type: "application/pdf"
        }
    end
  end

end
