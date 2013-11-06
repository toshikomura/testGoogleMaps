# encoding: UTF-8
require 'test_helper'

class TcboTest < ActiveSupport::TestCase
  setup do
    @tcbo = tcbos(:tcbos_Administrador)
  end

  test "tcbos descricao" do
    @tcbo.descricao = ""
    refute @tcbo.save, "tcbo salvo com campo 'descricao' vazio."
  end

  test "tcbos codigo_cbo" do
    @tcbo.codigo_cbo = ""
    refute @tcbo.save, "tcbo salvo com campo 'codigo_cbo' vazio."
  end

  test "tcbos fixture" do
    assert @tcbo.save, "tcbo não foi salvo com dados válidos."
  end
end
