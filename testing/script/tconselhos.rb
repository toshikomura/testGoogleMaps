# -*- coding: utf-8 -*-

#
# Popula a tabela Conselhos(TCONSELHOS)
#

require 'rubygems'
require 'csv'

# No arquivo "script/tconselhos.csv", os campos estão associados ao
# app/model/tconselho.rb, e são os seguintes:
#
# tconselho[0] = sigla_conselho
# tconselho[1] = descricao

# Uma opção de trabalho seria excluir todos os registros antes
# de começar a carregar estes. Porém, se o script for executado mais
# de uma vez, poderia gerar incosistências de id. Para manter os ids,
# o algoritmo abaixo atualiza as situações já existentes, e cria novas se
# não existir. Porém, não exclui nenhuma.


CSV.foreach("script/csv/tconselhos.csv") do |tconselho|

  nova = Tconselho.find_by_descricao(tconselho[1])
  if (nova)

    puts "TCONSELHO #{nova.descricao} duplicado"

    res = Tconselho.update(nova.id,
                    :sigla_conselho => tconselho[0],
                    :descricao => tconselho[1])
    if (res)
      puts "Atualizado registro #{tconselho[1]}"
    else
      puts "Erro ao atualizar registro #{tconselho[1]}"
    end
  else
    nova = Tconselho.new
    nova.sigla_conselho = tconselho[0]
    nova.descricao = tconselho[1]
    res = nova.save()
    if (res)
      puts "Salvo registro #{tconselho[1]}"
    else
      puts "Erro ao salvar registro #{tconselho[1]}"
    end
  end
end
