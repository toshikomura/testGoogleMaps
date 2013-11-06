# encoding: UTF-8
require 'test_helper'

class TmibgeTest < ActiveSupport::TestCase
  setup do
    @tmibge = tmibges(:tmibge_alta_floresta_doeste)
  end

  test "fixture" do
    assert @tmibge.save, "Fixture inválida"
  end

  test "tmibge tufibge_id" do
    @tmibge.tufibge_id = nil
    refute @tmibge.save, "Tmibge tufibge_id salvo com nil"
    @tmibge.tufibge_id = ""
    refute @tmibge.save, "Tmibge tufibge_id salvo vazio"
  end

  test "tmibge nome_municipio" do
    @tmibge.nome_municipio = nil
    refute @tmibge.save, "Tmibge nome_municipio salvo com nil"
    @tmibge.nome_municipio = ""
    refute @tmibge.save, "Tmibge nome_municipio salvo vazio"
    @tmibge.nome_municipio = "Ac"
    assert @tmibge.save, "Tmibge nome_municipio não salvo no formato"
    @tmibge.nome_municipio = generate_string(256)
    refute @tmibge.save, "Tmibge nome_municipio salvo como maior que 2"
    @tmibge.nome_municipio = generate_string(1)
    refute @tmibge.save, "Tmibge nome_municipio salvo como menor que 2"
  end

  test "tmibge codigo_ibge" do
    @tmibge.codigo_ibge = nil
    refute @tmibge.save, "Tmibge codigo_ibge salvo com nil"
    @tmibge.codigo_ibge = ""
    refute @tmibge.save, "Tmibge codigo_ibge salvo vazio"
    @tmibge.codigo_ibge = "2222"
    assert @tmibge.save, "Tmibge codigo_ibge não salvo no formato"
    @tmibge.codigo_ibge = generate_string(256)
    refute @tmibge.save, "Tmibge codigo_ibge salvo como maior que 255"
    @tmibge.codigo_ibge = generate_string(1)
    refute @tmibge.save, "Tmibge codigo_ibge salvo como menor que 2"
  end
end
