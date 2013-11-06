# encoding: UTF-8
# Tipo de situação do agendamento(Tipo_situacoes), número fixo de registros no
# banco de dados, carrega os valores do arquivo CSV:
# "script/csv/tipo_situacoes.csv", usando o script:
# "script/tipo_situacoes.rb", para adicionar um tipo de situação alterar o
# arquivo csv e executar o script.
#
# @todo 
#   O atributo descricao deveria ser protegido ?, já que são
#   registros fixos no banco de dados, isto é, definir como attr_protected.
#
# = Associações
# == has_many
# - {Agendamento} 
#
# = Validações
# == presence_of
# - +descricao+
#
# == length_of
# - +descricao+ -> maximum 255
#
# @!attribute [rw] descricao
#   Descrição da situação do agendamento.
#   @return [String]
#
# @!attribute [r] id
#   Chave primária.
#   @return [Integer]
#
class TipoSituacao < ActiveRecord::Base
  ##############################
  # Associações                #
  ##############################
  has_many :agendamentos

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
