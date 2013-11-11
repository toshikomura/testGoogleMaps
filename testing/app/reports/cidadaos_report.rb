# coding: utf-8
require "date"
class CidadaosReport < Prawn::Document
  def to_pdf( table_prefeitura, table_local_atendimento, table_cidadaos)

    @prefeitura = table_prefeitura
    @orgao = table_local_atendimento

    header_report

    @cidadaos = table_cidadaos
    @atributos = [ "Nome", "CPF", "RG", "email", "Telefone", "Cartão SUS"]

    line_table

    footer

    render
  end

  def header_report
    data = [
      [ "Relatório dos cidadãos"],
      ["#{@prefeitura.nome}"],
      ["#{@orgao.nome}"]
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
      row(0).font_style = :bold
      columns(0..5).align = :left
      columns(1).width = 95
      columns(2).width = 90
      self.row_colors = [ "DDDDDD", "FFFFFF"]
      self.header = true
    end
  end

  def line_table_rows

    [ @atributos] +
    @cidadaos.map do |cidadao|
      [ cidadao.nome, cidadao.cpf, cidadao.rg, cidadao.email, cidadao.telefone1, cidadao.cartao_sus]
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
