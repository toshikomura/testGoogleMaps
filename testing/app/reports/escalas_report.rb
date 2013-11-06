# coding: utf-8
class EscalasReport < Prawn::Document
  def to_pdf( table_prefeitura, table_local_atendimento, table_escalas)

    @prefeitura = table_prefeitura
    @orgao = table_local_atendimento

    header_report

    @escalas = table_escalas

    line_table

    footer

    render
  end

  def header_report
    data = [
      [ "Relatório de escalas"],
      ["#{@prefeitura.nome}"],
      ["#{@orgao.nome}"],
      [ "Gerado em: #{DateTime.now.strftime("%H:%M %d-%m-%Y")}"]
    ]

    table( data) do
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
      row(0).font_style = :bold
      columns(0..5).align = :left
      self.row_colors = [ "DDDDDD", "FFFFFF"]
      self.header = true
    end
  end

  def line_table_rows
    [[
      "Profissional",
      "Tipo de Atendimento",
      "Data",
      "Horário Inicio",
      "Horário Fim",
      "Ação"
    ]] +
    @escalas.map do |escala|
      [
        if escala.profissional_2.nil?
          ""
        else
          escala.profissional_2.nome
        end,
        if escala.tipo_atendimento.nil?
          ""
        else
          escala.tipo_atendimento.descricao
        end,
        escala.data_execucao.strftime("%d/%m/%Y"),
        escala.horario_inicio_execucao.strftime("%H:%M"),
        escala.horario_fim_execucao.strftime("%H:%M"),
        if escala.tipo_acao.nil?
          ""
        else
          escala.tipo_acao.descricao
        end
      ]
    end
  end

  def footer
    number_pages "<page>/<total>", {
                                    :start_count_at => 0,
                                    :at => [bounds.right - 50, 0],
                                    :align => :right,
                                    :size => 14
                                   }
  end

end
