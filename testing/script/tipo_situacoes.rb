# -*- coding: utf-8 -*-

#
# Popula a tabela de Tipos de Situações
#

require 'rubygems'
require 'csv'

# No arquivo "script/tipo_situacoes.csv", os campos estão associados ao
# app/model/tipo_situacao.rb, e são os seguintes:
#
# situacao[0] = descricao
#

# Uma opção de trabalho seria excluir todos os registros antes
# de começar a carregar estes. Porém, se o script for executado mais
# de uma vez, poderia gerar incosistências de id. Para manter os ids,
# o algoritmo abaixo atualiza as situações já existentes, e cria novas se
# não existir. Porém, não exclui nenhuma.


CSV.foreach("script/csv/tipo_situacoes.csv") do |situacao|

  nova = TipoSituacao.find_by_descricao(situacao[0])
  if (nova)

    puts "Tipo de Situação #{nova.id} duplicado"

    res = TipoSituacao.update(nova.id,
                    :descricao => situacao[0])
    if (res)
      puts "Atualizado registro #{situacao[0]}"
    else
      puts "Erro ao atualizar registro #{situacao[0]}"
    end
  else
    nova = TipoSituacao.new
    nova.descricao = situacao[0]
    res = nova.save()
    if (res)
      puts "Salvo registro #{situacao[0]}"
    else
      puts "Erro ao salvar registro #{situacao[0]}"
    end
  end
end
