# encoding: UTF-8
require 'test_helper'

class TipoAcaoTest < ActiveSupport::TestCase
  setup do
    @tipo_acao = tipo_acoes(:tipo_acoes_Inclusao)
  end

  test "tipo acoes fixture" do
    assert @tipo_acao.save, "Tipo_acoes fixture inválida"
  end

  test "tipo acoes descricao" do
    @tipo_acao.descricao = nil
    refute @tipo_acao.save, "Tipo_acoes descricao salva como nil"
 
    @tipo_acao.descricao = ""
    refute @tipo_acao.save, "Tipo_acoes descricao salva como vazia"

    @tipo_acao.descricao = generate_string(256)
    refute @tipo_acao.save, "Tipo_acoes descricao salva como maior que 255" 
  end
end
