# encoding: UTF-8
require 'test_helper'

class TipoAtendimentoTest < ActiveSupport::TestCase
  setup do
    @tipo_atendimento = tipo_atendimentos(:tipo_atendimentos_Consulta_Ambulatorial)
  end

  test "Tipo atendimento fixture" do
    assert @tipo_atendimento.save, "Fixture invalida"
  end

  test "Tipo atendimento descricao" do
    @tipo_atendimento.descricao = nil
    refute @tipo_atendimento.save, "tipo_atendimento descricao salva como nil"

    @tipo_atendimento.descricao = ""
    refute @tipo_atendimento.save, "tipo_atendimento descricao salva como vazia"

    @tipo_atendimento.descricao = generate_string(256)
    refute @tipo_atendimento.save, "tipo_atendimento descricao salva como maior que 255"
  end

  test "Tipo atendimento ativo" do
    @tipo_atendimento.ativo = nil
    refute @tipo_atendimento.save, "tipo_atendimento ativo salvo como nil"

    @tipo_atendimento.ativo = ""
    refute @tipo_atendimento.save, "tipo_atendimento ativo salvo como vazia"
  end
end
