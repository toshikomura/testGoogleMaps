# encoding: UTF-8
# Tipo de ação da escala(Tipo_acoes), número fixo de registros no
# banco de dados, carrega os valores do arquivo CSV:
# "script/csv/tipo_acoes.csv", usando o script:
# "script/tipo_acoes.rb", para adicionar um tipo de ação alterar o
# arquivo csv e executar o script.
#
# @todo 
#   Osatributo descricao deveria ser protegido ?, já que são
#   registros fixos no banco de dados, isto é, definir como attr_protected.
#
# = Associações
# == has_many
#   - {Escala} 
#
# = Validações
# == presence_of
#   - +descricao+
#
# == length_of
#   - +descricao+ -> maximum 255
#
# @!attribute [rw] descricao
#   Descrição da ação da escala.
#   @return [String]
#
# @!attribute [r] id
#   Chave primária.
#   @return [Integer]
#
class TipoAcao < ActiveRecord::Base
  ##############################
  # Associações                #
  ##############################
  has_many :escalas

  ##############################
  # Atributos                  #
  ##############################
  attr_accessible :descricao
  attr_protected :id
 
  ##############################
  # Validações                 #
  ##############################
  validates_presence_of :descricao
  validates_length_of :descricao, maximum: 255
end
