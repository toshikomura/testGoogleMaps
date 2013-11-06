# encoding: UTF-8
# Tipos de atendimentos das escalas, registros no banco de dados podem ser
# carregados usando o script: "script/tipo_atendimentos.rb", que carrega os
# valores do arquivo CSV: "script/csv/tipo_atendimentos.csv".
# Nenhum registro é excluído do banco de dados, apenas recebe uma indicação
# que está inativo, atributo "ativo" igual a "false".
#
# = Associações
# == has_and_belongs_to_many
# - {Orgao}   
#
# == has_many
# - {Escala} 
#
# = Validações
# == presence_of
# - +descricao+
#
# == inclusion_of
# - +ativo+ -> in [true, false]
#
# == length_of
# - +descricao+ -> maximum 255
#
# = Callbacks
# == before_create
# - {#default_values}
#
# @!attribute [rw] descricao
#   Descrição do tipo de atendimento.
#   @return [String]
#
# @!attribute [rw] ativo
#   Situação do tipo de atendimento, ativo(true) ou inativo(false).
#   @return [Boolean]
#
# @!attribute [rw] id
#   Chave primária.
#   @return [Integer]
#
class TipoAtendimento < ActiveRecord::Base
  ##############################
  # Associações                #
  ##############################
  has_and_belongs_to_many :orgaos
  has_many :escalas

  ##############################
  # Atributos                  #
  ##############################
  attr_accessible :descricao, :ativo, :id

  ##############################
  # Validações                 #
  ##############################
  validates_presence_of :descricao
  validates_inclusion_of :ativo, :in => [true,false]
  validates_length_of :descricao, maximum: 255
 
  ##############################
  # Callbacks                  #
  ##############################
  before_create :default_values
  
  ##############################
  # Métodos                    #
  ##############################
  protected
    # Atribui valores padrões na criação do tipo de atendimento.
    def default_values
      self.ativo = true
    end
end
