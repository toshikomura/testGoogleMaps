# coding: utf-8
require "date"
class CidadaosReport < Prawn::Document
  def to_pdf( table_prefeitura, table_local_atendimento, table_cidadaos, p_cidadao)

    @prefeitura = table_prefeitura
    @orgao = table_local_atendimento
    @p_cidadao = p_cidadao

    header_report

    @cidadaos = table_cidadaos
    @atributos = [ "CPF", "Nome", "RG", "email", "Telefone", "Cartão SUS"]

    if @p_cidadao.present?
      @atributos.delete_if { |item| item.eql?("CPF") }
      @atributos.delete_if { |item| item.eql?("Nome") }
    end

    line_table

    footer

    render
  end

  def header_report
    @data = [
      [ "Relatório dos cidadãos"],
      ["#{@prefeitura.nome}"],
      ["#{@orgao.nome}"]
    ]

    if @p_cidadao.present?
      @data.push(["CPF: #{@p_cidadao.cpf} Nome: #{@p_cidadao.nome}"])
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
    l_cidadao = @p_cidadao

    move_down 20
    table line_table_rows do
      self.width = 523
      row(0).font_style = :bold
      columns(0..5).align = :left

      # Definindo tamanho dos campos
      if l_cidadao.present?
        columns(0).width = 90
      else
        columns(0).width = 94
      end

      unless l_cidadao.present?
        columns(2).width = 90
      end

      self.row_colors = [ "DDDDDD", "FFFFFF"]
      self.header = true
    end
  end

  def line_table_rows

    [ @atributos] +
    data_table
  end

  def data_table

    @cidadaos.map do |cidadao|
      @data_cell_table = [] # apaga array temporaria para a próxima iteração

      unless @p_cidadao.present?
        @data_cell_table.push(cidadao.cpf)
        @data_cell_table.push(cidadao.nome)
      end

      @data_cell_table.push(cidadao.rg)
      @data_cell_table.push(cidadao.email)
      @data_cell_table.push(cidadao.telefone1)
      @data_cell_table.push(cidadao.cartao_sus)

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
