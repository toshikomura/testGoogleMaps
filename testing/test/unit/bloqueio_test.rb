# encoding: UTF-8
require 'test_helper'

class BloqueioTest < ActiveSupport::TestCase
  setup do
    @bloqueio = bloqueios(:bloqueios_Jose_Artur)
  end

  test "fixture" do
    assert @bloqueio.save, "Fixture inválida"
  end

  test "bloqueio cidadao_id" do
    @bloqueio.cidadao_id = nil
    refute @bloqueio.save, "Bloquio cidadao_id salvo com nil"
    @bloqueio.cidadao_id = ""
    refute @bloqueio.save, "Bloquio cidadao_id salvo vazio"
  end

  test "bloqueio data_entrada" do
    @bloqueio.data_entrada = nil
    refute @bloqueio.save, "Bloquio data_entrada salvo com nil"
    @bloqueio.data_entrada = ""
    refute @bloqueio.save, "Bloquio data_entrada salvo vazio"
    @bloqueio.data_entrada = "13/07/2080"
    assert @bloqueio.save, "Bloquio data_entrada não salvo com formato válido DD/MM/YYYY"
    @bloqueio.data_entrada = "32/07/2080"
    refute @bloqueio.save, "Bloquio data_entrada salvo com formato inválido DD/MM/YYYY"
    @bloqueio.data_entrada = "13/13/2080"
    refute @bloqueio.save, "Bloquio data_entrada salvo com formato inválido DD/MM/YYYY"
    @bloqueio.data_entrada = "13/07/20800"
    refute @bloqueio.save, "Bloquio data_entrada salvo com formato inválido DD/MM/YYYY"
    @bloqueio.data_entrada = "13/070/2080"
    refute @bloqueio.save, "Bloquio data_entrada salvo com formato inválido DD/MM/YYYY"
    @bloqueio.data_entrada = "130/07/2080"
    refute @bloqueio.save, "Bloquio data_entrada salvo com formato inválido DD/MM/YYYY"
    @bloqueio.data_entrada = "AA/AA/AAAA"
    refute @bloqueio.save, "Bloquio data_entrada salvo com formato inválido DD/MM/YYYY"
  end

  test "bloqueio data_expira" do
    @bloqueio.data_expira = nil
    refute @bloqueio.save, "Bloquio data_expira salvo com nil"
    @bloqueio.data_expira  = ""
    refute @bloqueio.save, "Bloquio data_expira salvo vazio"
    @bloqueio.data_expira = "13/07/2080"
    assert @bloqueio.save, "Bloquio data_expira não salvo com formato válido DD/MM/YYYY"
    @bloqueio.data_expira = "32/07/2080"
    refute @bloqueio.save, "Bloquio data_expira salvo com formato inválido DD/MM/YYYY"
    @bloqueio.data_expira = "13/13/2080"
    refute @bloqueio.save, "Bloquio data_expira salvo com formato inválido DD/MM/YYYY"
    @bloqueio.data_expira = "13/070/2080"
    refute @bloqueio.save, "Bloquio data_expira salvo com formato inválido DD/MM/YYYY"
    @bloqueio.data_expira = "130/07/2080"
    refute @bloqueio.save, "Bloquio data_expira salvo com formato inválido DD/MM/YYYY"
    @bloqueio.data_expira = "AA/AA/AAAA"
    refute @bloqueio.save, "Bloquio data_expira salvo com formato inválido DD/MM/YYYY"
  end
end
