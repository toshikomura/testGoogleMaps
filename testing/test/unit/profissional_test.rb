# encoding: UTF-8
require 'test_helper'

class ProfissionalTest < ActiveSupport::TestCase
  setup do
    @profissional = profissionais(:profissionais_Administrador_Sistema_Oswaldo_Cruz)
  end

  ##############################
  # Tests for the cpf field    #
  ##############################
  test "profissional cpf vazio" do
    @profissional.cpf = ""
    refute @profissional.save, "salvo profissional com campo 'cpf' vazio."
  end

  test "profissional cpf unico" do
    @profissional2 = profissionais(:profissionais_Administrador_Zilda_Arns)
    @profissional2.cpf = @profissional.cpf
    @profissional2.valid?
    assert_not_nil @profissional2.errors.include?(:cpf), "salvo profissional com cpf que já havia sido cadastrado"
  end

  test "profissional cpf formato invalido" do
    @profissional.cpf = "69293644010"
    refute @profissional.save, "salvo profissional com CPF em formato inválido."

    @profissional.cpf = "6929364401"
    refute @profissional.save, "salvo profissional com CPF inválido em formato inválido."
  end

  test "profissional cpf invalido" do
    @profissional.cpf = "123.456.789-00" 
    refute @profissional.save, "salvo profissional com CPF inválido"
  end

  ################################
  # Tests for the password field #
  ################################
  test "profissional password vazio" do
    @profissional.password = ""
    refute @profissional.save, "salvo profissional com senha vazia."
  end

  test "profissional password tamanho" do
    @profissional.password = generate_string(5)
    refute @profissional.save, "salvo profissional com senha menor que 6 caracteres." 

    @profissional.password = generate_string(129)
    refute @profissional.save, "salvo profissional com senha maior que 128 caracteres."
  end

  ################################
  # Tests for the role field     #
  ################################
  test "profissional role invalida" do
    @profissional.role = generate_string(8)
    refute @profissional.save, "salvo profissional com role inválida." 
  end

  test "profissional email" do
    @profissional.email = generate_string(10)
    refute @profissional.save, "profissional com e-mail inválido foi salvo"
  end
  
  test "profissional telefone1" do
    @profissional.telefone1 = "99 99999999"
    refute @profissional.save, "profissional telefone1 com formato inválido (formato: #{@profissional.telefone1}) foi salvo"

    @profissional.telefone1 = "9999999999"
    refute @profissional.save, "profissional telefone1 com formato inválido (formato: #{@profissional.telefone1}) foi salvo"

    @profissional.telefone1 = "99 9999-9999"
    refute @profissional.save, "profissional telefone1 com formato inválido (formato: #{@profissional.telefone1}) foi salvo"

    @profissional.telefone1 = "(99)99999999"
    refute @profissional.save, "profissional telefone1 com formato inválido (formato: #{@profissional.telefone1}) foi salvo"

    @profissional.telefone1 = "(99) 9999-9999"
    refute @profissional.save, "profissional telefone1 com formato inválido (formato: #{@profissional.telefone1}) foi salvo"
  end

  test "profissional tmibge_id" do
    @profissional.tmibge_id = nil
    refute @profissional.save, "profissional com campo 'tmibge_id' vazio foi salvo"
  end

  test "profissional tufibge_id" do
    @profissional.tufibge_id = nil
    refute @profissional.save, "profissional com campo 'tufibge_id' vazio foi salvo"
  end

  test "profissional tcbo_id" do
    @profissional.tcbo_id = nil
    refute @profissional.save, "profissional com campo 'tcbo_id' vazio foi salvo"
  end

  test "profissional tconselho_id" do
    @profissional.tconselho_id = nil
    refute @profissional.save, "profissional com campo 'tconselho_id' vazio foi salvo"
  end

  test "profissional orgao_id" do
    @profissional.orgao_id = nil
    refute @profissional.save, "profissional com campo 'orgao_id' vazio foi salvo"
  end
end
