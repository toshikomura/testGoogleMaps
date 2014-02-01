# -*- coding: utf-8 -*-

#
# Popula a tabela de Unidades da Federação TUFIBGES
#

require 'rubygems'
require 'csv'

# No arquivo "script/tufibges.csv", os campos estão associados ao
# app/model/tufibge.rb, e são os seguintes:
#
# tufibge[0] = codigo_ibge
# tufibge[1] = nome_uf
# tufibge[2] = sigla_uf

# Uma opção de trabalho seria excluir todos os registros antes
# de começar a carregar estes. Porém, se o script for executado mais
# de uma vez, poderia gerar incosistências de id. Para manter os ids,
# o algoritmo abaixo atualiza as situações já existentes, e cria novas se
# não existir. Porém, não exclui nenhuma.


CSV.foreach("script/csv/tufibges.csv") do |tufibge|

  nova = Tufibge.find_by_nome_uf(tufibge[1])
  if (nova)

    puts "UF #{nova.id} duplicado"

    res = Tufibge.update(nova.id,
                    :codigo_ibge => tufibge[0],
                    :nome_uf => tufibge[1],
                    :sigla_uf => tufibge[2])

    if (res)
      puts "Atualizado registro #{tufibge[1]}"
    else
      puts "Erro ao atualizar registro #{tufibge[1]} #{res.errors.full_messages}"
    end
  else
    nova = Tufibge.new
    nova.codigo_ibge = tufibge[0]
    nova.nome_uf = tufibge[1]
    nova.sigla_uf = tufibge[2]
    res = nova.save()
    if (res)
      puts "Salvo registro #{tufibge[1]}"
    else
      puts "Erro ao salvar registro #{tufibge[1]} #{res.errors.full_messages}"
    end
  end
end
