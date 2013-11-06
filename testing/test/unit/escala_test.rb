# encoding: UTF-8
require 'test_helper'

class EscalaTest < ActiveSupport::TestCase
  setup do
    @escala = escalas(:escalas_Oswaldo_Cruz)
  end

  test "escalas fixture" do
    assert @escala.save, "Escalas fixture inválida"
  end

  test "escalas profissional_executor_id" do
    @escala.profissional_executor_id = nil 
    assert @escala.save, "Escalas profissional_executor_id não salvo como nil"  

    @escala.profissional_executor_id = "" 
    assert @escala.save, "Escalas profissional_executor_id não salvo como vazio"  
  end

  test "escalas profissional_responsavel_id" do
    @escala.profissional_responsavel_id = nil 
    refute @escala.save, "Escalas profissional_responsavel_id salvo como nil"  

    @escala.profissional_responsavel_id = ""
    refute @escala.save, "Escalas profissional_responsavel_id salvo como vazio"  
  end

  test "escalas tipo_atendimento_id" do
    @escala.tipo_atendimento_id = nil 
    refute @escala.save, "Escalas tipo_atendimento_id salvo como nil"

    @escala.tipo_atendimento_id = ""
    refute @escala.save, "Escalas tipo_atendimento_id salvo como vazio"
  end

  test "escalas orgao_id" do
    @escala.orgao_id = nil 
    refute @escala.save, "Escalas orgao_id salvo como nil"

    @escala.orgao_id = ""
    refute @escala.save, "Escalas orgao_id salvo como vazio"
  end

  test "escalas tipo_acao_id" do
    @escala.tipo_acao_id = nil 
    refute @escala.save, "Escalas tipo_acao_id salvo como nil"

    @escala.tipo_acao_id = ""
    refute @escala.save, "Escalas tipo_acao_id salvo como vazio"  
  end

  test "escalas numero_sequencia" do
    @escala.numero_sequencia = nil 
    refute @escala.save, "Escalas numero_sequencia salvo como nil"

    @escala.numero_sequencia = nil 
    refute @escala.save, "Escalas numero_sequencia salvo como vazio"

    @escala.numero_sequencia = 0
    refute @escala.save, "Escalas numero_sequencia salvo como 0"

    @escala.numero_sequencia = -1
    refute @escala.save, "Escalas numero_sequencia salvo como -1"

    @escala.numero_sequencia = generate_string(4) 
    refute @escala.save, "Escalas numero_sequencia salvo como string"

    @escala.numero_sequencia = 3.14356
    refute @escala.save, "Escalas numero_sequencia salvo como float"

    @escala.numero_sequencia = 2147483648 # Ver postgresql.org/docs/9.1/static/datatype-numeric.html
    refute @escala.save, "Escalas numero_sequencia salvo como maior que 2^16"
  end

  test "escalas data_execucao" do
    @escala.data_execucao = "2013-12-31"
    assert @escala.save, "Escalas data_execucao não salvo com formato válido 2013-12-31"

    @escala.data_execucao = nil 
    refute @escala.save, "Escalas data_execucao salvo como nil"
 
    @escala.data_execucao = ""
    refute @escala.save, "Escalas data_execucao salvo como vazio"

    @escala.data_execucao = generate_string(10)
    refute @escala.save, "Escalas data_execucao salvo como string"

    @escala.data_execucao = 3.14356
    refute @escala.save, "Escalas data_execucao salvo como float"

    @escala.data_execucao = 23
    refute @escala.save, "Escalas data_execucao salvo como integer"
  end

  test "escalas horario_inicio_execucao" do
    @escala.horario_inicio_execucao = "2013-12-31 12:00:00"
    assert @escala.save, "Escalas horario_inicio_execucao não salvo com formato válido 2013-12-31 12:00:00"

    @escala.horario_inicio_execucao = nil 
    refute @escala.save, "Escalas horario_inicio_execucao salvo como nil"
 
    @escala.horario_inicio_execucao = ""
    refute @escala.save, "Escalas horario_inicio_execucao salvo como vazio"

    @escala.horario_inicio_execucao = generate_string(10)
    refute @escala.save, "Escalas horario_inicio_execucao salvo como string"

    @escala.horario_inicio_execucao = 3.14356
    refute @escala.save, "Escalas horario_inicio_execucao salvo como float"

    @escala.horario_inicio_execucao = 23
    refute @escala.save, "Escalas horario_inicio_execucao salvo como integer"

    @escala.horario_inicio_execucao = "2013-12-31 15/00"
    refute @escala.save, "Escalas horario_inicio_execucao salvo com formato inválido 2013-12-31 15/00"
  end

  test "escalas horario_fim_execucao" do
    @escala.horario_fim_execucao = "2013-12-31 12:00:00"
    assert @escala.save, "Escalas horario_fim_execucao não salvo com formato válido 2013-12-31 12:00:00"

    @escala.horario_fim_execucao = nil
    refute @escala.save, "Escalas horario_fim_execucao salvo como nil"

    @escala.horario_fim_execucao = ""
    refute @escala.save, "Escalas horario_fim_execucao salvo como vazio"
 
    @escala.horario_fim_execucao = generate_string(10)
    refute @escala.save, "Escalas horario_fim_execucao salvo como string"

    @escala.horario_fim_execucao = 3.14356
    refute @escala.save, "Escalas horario_fim_execucao salvo como float"

    @escala.horario_fim_execucao = 23
    refute @escala.save, "Escalas horario_fim_execucao salvo como integer"

    @escala.horario_fim_execucao = "2013-12-31 15/00"
    refute @escala.save, "Escalas horario_fim_execucao salvo com formato inválido 2013-12-31 15/00"
  end

  test "escalas observacoes" do
    @escala.observacoes = nil 
    assert @escala.save, "Escalas observacoes não salvo como nil"  

    @escala.observacoes = ""
    assert @escala.save, "Escalas observacoes não salvo como vazio"

    @escala.observacoes = generate_string(501)
    refute @escala.save, "Escalas observacoes salvo como maior que 500"  
  end

  test "escalas numero_atendimentos" do
    @escala.numero_atendimentos = nil 
    refute @escala.save, "Escalas numero_atendimentos salvo como nil"  

    @escala.numero_atendimentos = ""
    refute @escala.save, "Escalas numero_atendimentos salvo como vazio"

    @escala.numero_atendimentos = 0
    assert @escala.save, "Escalas numero_atendimentos não salvo como 0"

    @escala.numero_atendimentos = -1
    refute @escala.save, "Escalas numero_atendimentos salvo como -1"  
 
    @escala.numero_atendimentos = generate_string(4)
    refute @escala.save, "Escalas numero_atendimentos salvo como string"  

    @escala.numero_atendimentos = 3.1456
    refute @escala.save, "Escalas numero_atendimentos salvo como float"  

    @escala.numero_atendimentos = 2147483648 # Ver postgresql.org/docs/9.1/static/datatype-numeric.html
    refute @escala.save, "Escalas numero_atendimentos salvo como 2^16"  
  end
end
