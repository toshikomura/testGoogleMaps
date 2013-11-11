# coding: utf-8
class AgendamentosReport < Prawn::Document
  def to_pdf( table_prefeitura, table_local_atendimento, table_agendamentos, data_inicio, data_fim)

    @prefeitura = table_prefeitura
    @orgao = table_local_atendimento
    @data_inicio = data_inicio
    @data_fim = data_fim

    header_report

    @agendamentos = table_agendamentos
    @localizadores = ["Cidadão", "", "Agendamento", "", "", ""]
    @atributos = ["CPF", "Nome", "Tipo Atendimento", "Horário de Inicio", "Horário de Fim", "Situação"]

    line_table

    footer

    render
  end

  def header_report
    data = [
      [ "Agendamentos de #{@data_inicio.strftime("%d/%m/%y")} a #{@data_fim.strftime("%d/%m/%y")}"],
      ["#{@prefeitura.nome}"],
      ["#{@orgao.nome}"],
    ]

    table( data, :width => 523) do
      cells_padding = 12
      cells.width = 523
      cells_height = 50
      row(0).font_style = :bold
      row(0).align = :center
    end
  end

  def line_table
    move_down 20
    table line_table_rows do
      self.width = 523
      row(0..1).font_style = :bold
      columns(0..5).align = :left
      self.cell_style = { size: 9}
      self.row_colors = [ "DDDDDD", "FFFFFF"]
      self.header = true
    end
  end

  def line_table_rows

    [ @localizadores] +
    [ @atributos] +
    @agendamentos.map do |agendamento|
      [
        if agendamento.cidadao.nil?
          ""
        else
          agendamento.cidadao.cpf
        end,
        if agendamento.cidadao.nil?
          ""
        else
          agendamento.cidadao.nome
        end,
        agendamento.escala.tipo_atendimento.descricao,
        agendamento.horario_inicio_consulta.strftime("%H:%M %d/%m/%y"),
        agendamento.horario_fim_consulta.strftime("%H:%M %d/%m/%y"),
        agendamento.tipo_situacao.descricao
      ]
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
