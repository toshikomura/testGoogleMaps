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
                            :nome => "Prefeitura Municipal de Newcastle",
                            :cep => "80530-908",
                            :bairro => "Centro Cívico",
                            :endereco => "Av. Cândido de Abreu",
                            :numero_endereco => 23,
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
      puts "Erro ao atualizar registro #{prefeitura.nome}"
    end
  else
    prefeitura = Prefeitura.new(:nome => "Prefeitura Municipal de Newcastle",
                            :cep => "80530-908",
                            :bairro => "Centro Cívico",
                            :endereco => "Av. Cândido de Abreu",
                            :numero_endereco => 23,
                            :telefone1 => "(41)3350-8080",
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
      puts "Erro ao salvar registro #{prefeitura.nome}"
    end
  end

  # Registro de um órgão da prefeitura
  orgao = Orgao.find_by_nome("Administração geral da prefeitura de Newcastle")
  if (orgao)
    puts "Órgão #{orgao.nome} duplicado"
    res = Orgao.update(orgao.id,
                      :nome => "Administração geral da prefeitura de Newcastle",
                      :cep => "80035-010",
                      :bairro => "Cabral",
                      :endereco => "R. Bom Jesus",
                      :numero_endereco => 23,
                      :ativo => true,
                      :tufibge_id => 1,
                      :tmibge_id => 1,
                      :prefeitura_id => prefeitura.id)
    if (res)
      puts "Atualizado registro #{orgao.nome}"
    else
      puts "Erro ao atualizar registro #{orgao.nome}"
    end
  else
    orgao = Orgao.new(:nome => "Administração geral da prefeitura de Newcastle",
                      :cep => "80035-010",
                      :bairro => "Cabral",
                      :endereco => "R. Bom Jesus",
                      :numero_endereco => 23,
                      :ativo => true,
                      :tufibge_id => 1,
                      :tmibge_id => 1,
                      :prefeitura_id => prefeitura.id)
    if orgao.save
      puts "Salvo registro #{orgao.nome}"
    else
      puts "Erro ao salvar registro #{orgao.nome}"
    end
  end

  # Registro de um órgão da prefeitura
  sms = Orgao.find_by_nome("SMS - Secretaria Municipal da Saúde")
  if (sms)
    puts "Órgão #{sms.nome} duplicado"
    res = Orgao.update(sms.id,
                    :nome => "SMS - Secretaria Municipal da Saúde",
                    :cep => "80035-010",
                    :bairro => "Cabral",
                    :endereco => "R. Bom Jesus",
                    :numero_endereco => 23,
                    :ativo => true,
                    :tufibge_id => 1,
                    :tmibge_id => 1,
                    :prefeitura_id => prefeitura.id)
    if (res)
      puts "Atualizado registro #{sms.nome}"
    else
      puts "Erro ao atualizar registro #{sms.nome}"
    end
  else
    sms = Orgao.new(:nome => "SMS - Secretaria Municipal da Saúde",
                    :cep => "80035-010",
                    :bairro => "Cabral",
                    :endereco => "R. Bom Jesus",
                    :numero_endereco => 23,
                    :ativo => true,
                    :tufibge_id => 1,
                    :tmibge_id => 1,
                    :prefeitura_id => prefeitura.id)
    if sms.save
      puts "Salvo registro #{sms.nome}"
    else
      puts "Erro ao salvar registro #{sms.nome}"
    end
  end

  # Registro do root
  root = Profissional.find_by_cpf("306.889.437-99")
  if (root)
    puts "Profissional #{root.nome} #{root.role} #{root.cpf} duplicado"
    res = Profissional.update(root.id,
                            :nome => "Osvaldo Cruz",
                            :cpf => "306.889.437-99",
                            :rg => "22.222.222-22",
                            :emissao_rg => "IIPR",
                            :data_nascimento => "2013-01-01",
                            :orgao_id => orgao.id,
                            :role => "administradorsistema",
                            :ativo => true,
                            :tcbo_id => 1,
                            :password => "123456",
                            :password_confirmation => "123456")
    if (res)
      puts "Atualizado registro #{root.nome} #{root.role} #{root.cpf}"
    else
      puts "Erro ao atualizar registro #{root.nome} #{root.role} #{root.cpf}"
    end
  else
    root = Profissional.new(:nome => "Osvaldo Cruz",
                            :cpf => "306.889.437-99",
                            :rg => "22.222.222-22",
                            :emissao_rg => "IIPR",
                            :data_nascimento => "2013-01-01",
                            :orgao_id => orgao.id,
                            :role => "administradorsistema",
                            :ativo => true,
                            :tcbo_id => 1,
                            :password => "123456",
                            :password_confirmation => "123456")
    if root.save
      puts "Salvo registro #{root.nome} #{root.role} #{root.cpf}"
    else
      puts "Erro ao salvar registro #{root.nome} #{root.role} #{root.cpf}"
    end
  end

  # Registro de um profissional do órgão sms
  profissional = Profissional.find_by_cpf("053.061.070-10")
  if (profissional)
    puts "Profissional #{profissional.nome} #{profissional.role} #{profissional.cpf} duplicado"
    res = Profissional.update(profissional.id,
                             :nome => "Zilda Arns",
                             :cpf => "053.061.070-10",
                             :rg => "22.222.222-22",
                             :emissao_rg => "IIPR",
                             :data_nascimento => "2013-01-01",
                             :orgao_id => sms.id,
                             :role => "administrador",
                             :ativo => true,
                             :tcbo_id => 12,
                             :password => "123456",
                             :password_confirmation => "123456")
    if (res)
      puts "Atualizado registro #{profissional.nome} #{profissional.role} #{profissional.cpf}"
    else
      puts "Erro ao atualizar registro #{profissional.nome} #{profissional.role} #{profissional.cpf}"
    end
  else
    profissional = Profissional.new(:nome => "Zilda Arns",
                                    :cpf => "053.061.070-10",
                                    :rg => "22.222.222-22",
                                    :emissao_rg => "IIPR",
                                    :data_nascimento => "2013-01-01",
                                    :orgao_id => sms.id,
                                    :role => "administrador",
                                    :ativo => true,
                                    :tcbo_id => 12,
                                    :password => "123456",
                                    :password_confirmation => "123456")
    if profissional.save
      puts "Salvo registro #{profissional.nome} #{profissional.role} #{profissional.cpf}"
    else
      puts "Erro ao salvar registro #{profissional.nome} #{profissional.role} #{profissional.cpf}"
    end
  end

  # Registro de um profissional do órgão sms
  profissional = Profissional.find_by_cpf("759.246.769-00")
  if (profissional)
    puts "Profissional #{profissional.nome} #{profissional.role} #{profissional.cpf} duplicado"
    res = Profissional.update(profissional.id,
                                    :nome => "João Curvo",
                                    :cpf => "759.246.769-00 ",
                                    :matricula => "2013-02",
                                    :rg => "11.111.111-11",
                                    :emissao_rg => "IIPR",
                                    :data_nascimento => "2013-02-01",
                                    :orgao_id => sms.id,
                                    :role => "atendente",
                                    :ativo => true,
                                    :tcbo_id => 12,
                                    :password => "123456",
                                    :password_confirmation => "123456")

    if (res)
      puts "Atualizado registro #{profissional.nome} #{profissional.role} #{profissional.cpf}"
    else
      puts "Erro ao atualizar registro #{profissional.nome} #{profissional.role} #{profissional.cpf}"
    end
  else
    profissional = Profissional.new(:nome => "João Curvo",
                                    :cpf => "759.246.769-00 ",
                                    :matricula => "2013-02",
                                    :rg => "11.111.111-11",
                                    :emissao_rg => "IIPR",
                                    :data_nascimento => "2013-02-01",
                                    :orgao_id => sms.id,
                                    :role => "tecnico",
                                    :ativo => true,
                                    :tcbo_id => 12,
                                    :password => "123456",
                                    :password_confirmation => "123456")

    if profissional.save
      puts "Salvo registro #{profissional.nome} #{profissional.role} #{profissional.cpf}"
    else
      puts "Erro ao salvar registro #{profissional.nome} #{profissional.role} #{profissional.cpf}"
    end
  end

  # Registro de um profissional do órgão sms
  profissional = Profissional.find_by_cpf("990.034.887-70")
  if (profissional)
    puts "Profissional #{profissional.nome} #{profissional.role} #{profissional.cpf} duplicado"
    res = Profissional.update(profissional.id,
                                    :nome => "Rinaldo Victor De Lamare",
                                    :cpf => "990.034.887-70",
                                    :matricula => "2013-03",
                                    :rg => "22.222.222-22",
                                    :emissao_rg => "IIPR",
                                    :data_nascimento => "2013-01-01",
                                    :orgao_id => sms.id,
                                    :role => "atendente",
                                    :ativo => true,
                                    :tcbo_id => 12,
                                    :password => "123456",
                                    :password_confirmation => "123456")

    if (res)
      puts "Atualizado registro #{profissional.nome} #{profissional.role} #{profissional.cpf}"
    else
      puts "Erro ao atualizar registro #{profissional.nome} #{profissional.role} #{profissional.cpf}"
    end
  else
    profissional = Profissional.new(:nome => "Rinaldo Victor De Lamare",
                                    :cpf => "990.034.887-70",
                                    :matricula => "2013-03",
                                    :rg => "22.222.222-22",
                                    :emissao_rg => "IIPR",
                                    :data_nascimento => "2013-01-01",
                                    :orgao_id => sms.id,
                                    :role => "atendente",
                                    :ativo => true,
                                    :tcbo_id => 12,
                                    :password => "123456",
                                    :password_confirmation => "123456")

    if profissional.save
      puts "Salvo registro #{profissional.nome} #{profissional.role} #{profissional.cpf}"
    else
      puts "Erro ao salvar registro #{profissional.nome} #{profissional.role} #{profissional.cpf}"
    end
  end

  # Registro de um tipo de atendimento do órgão sms
  tipo_atendimento = TipoAtendimento.find_by_descricao("Consulta ambulatorial")
  if (tipo_atendimento)
    puts "Tipo de atendimento #{tipo_atendimento.descricao} duplicado"
    res = TipoAtendimento.update(tipo_atendimento.id,
                                :descricao => "Consulta ambulatorial",
                                :ativo => true)
    if (res)
      puts "Atualizado registro #{tipo_atendimento.descricao}"
    else
      puts "Erro ao atualizar registro #{tipo_atendimento.descricao}"
    end
  else
    tipo_atendimento = TipoAtendimento.new(:descricao => "Consulta ambulatorial",
                                           :ativo => true)
    if tipo_atendimento.save
      sms.tipo_atendimentos << tipo_atendimento
      puts "Salvo registro #{tipo_atendimento.descricao}"
    else
      puts "Erro ao salvar registro #{tipo_atendimento.descricao}"
    end
  end

  # Registro de um tipo de atendimento do órgão sms
  tipo_atendimento = TipoAtendimento.find_by_descricao("Consulta pediátrica")
  if (tipo_atendimento)
    puts "Tipo de atendimento #{tipo_atendimento.descricao} duplicado"
    res = TipoAtendimento.update(tipo_atendimento.id,
                                :descricao => "Consulta pediátrica",
                                :ativo => true)
    if (res)
      puts "Atualizado registro #{tipo_atendimento.descricao}"
    else
      puts "Erro ao atualizar registro #{tipo_atendimento.descricao}"
    end
  else
    tipo_atendimento = TipoAtendimento.new(:descricao => "Consulta pediátrica",
                                           :ativo => true)
    if tipo_atendimento.save
      sms.tipo_atendimentos << tipo_atendimento
      puts "Salvo registro #{tipo_atendimento.descricao}"
    else
      puts "Erro ao salvar registro #{tipo_atendimento.descricao}"
    end
  end

  # Registro de um cidadão
  cidadao = Cidadao.find_by_cpf("838.534.168-45")
  if (cidadao)
    puts "Cidadão #{cidadao.nome} #{cidadao.cpf} duplicado"
    res = Cidadao.update(cidadao.id,
                          :nome => "João da Silva",
                          :rg => "123.456.78",
                          :cpf => "838.534.168-45",
                          :password => "123456",
                          :password_confirmation => "123456")
    if (res)
      puts "Atualizado registro #{cidadao.nome} #{cidadao.cpf}"
    else
      puts "Erro ao atualizar registro #{cidadao.nome} #{cidadao.cpf}"
    end
  else
    cidadao = Cidadao.new(:nome => "João da Silva",
                          :rg => "123.456.78",
                          :cpf => "838.534.168-45",
                          :password => "123456",
                          :password_confirmation => "123456")
    if cidadao.save
      puts "Salvo registro #{cidadao.nome} #{cidadao.cpf}"
    else
      puts "Erro ao salvar registro #{cidadao.nome} #{cidadao.cpf}"
    end
  end

  # Registro de um cidadão
  cidadao = Cidadao.find_by_cpf("603.331.780-76")
  if (cidadao)
    puts "Cidadão #{cidadao.nome} #{cidadao.cpf} duplicado"
    res = Cidadao.update(cidadao.id,
                        :nome => "Maria da Silva",
                        :rg => "123.456.78",
                        :cpf => "603.331.780-76",
                        :password => "123456",
                        :password_confirmation => "123456")
    if (res)
      puts "Atualizado registro #{cidadao.nome} #{cidadao.cpf}"
    else
      puts "Erro ao atualizar registro #{cidadao.nome} #{cidadao.cpf}"
    end
  else
    cidadao = Cidadao.new(:nome => "Maria da Silva",
                          :rg => "123.456.78",
                          :cpf => "603.331.780-76",
                          :password => "123456",
                          :password_confirmation => "123456")
    if cidadao.save
      puts "Salvo registro #{cidadao.nome} #{cidadao.cpf}"
    else
      puts "Erro ao salvar registro #{cidadao.nome} #{cidadao.cpf}"
    end
  end
