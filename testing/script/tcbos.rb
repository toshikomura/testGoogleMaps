# -*- coding: utf-8 -*-

#
# Popula a tabela Classificação Brasileira de Ocupações(TCBOS)
#

require 'rubygems'
require 'csv'

# No arquivo "script/tcbos.csv", os campos estão associados ao
# app/model/tcbo.rb, e são os seguintes:
#
# tcbo[0] = codigo_cbo
# tcbo[1] = descricao

# Uma opção de trabalho seria excluir todos os registros antes
# de começar a carregar estes. Porém, se o script for executado mais
# de uma vez, poderia gerar incosistências de id. Para manter os ids,
# o algoritmo abaixo atualiza as situações já existentes, e cria novas se
# não existir. Porém, não exclui nenhuma.


CSV.foreach("script/csv/tcbos.csv") do |tcbo|

  nova = Tcbo.find_by_descricao(tcbo[1])
  if (nova)

    puts "TCBO #{nova.descricao} duplicado"

    res = Tcbo.update(nova.id,
                    :codigo_cbo => tcbo[0],
                    :descricao => tcbo[1])
    if (res)
      puts "Atualizado registro #{tcbo[1]}"
    else
      puts "Erro ao atualizar registro #{tcbo[1]} #{res.errors.full_messages}"
    end
  else
    nova = Tcbo.new
    nova.codigo_cbo = tcbo[0]
    nova.descricao = tcbo[1]
    res = nova.save()
    if (res)
      puts "Salvo registro #{tcbo[1]}"
    else
      puts "Erro ao salvar registro #{tcbo[1]} #{res.errors.full_messages}"
    end
  end
end
