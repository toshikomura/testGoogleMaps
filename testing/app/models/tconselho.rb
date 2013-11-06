# encoding: UTF-8
# Conselhos profissionais(Tconselhos), número fixo de registros no
# banco de dados, carrega os valores do arquivo CSV:
# "script/csv/tconselhos.csv", usando o script:
# "script/tconselhos.rb", para adicionar um conselho alterar o
# arquivo csv e executar o script.
#
# @todo 
#   verificar as validações, tamanho máximo de descrição e sigla.
#
# @todo 
#   Os atributos sigla_conselho e descricao deveriam ser protegidos ?, já que são
#   registros fixos no banco de dados, isto é, definir como attr_protected.
#
# = Associações
# == has_many
#   - {Profissional} 
#
# = Validações
# == presence_of
#   - +descricao+
#   - +sigla_conselho+
#
# @!attribute [rw] descricao
#   Descrição do conselho profissional.
#   @return [String]
#
# @!attribute [rw] sigla_conselho
#   Sigla do conselho profissional.
#   @return [String]
#
# @!attribute [r] id
#   Chave primária.
#   @return [Integer]
#
class Tconselho < ActiveRecord::Base
  ##############################
  # Associações                #
  ##############################
  has_many :profissionais

  ##############################
  # Atributos                  #
  ##############################
  attr_accessible :descricao, :sigla_conselho
  attr_protected :id

  ##############################
  # Validações                 #
  ##############################
  validates_presence_of :descricao, :sigla_conselho
end
