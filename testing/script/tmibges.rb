# -*- coding: utf-8 -*-

#
# Popula a tabela de Municipios TMIBGES
#

require 'rubygems'
require 'csv'

# No arquivo "script/tmibges.csv", os campos estão associados ao
# app/model/tmibge.rb, e são os seguintes:
#
# tmibge[0] = sigla_uf
# tmibge[1] = codigo_ibge
# tmibge[2] = nome_municipio

# Uma opção de trabalho seria excluir todos os registros antes
# de começar a carregar estes. Porém, se o script for executado mais
# de uma vez, poderia gerar incosistências de id. Para manter os ids,
# o algoritmo abaixo atualiza as situações já existentes, e cria novas se
# não existir. Porém, não exclui nenhuma.


CSV.foreach("script/csv/tmibges.csv") do |tmibge|

  nova = Tmibge.find_by_codigo_ibge(tmibge[1])
  uf = Tufibge.find_by_sigla_uf(tmibge[0])

  if (nova)
    puts "Municipio #{nova.codigo_ibge} duplicado"

    res = Tmibge.update(nova.id,
                    :tufibge_id => uf.id,
                    :codigo_ibge => tmibge[1],
                    :nome_municipio => tmibge[2])
    if (res)
      puts "Atualizado registro #{tmibge[2]}"
    else
      puts "Erro ao atualizar registro #{tmibge[2]}"
    end
  else
    nova = Tmibge.new
    nova.tufibge_id = uf.id
    nova.codigo_ibge = tmibge[1]
    nova.nome_municipio = tmibge[2]
    res = nova.save()
    if (res)
      puts "Salvo registro #{tmibge[2]}"
    else
      puts "Erro ao salvar registro #{tmibge[2]}"
    end
  end
end
