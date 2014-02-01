# coding: utf-8
class AgendamentosReport < Prawn::Document
  def to_pdf( table_prefeitura, table_local_atendimento, table_agendamentos, data_inicio, data_fim, p_cidadao, p_tipo_atendimento, p_tipo_situacao)

    @prefeitura = table_prefeitura
    @orgao = table_local_atendimento
    @data_inicio = data_inicio
    @data_fim = data_fim
    @p_cidadao = p_cidadao
    @p_tipo_atendimento = p_tipo_atendimento
    @p_tipo_situacao = p_tipo_situacao

    header_report

    @agendamentos = table_agendamentos
    @localizadores = ["Cidadão", "", "Agendamento", "", "", ""]
    @atributos = ["CPF", "Nome", "Tipo Atendimento", "Horário de Inicio", "Horário de Fim", "Situação"]

    if @p_cidadao.present?
      @localizadores.delete_if { |item| item.eql?("Cidadão") }
      @localizadores.delete_at(0)
      @atributos.delete_if { |item| item.eql?("CPF") }
      @atributos.delete_if { |item| item.eql?("Nome") }
    end

    if @p_tipo_atendimento.present?
      @localizadores.pop
      @atributos.delete_if { |item| item.eql?("Tipo Atendimento") }
    end

    if @p_tipo_situacao.present?
      @localizadores.pop
      @atributos.delete_if { |item| item.eql?("Situação") }
    end

    line_table

    footer

    render
  end

  def header_report

    @data = [
      [ "Agendamentos de #{@data_inicio.strftime("%d/%m/%y")} a #{@data_fim.strftime("%d/%m/%y")}"],
      ["#{@prefeitura.nome}"],
      ["#{@orgao.nome}"],
    ]

    if @p_cidadao.present?
      @data.push(["CPF: #{@p_cidadao.cpf} Nome: #{@p_cidadao.nome}"])
    end

    if @p_tipo_atendimento.present?
      @data.push(["Tipo: #{@p_tipo_atendimento.descricao}"])
    end

    if @p_tipo_situacao.present?
      @data.push(["Situação: #{@p_tipo_situacao.descricao}"])
    end

    table( @data, :width => 523) do
      cells_padding = 12
      cells.width = 523
      cells_height = 50
      row(0).font_style = :bold
      row(0).align = :center
    end
  end

  def line_table
    # necessidade de variável local, pois se perde o valor de @p_cidadao
    # por causa da grande quantidade de dados geradas abaixo no data_table
    atendimento = @p_tipo_atendimento
    cidadao = @p_cidadao
    tipo_situacao = @p_tipo_situacao

    move_down 20
    table line_table_rows do

      self.width = 523
      row(0..1).font_style = :bold
      columns(0..5).align = :left

      unless cidadao.present?
        columns(0).width = 73
      end

      # Definindo tamanho dos campos
      # A menos que todos os atributos possiveis sejam escolhidos
      unless cidadao.present? and atendimento.present? and tipo_situacao.present?
        if cidadao.present? and atendimento.present?
          columns(0).width = 70
          columns(1).width = 70
        elsif cidadao.present?
          columns(1).width = 70
          columns(2).width = 70
        elsif atendimento.present?
          columns(2).width = 70
          columns(3).width = 70
        else
          columns(3).width = 70
          columns(4).width = 70
        end
      end

      self.cell_style = { size: 9} # Atenção o tamanho dos textos deste relatório é menor
      self.row_colors = [ "DDDDDD", "FFFFFF"]
      self.header = true
    end
  end

  def line_table_rows

    [ @localizadores] +
    [ @atributos] +
    data_table
  end

  def data_table

    @agendamentos.map do |agendamento|
      @data_cell_table = [] # apaga array temporaria para a próxima iteração

      unless @p_cidadao.present?
        if agendamento.cidadao.nil?
          @data_cell_table.push("")
        else
          @data_cell_table.push(agendamento.cidadao.cpf)
        end
        if agendamento.cidadao.nil?
          @data_cell_table.push("")
        else
          @data_cell_table.push(agendamento.cidadao.nome)
        end
      end

      unless @p_tipo_atendimento.present?
        @data_cell_table.push(agendamento.escala.tipo_atendimento.descricao)
      end
      @data_cell_table.push(agendamento.horario_inicio_consulta.strftime("%H:%M %d/%m/%y"))
      @data_cell_table.push(agendamento.horario_fim_consulta.strftime("%H:%M %d/%m/%y"))

      unless @p_tipo_situacao.present?
        @data_cell_table.push(agendamento.tipo_situacao.descricao)
      end

      @data_cell_table # coloca array temporaria na tabela do relatório
    end
  end

  def footer

    number_pages "Gerado em: #{DateTime.now.strftime("%H:%M %d/%m/%y")}",
                                    :at => [bounds.left, 0],
                                    :align => :left,
                                    :size => 10

    number_pages "<page>/<total>", {
                                    :start_count_at => 0,
                                    :at => [bounds.right - 50, 0],
                                    :align => :right,
                                    :size => 10
                                   }
  end

end
