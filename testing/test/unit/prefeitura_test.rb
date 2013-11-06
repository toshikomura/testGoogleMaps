# encoding: UTF-8
require 'test_helper'

class PrefeituraTest < ActiveSupport::TestCase
  setup do
    @prefeitura = prefeituras(:prefeituras_Curitiba)
  end

  test "Prefeitura fixture" do
    assert @prefeitura.save, "Fixture inválida"
  end

  test "Prefeitura tufibge_id" do
    @prefeitura.tufibge_id = nil
    refute @prefeitura.save, "prefeitura tufibge_id salvo como nil"

    @prefeitura.tufibge_id = ""
    refute @prefeitura.save, "prefeitura tufibge_id salvo como vazio"
  end

  test "Prefeitura tmibge_id" do
    @prefeitura.tmibge_id = nil
    refute @prefeitura.save, "prefeitura tmibge_id salvo como nil"

    @prefeitura.tmibge_id = ""
    refute @prefeitura.save, "prefeitura tmibge_id salvo como vazio"
  end

  test "Prefeitura nome" do
    @prefeitura.nome = nil
    refute @prefeitura.save, "prefeitura nome salvo como nil"

    @prefeitura.nome = ""
    refute @prefeitura.save, "prefeitura nome salvo como vazio"

    @prefeitura.nome = generate_string(256)
    refute @prefeitura.save, "prefeitura nome salvo com string maior que 255 caracteres"
  end

  test "Prefeitura cep" do
    @prefeitura.cep = nil
    refute @prefeitura.save, "prefeitura cep salvo como nil"

    @prefeitura.cep = ""
    refute @prefeitura.save, "prefeitura cep salvo como vazio"

    @prefeitura.cep = "abcde-999"
    refute @prefeitura.save, "prefeitura cep salvo com string invalido: abcde-999"

    @prefeitura.cep = "abcde"
    refute @prefeitura.save, "prefeitura cep salvo com string invalido: abcde"

    @prefeitura.cep = "999"
    refute @prefeitura.save, "prefeitura cep salvo com string invalido: 999"

    @prefeitura.cep = "99-99"
    refute @prefeitura.save, "prefeitura cep salvo com string invalido: 99-99"
  end

  test "Prefeitura bairro" do
    @prefeitura.bairro = nil
    refute @prefeitura.save, "prefeitura bairro salvo como nil"

    @prefeitura.bairro = ""
    refute @prefeitura.save, "prefeitura bairro salvo como vazio"

    @prefeitura.bairro = generate_string(256)
    refute @prefeitura.save, "prefeitura bairro salvo com string maior que 255 caracteres"
  end

  test "Prefeitura endereco" do
    @prefeitura.endereco = nil
    refute @prefeitura.save, "prefeitura endereco salvo como nil"

    @prefeitura.endereco = ""
    refute @prefeitura.save, "prefeitura endereco salvo como vazio"

    @prefeitura.endereco = generate_string(256)
    refute @prefeitura.save, "prefeitura endereco salvo com string maior que 255 caracteres"
  end

  test "Prefeitura numero_endereco" do
    @prefeitura.endereco = nil
    refute @prefeitura.save, "prefeitura numero_endereco salvo como nil"

    @prefeitura.endereco = ""
    refute @prefeitura.save, "prefeitura numero_endereco salvo como vazio"

    @prefeitura.cep = "abcde"
    refute @prefeitura.save, "prefeitura cep salvo com string invalido: abcde"
  end

  test "Prefeitura complemento_endereco" do
    @prefeitura.complemento_endereco = generate_string(256)
    refute @prefeitura.save, "prefeitura complemento_endereco salvo com string maior que 255 caracteres"
  end

  test "Prefeitura telefone" do
    @prefeitura.telefone1 = "((41)11233321"
    refute @prefeitura.save, "prefeitura telefone1 salvo com string invalido: ((41)11233321"
    @prefeitura.telefone2 = "((41)11233321"
    refute @prefeitura.save, "prefeitura telefone2 salvo com string invalido: ((41)11233321"

    @prefeitura.telefone1 = "(41)112-321"
    refute @prefeitura.save, "prefeitura telefone1 salvo com string invalido: (41)112-321"
    @prefeitura.telefone2 = "(41)112-321"
    refute @prefeitura.save, "prefeitura telefone2 salvo com string invalido: (41)112-321"

    @prefeitura.telefone1 = "(41)11923921"
    refute @prefeitura.save, "prefeitura telefone1 salvo com string invalido: (41)11923921"
    @prefeitura.telefone2 = "(41)11233321"
    refute @prefeitura.save, "prefeitura telefone2 salvo com string invalido: (41)11923921"
  end

  test "Prefeitura email" do
    @prefeitura.email = "asdasd@asd@asd"
    refute @prefeitura.save, "prefeitura email salvo com string invalido: asdasd@asd@asd"

    @prefeitura.email = "asdasd@"
    refute @prefeitura.save, "prefeitura email salvo com string invalido: asdasd@"

    @prefeitura.email = "@@@@@aaaaa"
    refute @prefeitura.save, "prefeitura email salvo com string invalido: @@@@@aaaaa"

    @prefeitura.email = "@a.a"
    refute @prefeitura.save, "prefeitura email salvo com string invalido: @a.a"

    @prefeitura.email = "asdasd@asd@asd"
    refute @prefeitura.save, "prefeitura email salvo com string invalido: asdasd@asd@asd"

    @prefeitura.email = "asd$%#&*asd@asd.asd"
    refute @prefeitura.save, "prefeitura email salvo com string invalido: asd$%#&*asd@asd.asd"

    @prefeitura.email = "also@tess.tess.vs"
    assert @prefeitura.save, "prefeitura email deveria aceitar a string: asdasd@"

    @prefeitura.email = "__ellmaisl__@assa.ass.a"
    assert @prefeitura.save, "prefeitura email deveria aceitar a string: __ellmaisl__@assa.ass.a"

    @prefeitura.email = "__e-ll-m023aisl__@assa.ass.a"
    assert @prefeitura.save, "prefeitura email deveria aceitar a string: __e-ll-m023aisl__@assa.ass.a"
  end

  test "Prefeitura logo" do
  # O que deveria ser testado aqui?
    assert true
  end



end
