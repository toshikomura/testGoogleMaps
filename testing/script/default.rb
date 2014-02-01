# -*- coding: utf-8 -*-

#
# Popula exemplos de Prefeitura, Órgãos e Tipo de Atendimentos
#

require 'rubygems'
require 'csv'

# Uma opção de trabalho seria excluir todos os registros antes
# de começar a carregar estes. Porém, se o script for executado mais
# de uma vez, poderia gerar incosistências de id. Para manter os ids,
# o algoritmo abaixo atualiza as situações já existentes, e cria novas se
# não existir. Porém, não exclui nenhuma.

  # Registro da Prefeitura
  prefeitura = Prefeitura.first
  if (prefeitura)
    puts "Prefeitura #{prefeitura.nome} existente"
    res = Prefeitura.update(prefeitura.id,
                            :nome => "Nome da prefeitura",
                            :cep => "00.000-000",
                            :bairro => "Bairro",
                            :endereco => "Endereço",
                            :numero_endereco => 00,
                            :telefone1 => "(41)0000-0000",
                            :tufibge_id => 1,
                            :tmibge_id => 1,
                            :limite_cancelamento => 48,
                            :max_agendamentos => 3,
                            :dias_bloqueio => 30,
                            :max_faltas => 1,
                            :periodo_agendamentos => 90,
                            :antecedencia_avisos => 48)
    if (res)
      puts "Atualizado registro #{prefeitura.nome}"
    else
      puts "Erro ao atualizar registro #{prefeitura.nome} #{res.errors.full_messages}"
    end
  else
    prefeitura = Prefeitura.new(:nome => "Nome da prefeitura",
                            :cep => "00.000-000",
                            :bairro => "Bairro",
                            :endereco => "Endereço",
                            :numero_endereco => 00,
                            :telefone1 => "(41)0000-0000",
                            :tufibge_id => 1,
                            :tmibge_id => 1,
                            :limite_cancelamento => 48,
                            :max_agendamentos => 3,
                            :dias_bloqueio => 30,
                            :max_faltas => 1,
                            :periodo_agendamentos => 90,
                            :antecedencia_avisos => 48)
    if prefeitura.save
      puts "Salvo registro #{prefeitura.nome}"
    else
      puts "Erro ao salvar registro #{prefeitura.nome} #{prefeitura.errors.full_messages}"
    end
  end

  # Registro do root
  root = Profissional.find_by_cpf("306.889.437-99")
  if (root)
    puts "Profissional #{root.nome} #{root.role} #{root.cpf} duplicado"
    res = Profissional.update(root.id,
                            :nome => "Administrador",
                            :cpf => "306.889.437-99",
                            :rg => "22.222.222-22",
                            :emissao_rg => "IIPR",
                            :data_nascimento => "2013-01-01",
                            :orgao_id => orgao.id,
                            :role => "administradorsistema",
                            :ativo => true,
                            :tcbo_id => 1,
                            :password => "123456",
                            :password_confirmation => "123456",
                            :email => "admagendador@newcastle.c3sl.ufpr.br")
    if (res)
      puts "Atualizado registro #{root.nome} #{root.role} #{root.cpf}"
    else
      puts "Erro ao atualizar registro #{root.nome} #{root.role} #{root.cpf} #{res.errors.full_messages}"
    end
  else
    root = Profissional.new(:nome => "Administrador",
                            :cpf => "306.889.437-99",
                            :rg => "22.222.222-22",
                            :emissao_rg => "IIPR",
                            :data_nascimento => "2013-01-01",
                            :orgao_id => orgao.id,
                            :role => "administradorsistema",
                            :ativo => true,
                            :tcbo_id => 1,
                            :password => "123456",
                            :password_confirmation => "123456",
                            :email => "admagendador@newcastle.c3sl.ufpr.br")
    if root.save
      puts "Salvo registro #{root.nome} #{root.role} #{root.cpf}"
    else
      puts "Erro ao salvar registro #{root.nome} #{root.role} #{root.cpf} #{root.errors.full_messages}"
    end
  end
