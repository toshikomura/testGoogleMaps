# encoding: UTF-8
require 'test_helper'

class TipoSituacaoTest < ActiveSupport::TestCase
  setup do
    @tipo_situacao = tipo_situacoes(:tipo_situacoes_Agendado)
  end

  test "tipo situacoes fixture" do
    assert @tipo_situacao.save, "Tipo situacoes fixture inválida"
  end

  test "tipo situacoes descricao" do
    @tipo_situacao.descricao = nil
    refute @tipo_situacao.save, "Tipo_situacoes descricao salva como nil"
 
    @tipo_situacao.descricao = ""
    refute @tipo_situacao.save, "Tipo_situacoes descricao salva como vazia"

    @tipo_situacao.descricao = generate_string(256)
    refute @tipo_situacao.save, "Tipo_situacoes descricao salva como maior que 255" 
  end
end
