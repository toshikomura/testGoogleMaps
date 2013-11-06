# encoding: UTF-8
require 'test_helper'

class CidadaoTest < ActiveSupport::TestCase
  setup do
    @cidadao = cidadaos(:cidadaos_Jose_Artur)
  end

  test "cidadao cpf" do
    @cidadao.cpf = ""
    refute @cidadao.save, "cidadao salvo com campo 'cpf' vazio/em branco."
  
    @cidadao.cpf = "123456789-00"
    refute @cidadao.save, "cidadao salvo com campo 'cpf' inválido"

    @cidadao.cpf = @cidadao.cpf.gsub("/[.-]/", "")
    refute @cidadao.save, "cidadao salvo com campo 'cpf' inválido (sem formatação)"
  end

  test "cidadao nome" do
    @cidadao.nome = ""
    refute @cidadao.save, "cidadao salvo com campo 'nome' vazio/em branco."

    @cidadao.nome = generate_string(256)
    refute @cidadao.save, "cidadao salvo com tamanho do campo 'nome' maior que 255 caracteres."
  end

  test "cidadao rg" do
    @cidadao.rg = ""
    refute @cidadao.save, "cidadao salvo com campo 'rg' vazio/em branco."

    @cidadao.rg = generate_string(12)
    refute @cidadao.save, "cidadao salvo com tamanho do campo 'rg' maior que 11 caracteres."
  end

  test "cidadao password" do
    @cidadao.password = ""
    refute @cidadao.save, "cidadao salvo com campo 'rg' vazio/em branco."

    @cidadao.password = generate_string(5)
    refute @cidadao.save, "cidadao salvo com tamanho do campo 'passsword' menor que 6 caracteres"

    @cidadao.password = generate_string(129)
    refute @cidadao.save, "cidadao salvo com tamanho do campo 'password' maior que 128 caracteres"
  end

  test "cidadao telefone1" do
    @cidadao.telefone1 = "99 99999999"
    refute @cidadao.save, "cidadao telefone1 com formato inválido (formato: #{@cidadao.telefone1}) foi salvo"

    @cidadao.telefone1 = "9999999999"
    refute @cidadao.save, "cidadao telefone1 com formato inválido (formato: #{@cidadao.telefone1}) foi salvo"

    @cidadao.telefone1 = "99 9999-9999"
    refute @cidadao.save, "cidadao telefone1 com formato inválido (formato: #{@cidadao.telefone1}) foi salvo"

    @cidadao.telefone1 = "(99)99999999"
    refute @cidadao.save, "cidadao telefone1 com formato inválido (formato: #{@cidadao.telefone1}) foi salvo"

    @cidadao.telefone1 = "(99) 9999-9999"
    refute @cidadao.save, "cidadao telefone1 com formato inválido (formato: #{@cidadao.telefone1}) foi salvo"
  end

  test "cidadao email" do
    @cidadao.email = generate_string(10)
    refute @cidadao.save, "cidadao com campo 'email' inválido foi salvo"
  end
end
