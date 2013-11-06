# encoding: UTF-8
require 'test_helper'

class TufibgeTest < ActiveSupport::TestCase
  setup do
    @tufibge = tufibges(:tufibge_AC)
  end

  test "fixture" do
    assert @tufibge.save, "Fixture inválida. #{@tufibge.errors.inspect}"
  end

  test "tufibge sigla_uf" do
    @tufibge.sigla_uf = nil
    refute @tufibge.save, "Tufibge sigla_uf salvo com nil"
    @tufibge.sigla_uf = ""
    refute @tufibge.save, "Tufibge sigla_uf salvo vazio"
    @tufibge.sigla_uf = "Ac"
    assert @tufibge.save, "Tufibge sigla_uf não salvo no formato"
    @tufibge.sigla_uf = generate_string(256)
    refute @tufibge.save, "Tufibge sigla_uf salvo como maior que 255"
    @tufibge.sigla_uf = generate_string(1)
    refute @tufibge.save, "Tufibge sigla_uf salvo como menor que 2"
  end

  test "tufibge nome_uf" do
    @tufibge.nome_uf = nil
    refute @tufibge.save, "Tufibge nome_uf salvo com nil"
    @tufibge.nome_uf = ""
    refute @tufibge.save, "Tufibge nome_uf salvo vazio"
    @tufibge.nome_uf = "Ac"
    assert @tufibge.save, "Tufibge nome_uf não salvo no formato"
    @tufibge.nome_uf = generate_string(256)
    refute @tufibge.save, "Tufibge nome_uf salvo como maior que 255"
    @tufibge.nome_uf = generate_string(1)
    refute @tufibge.save, "Tufibge nome_uf salvo como menor que 2"
  end

  test "tufibge codigo_ibge" do
    @tufibge.codigo_ibge = nil
    refute @tufibge.save, "Tufibge codigo_ibge salvo com nil"
    @tufibge.codigo_ibge = ""
    refute @tufibge.save, "Tufibge codigo_ibge salvo vazio"
    @tufibge.codigo_ibge = "2222"
    assert @tufibge.save, "Tufibge codigo_ibge não salvo no formato"
    @tufibge.codigo_ibge = generate_string(256)
    refute @tufibge.save, "Tufibge codigo_ibge salvo como maior que 255"
    @tufibge.codigo_ibge = generate_string(1)
    refute @tufibge.save, "Tufibge codigo_ibge salvo como menor que 2"
  end
end
