# encoding: UTF-8
require 'test_helper'

class TconselhoTest < ActiveSupport::TestCase
  setup do
    @tconselho = tconselhos(:tconselhos_CRM_PR)
  end

  test "tconselho vazio" do
    @tconselho = Tconselho.new
    refute @tconselho.save, "tconselho salvo sem dados."
  end

  test "tconselho descricao" do
    @tconselho.descricao = ""
    refute @tconselho.save, "tconselho salvo com campo 'descricao' vazio."
  end

  test "tconselho sigla_conselho" do
    @tconselho.sigla_conselho = ""
    refute @tconselho.save, "tconselho salvo com campo 'sigla_conselho' vazio."
  end

  test "tconselho fixture valida" do
    assert @tconselho.save, "tconselho não foi salvo com dados válidos."
  end
end
