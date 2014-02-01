# coding: utf-8
class EscalasReport < Prawn::Document
  def to_pdf( table_prefeitura, table_local_atendimento, table_escalas, data_inicio, data_fim, p_profissional, p_tipo_atendimento, p_tipo_acao)

    @prefeitura = table_prefeitura
    @orgao = table_local_atendimento
    @data_inicio = data_inicio
    @data_fim = data_fim
    @p_profissional = p_profissional
    @p_tipo_atendimento = p_tipo_atendimento
    @p_tipo_acao = p_tipo_acao

    header_report

    @escalas = table_escalas
    @atributos = [ "Profissional", "Tipo de Atendimento", "Data", "Horário Inicio", "Horário Fim", "Ação"]

    if @p_profissional.present?
      @atributos.delete_if { |item| item.eql?("Profissional") }
    end

    if @p_tipo_atendimento.present?
      @atributos.delete_if { |item| item.eql?("Tipo de Atendimento") }
    end

    if @p_tipo_acao.present?
      @atributos.delete_if { |item| item.eql?("Ação") }
    end

    line_table

    footer

    render
  end

  def header_report
    @data = [
      [ "Escalas de #{@data_inicio.strftime("%d/%m/%y")} a #{@data_fim.strftime("%d/%m/%y")}"],
      ["#{@prefeitura.nome}"],
      ["#{@orgao.nome}"]
    ]

    if @p_profissional.present?
      @data.push(["Profissional: #{@p_profissional.nome}"])
    end

    if @p_tipo_atendimento.present?
      @data.push(["Tipo de Atendimento: #{@p_tipo_atendimento.descricao}"])
    end

    if @p_tipo_acao.present?
      @data.push(["Tipo de Ação: #{@p_tipo_acao.descricao}"])
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
    l_profissional = @p_profissional
    tipo_atendimento = @p_tipo_atendimento
    tipo_acao = @p_tipo_acao

    move_down 20
    table line_table_rows do
      self.width = 523
      row(0).font_style = :bold
      columns(0..5).align = :left
      # Definindo tamanho dos campos
      # ...
      self.row_colors = [ "DDDDDD", "FFFFFF"]
      self.header = true
    end
  end

  def line_table_rows

    [ @atributos] +
    data_table
  end

  def data_table

    @escalas.map do |escala|
      @data_cell_table = [] # apaga array temporaria para a próxima iteração

      unless @p_profissional.present?
        if escala.profissional_2.nil?
          @data_cell_table.push("")
        else
          @data_cell_table.push(escala.profissional_2.nome)
        end
      end

      unless @p_tipo_atendimento.present?
        if escala.tipo_atendimento.nil?
          @data_cell_table.push("")
        else
          @data_cell_table.push(escala.tipo_atendimento.descricao)
        end
      end

      @data_cell_table.push(escala.data_execucao.strftime("%d/%m/%Y"))
      @data_cell_table.push(escala.horario_inicio_execucao.strftime("%H:%M"))
      @data_cell_table.push(escala.horario_fim_execucao.strftime("%H:%M"))

      unless @p_tipo_acao.present?
        if escala.tipo_acao.nil?
          @data_cell_table.push("")
        else
          @data_cell_table.push(escala.tipo_acao.descricao)
        end
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
