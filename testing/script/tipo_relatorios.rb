# -*- coding: utf-8 -*-

#
# Popula a tabela de Tipos de Ações
#

require 'rubygems'
require 'csv'

# No arquivo "script/tipo_acoes.csv", os campos estão associados ao
# app/model/tipo_acao.rb, e são os seguintes:
#
# acao[0] = descricao
#

# Uma opção de trabalho seria excluir todos os registros antes
# de começar a carregar estes. Porém, se o script for executado mais
# de uma vez, poderia gerar incosistências de id. Para manter os ids,
# o algoritmo abaixo atualiza as situações já existentes, e cria novas se
# não existir. Porém, não exclui nenhuma.


CSV.foreach("script/csv/tipo_relatorios.csv") do |relatorio|

  nova = Report.find_by_description(relatorio[0])
  if (nova)

    puts "Tipo de Relatório #{nova.id} duplicado"

    res = Report.update(nova.id,
                    :description => relatorio[0])
    if (res)
      puts "Atualizado registro #{relatorio[0]}"
    else
      puts "Erro ao atualizar registro #{relatorio[0]} #{res.errors.full_messages}"
    end
  else
    nova = Report.new
    nova.description = relatorio[0]
    res = nova.save()
    if (res)
      puts "Salvo registro #{relatorio[0]}"
    else
      puts "Erro ao salvar registro #{relatorio[0]} #{res.errors.full_messages}"
    end
  end
end
