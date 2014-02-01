# coding: utf-8
class ProfissionaisReport < Prawn::Document
  def to_pdf( table_prefeitura, table_local_atendimento, table_profissionais, p_profissional, p_local_atendimento, p_permissao, p_ocupacao, p_situacao)

    @prefeitura = table_prefeitura
    @orgao = table_local_atendimento
    @p_profissional = p_profissional
    @p_local_atendimento = p_local_atendimento
    @p_permissao = p_permissao
    @p_ocupacao = p_ocupacao
    @p_situacao = p_situacao

    header_report

    @profissionais = table_profissionais
    @atributos = [ "CPF", "Nome", "RG", "Data Nascimento", "Matricula", "CEP"]

    if @p_profissional.present?
      @atributos.delete_if { |item| item.eql?("CPF") }
      @atributos.delete_if { |item| item.eql?("Nome") }
    end

    line_table

    footer

    render
  end

  def header_report

    @data = [
      [ "Relatório dos profissionais"],
      ["#{@prefeitura.nome}"],
      ["#{@orgao.nome}"]
    ]

    if @p_profissional.present?
      @data.push(["CPF: #{@p_profissional.cpf} Nome: #{@p_profissional.nome}"])
    end

    if @p_local_atendimento.present?
      @data.push(["Local de Atendimento: #{@p_local_atendimento.nome}"])
    end

    if @p_permissao.present?
      @data.push(["Permissão: #{@p_permissao}"])
    end

    if @p_ocupacao.present?
      @data.push(["Ocupação: #{@p_ocupacao.descricao}"])
    end

    if @p_situacao.present?
      if @p_situacao == "true"
        @data.push(["Situação: Ativo"])
      else
        @data.push(["Situação: Inativo"])
      end
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

    move_down 20
    table line_table_rows do
      self.width = 523
      row(0).font_style = :bold
      columns(0..5).align = :left
      columns(0).width = 94
      columns(2).width = 90

      # Definindo tamanho dos campos
      if l_profissional.present?
        columns(3).width = 56
      else
        columns(3).width = 67
      end

      unless l_profissional.present?
        columns(5).width = 67
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

    @profissionais.map do |profissional|
      @data_cell_table = [] # apaga array temporaria para a próxima iteração

      unless @p_profissional.present?
        @data_cell_table.push(profissional.cpf)
        @data_cell_table.push(profissional.nome)
      end

      @data_cell_table.push(profissional.rg)
      @data_cell_table.push(profissional.data_nascimento.strftime("%d/%m/%y"))
      @data_cell_table.push(profissional.matricula)
      @data_cell_table.push(profissional.cep)

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
