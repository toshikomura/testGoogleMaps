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


CSV.foreach("script/csv/tipo_acoes.csv") do |acao|

  nova = TipoAcao.find_by_descricao(acao[0])
  if (nova)

    puts "Tipo de Ação #{nova.id} duplicado"

    res = TipoAcao.update(nova.id,
                    :descricao => acao[0])
    if (res)
      puts "Atualizado registro #{acao[0]}"
    else
      puts "Erro ao atualizar registro #{acao[0]} #{res.errors.full_messages}"
    end
  else
    nova = TipoAcao.new
    nova.descricao = acao[0]
    res = nova.save()
    if (res)
      puts "Salvo registro #{acao[0]}"
    else
      puts "Erro ao salvar registro #{acao[0]} #{res.errors.full_messages}"
    end
  end
end
