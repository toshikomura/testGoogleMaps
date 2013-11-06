# encoding: UTF-8
require 'test_helper'

class AgendamentoTest < ActiveSupport::TestCase
  setup do
    @agendamento = agendamentos(:agendamentos_Jose_Artur)
  end

  test "fixture" do
    assert @agendamento.save, "Fixture inválida"
  end

  test "agendamento escala_id" do
    @agendamento.escala_id = nil
    refute @agendamento.save, "Agendamento escala_id salvo com nil"
    @agendamento.escala_id = ""
    refute @agendamento.save, "Agendamento escala_id salvo vazio"
  end

  test "agendamento cidadao_id" do
    @agendamento.cidadao_id = nil
    refute @agendamento.save, "Agendamento cidadao_id salvo com nil"
    @agendamento.cidadao_id = ""
    refute @agendamento.save, "Agendamento cidadao_id salvo vazio"
  end

  test "agendamento orgao_id" do
    @agendamento.orgao_id = nil
    refute @agendamento.save, "Agendamento orgao_id salvo com nil"
    @agendamento.orgao_id = ""
    refute @agendamento.save, "Agendamento orgao_id salvo vazio"
  end

  test "agendamento tipo_situacao_id" do
    @agendamento.tipo_situacao_id = nil
    refute @agendamento.save, "Agendamento tipo_situacao_id salvo com nil"
    @agendamento.tipo_situacao_id = ""
    refute @agendamento.save, "Agendamento tipo_situacao_id salvo vazio"
  end

  test "agendamento horario_inicio_consulta" do
    @agendamento.horario_inicio_consulta = nil
    refute @agendamento.save, "Agendamento horario_inicio_consulta salvo com nil"
    @agendamento.horario_inicio_consulta = ""
    refute @agendamento.save, "Agendamento horario_inicio_consulta salvo vazio"

    @agendamento.horario_inicio_consulta = "13/07/2080 07:07:07"
    @agendamento.horario_fim_consulta = "13/07/2080 07:10:00"
    assert @agendamento.save, "Agendamento horario_inicio_consulta não salvo com formato válido DD/MM/YYYY HH:MM:SS."

    @agendamento.horario_inicio_consulta = "32/07/2080 07:07:07"
    refute @agendamento.save, "Agendamento horario_inicio_consulta salvo com formato inválido DD/MM/YYYY HH:MM:SS"
    @agendamento.horario_inicio_consulta = "13/13/2080 07:07:07"
    refute @agendamento.save, "Agendamento horario_inicio_consulta salvo com formato inválido DD/MM/YYYY HH:MM:SS"
    @agendamento.horario_inicio_consulta = "13/07/20800 07:07:07"
    refute @agendamento.save, "Agendamento horario_inicio_consulta salvo com formato inválido DD/MM/YYYY HH:MM:SS"
    @agendamento.horario_inicio_consulta = "13/070/2080 07:07:07"
    refute @agendamento.save, "Agendamento horario_inicio_consulta salvo com formato inválido DD/MM/YYYY HH:MM:SS"
    @agendamento.horario_inicio_consulta = "130/07/2080 07:07:07"
    refute @agendamento.save, "Agendamento horario_inicio_consulta salvo com formato inválido DD/MM/YYYY HH:MM:SS"
    @agendamento.horario_inicio_consulta = "13/07/2080 25:07:07"
    refute @agendamento.save, "Agendamento horario_inicio_consulta salvo com formato inválido DD/MM/YYYY HH:MM:SS"
    @agendamento.horario_inicio_consulta = "13/07/2080 07:61:07"
    refute @agendamento.save, "Agendamento horario_inicio_consulta salvo com formato inválido DD/MM/YYYY HH:MM:SS"
  end

  test "agendamento horario_fim_consulta" do
    @agendamento.horario_fim_consulta = nil
    refute @agendamento.save, "Agendamento horario_fim_consulta salvo com nil"
    @agendamento.horario_fim_consulta = ""
    refute @agendamento.save, "Agendamento horario_fim_consulta salvo vazio"
    @agendamento.horario_fim_consulta = "13/07/2080 07:07:07"
    assert @agendamento.save, "Agendamento horario_fim_consulta não salvo com formato válido DD/MM/YYYY HH:MM:SS"
    @agendamento.horario_fim_consulta = "32/07/2080 07:07:07"
    refute @agendamento.save, "Agendamento horario_fim_consulta salvo com formato inválido DD/MM/YYYY HH:MM:SS"
    @agendamento.horario_fim_consulta = "13/13/2080 07:07:07"
    refute @agendamento.save, "Agendamento horario_fim_consulta salvo com formato inválido DD/MM/YYYY HH:MM:SS"
    @agendamento.horario_fim_consulta = "13/070/2080 07:07:07"
    refute @agendamento.save, "Agendamento horario_fim_consulta salvo com formato inválido DD/MM/YYYY HH:MM:SS"
    @agendamento.horario_fim_consulta = "130/07/2080 07:07:07"
    refute @agendamento.save, "Agendamento horario_fim_consulta salvo com formato inválido DD/MM/YYYY HH:MM:SS"
    @agendamento.horario_fim_consulta = "13/07/2080 25:07:07"
    refute @agendamento.save, "Agendamento horario_fim_consulta salvo com formato inválido DD/MM/YYYY HH:MM:SS"
    @agendamento.horario_fim_consulta = "13/07/2080 07:61:07"
    refute @agendamento.save, "Agendamento horario_fim_consulta salvo com formato inválido DD/MM/YYYY HH:MM:SS"
  end

  test "agendamento observacao" do
    @agendamento.observacao = nil
    assert @agendamento.save, "Agendamento observacao não salvo com nil"
    @agendamento.observacao = ""
    assert @agendamento.save, "Agendamento observacao não salvo vazio"
  end
end
