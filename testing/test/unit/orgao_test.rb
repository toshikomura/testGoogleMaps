# encoding: UTF-8
require 'test_helper'

class OrgaoTest < ActiveSupport::TestCase
  setup do
    @orgao = orgaos(:orgaos_Unidade_Saude_Cajuru)
  end

  test "orgaos fixture" do
    assert @orgao.save, "Orgaos fixture inválida"
  end

  test "orgaos tufibge_id" do
    @orgao.tufibge_id = nil
    refute @orgao.save, "Orgaos tufibge_id salvo como nil"

    @orgao.tufibge_id = ""
    refute @orgao.save, "Orgaos tufibge_id salvo como vazio"
  end

  test "orgaos tmibge_id" do
    @orgao.tmibge_id = nil
    refute @orgao.save, "Orgaos tmibge_id salvo como nil"

    @orgao.tmibge_id = ""
    refute @orgao.save, "Orgaos tmibge_id salvo como vazio"
  end

  test "orgaos nome" do
    @orgao.nome = nil
    refute @orgao.save, "Orgaos nome salvo como nil"

    @orgao.nome = ""
    refute @orgao.save, "Orgaos nome salvo como vazio"

    @orgao.nome = generate_string(256)
    refute @orgao.save, "Orgaos nome salvo como maior que 255 "
  end

  test "orgaos cep" do
    @orgao.cep = nil
    assert @orgao.save, "Orgaos cep não salvo como nil"

    @orgao.cep = ""
    assert @orgao.save, "Orgaos cep não salvo como vazio"

    @orgao.cep = "99999-999"
    assert @orgao.save, "Orgaos cep não salvo com formato válido 99999-999"

    @orgao.cep = "99999-9999"
    refute @orgao.save, "Orgaos cep salvo com formato inválido 99999-9999"

    @orgao.cep = "99999-99"
    refute @orgao.save, "Orgaos cep salvo com formato inválido 99999-99"

    @orgao.cep = "AAAAA-AAA"
    refute @orgao.save, "Orgaos cep salvo com formato inválido AAAAA-AAA"
  end

  test "orgaos bairro" do
    @orgao.bairro = nil
    refute @orgao.save, "Orgaos bairro salvo como nil"

    @orgao.bairro = ""
    refute @orgao.save, "Orgaos bairro salvo como vazio"

    @orgao.bairro = generate_string(256)
    refute @orgao.save, "Orgaos bairro salvo como maior que 255"
  end

  test "orgaos endereco" do
    @orgao.endereco = nil
    refute @orgao.save, "Orgaos endereco salvo como nil"

    @orgao.endereco = ""
    refute @orgao.save, "Orgaos endereco salvo como vazio"

    @orgao.endereco = generate_string(256)
    refute @orgao.save, "Orgaos endereco salvo como maior que 255"
  end

  test "orgaos numero_endereco" do
    @orgao.numero_endereco = nil
    refute @orgao.save, "Orgaos numero_endereco salvo como nil"

    @orgao.numero_endereco = ""
    refute @orgao.save, "Orgaos numero_endereco salvo como vazio"

    @orgao.numero_endereco = generate_string(10)
    refute @orgao.save, "Orgaos numero_endereco salvo como string"

    @orgao.numero_endereco = 3.14316
    refute @orgao.save, "Orgaos numero_endereco salvo como float"

    @orgao.numero_endereco = 0
    refute @orgao.save, "Orgaos numero_endereco salvo como 0"

    @orgao.numero_endereco = -1
    refute @orgao.save, "Orgaos numero_endereco salvo como -1"

    @orgao.numero_endereco = 2147483648 # Ver postgresql.org/docs/9.1/static/datatype-numeric.html
    refute @orgao.save, "Orgaos numero_endereco salvo como maior que 2^16"
  end

  test "orgaos complemento_endereco" do
    @orgao.complemento_endereco = nil
    assert @orgao.save, "Orgaos complemento_endereco não salvo como nil"

    @orgao.complemento_endereco = ""
    assert @orgao.save, "Orgaos complemento_endereco não salvo como vazio"

    @orgao.complemento_endereco = generate_string(256)
    refute @orgao.save, "Orgaos complemento_endereco salvo como maior que 255"
  end

  test "orgaos telefone1" do
    @orgao.telefone1 = nil
    assert @orgao.save, "Orgaos telefone1 não salvo como nil"

    @orgao.telefone1 = ""
    assert @orgao.save, "Orgaos telefone1 não salvo como vazio"

    @orgao.telefone1 = "(99)9999-9999"
    assert @orgao.save, "Orgaos telefone1 não salvo com formato válido (99)9999-9999"

    @orgao.telefone1 = "(99)9999-99999"
    refute @orgao.save, "Orgaos telefone1 salvo com formato inválido (99)9999-99999"

    @orgao.telefone1 = "(99)9999-999"
    refute @orgao.save, "Orgaos telefone1 salvo com formato inválido (99)9999-999"

    @orgao.telefone1 = "(AA)AAAA-AAAA"
    refute @orgao.save, "Orgaos telefone1 salvo com formato inválido (AA)AAAA-AAAA"
  end
 
  test "orgaos telefone2" do
    @orgao.telefone2 = nil
    assert @orgao.save, "Orgaos telefone2 não salvo como nil"

    @orgao.telefone2 = ""
    assert @orgao.save, "Orgaos telefone2 não salvo como vazio"

    @orgao.telefone2 = "(99)9999-9999"
    assert @orgao.save, "Orgaos telefone2 não salvo com formato válido (99)9999-9999"

    @orgao.telefone2 = "(99)9999-99999"
    refute @orgao.save, "Orgaos telefone2 salvo com formato inválido (99)9999-99999"

    @orgao.telefone2 = "(99)9999-999"
    refute @orgao.save, "Orgaos telefone2 salvo com formato inválido (99)9999-999"

    @orgao.telefone2 = "(AA)AAAA-AAAA"
    refute @orgao.save, "Orgaos telefone2 salvo com formato inválido (AA)AAAA-AAAA"
  end

  test "orgaos email" do
    @orgao.email = nil
    assert @orgao.save, "Orgaos email não salvo como nil"

    @orgao.email = ""
    assert @orgao.save, "Orgaos email não salvo como vazio"

    @orgao.email = "aaa@aa.aa"
    assert @orgao.save, "Orgaos email não salvo com formato válido *@*.*"

    @orgao.email = "aaa.a"
    refute @orgao.save, "Orgaos email salvo com formato inválido *.*"

    @orgao.email = "aaa@.a"
    refute @orgao.save, "Orgaos email salvo com formato inválido *@.*"

    @orgao.email = "@aa.aaa"
    refute @orgao.save, "Orgaos email salvo com formato inválido @*.*"

    @orgao.email = "aaa@aa"
    refute @orgao.save, "Orgaos email salvo com formato inválido *@*"

    @orgao.email = generate_string(252) + "@a.a"
    refute @orgao.save, "Orgaos email salvo como maior que 255"
  end

  test "orgaos url" do
    @orgao.url = nil
    assert @orgao.save, "Orgaos url não salvo como nil"

    @orgao.url = ""
    assert @orgao.save, "Orgaos url não salvo como vazio"

    @orgao.url = generate_string(256)
    refute @orgao.save, "Orgaos url salvo como maior que 255"
  end

  test "orgaos ativo" do
    @orgao.ativo = nil
    refute @orgao.save, "Orgaos ativo salvo como nil"
  end
end
