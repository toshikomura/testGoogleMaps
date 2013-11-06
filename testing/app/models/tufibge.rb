# encoding: UTF-8
# Estados brasileiros(Tufibge), número fixo de registros no
# banco de dados, carrega os valores do arquivo CSV:
# "script/csv/tufibges.csv", usando o script: "script/tufibges.rb", para
# adicionar um estado alterar o arquivo csv e executar o script.
#
# @todo 
#   Os atributos codigo_ibge, nome_uf e sigla_uf deveriam ser
#   protegidos ?, já que são registros fixos no banco de dados, isto é,
#   definir como attr_protected.
#
# = Associações
# == has_many
# - {Profissional} 
# - {Orgao}
# - {Prefeitura}
# - {Tmibge}
#
# = Validações
# == presence_of
# - +codigo_ibge+
# - +nome_uf+
# - +sigla_uf+
#
# == length_of
# - +codigo_ibge+ -> minimum 2, maximum 255
# - +nome_uf+ -> minimum 2, maximum 255
# - +sigla_uf+ -> minimum 2, maximum 2
#
# @!attribute [rw] codigo_ibge
#   Código do estado no IBGE.
#   @return [String]
#   
# @!attribute [rw] nome_uf
#   Nome do estado(unidade da federação).
#   @return [String] 
#
# @!attribute [rw] sigla_uf
#   Sigla do estado.
#   @return [String]
#
# @!attribute [r] id
#   Chave primária.
#   @return [Integer]
#
class Tufibge < ActiveRecord::Base
  ##############################
  # Associações                #
  ##############################
  has_many :profissionais
  has_many :orgaos
  has_many :prefeituras
  has_many :tmibges

  ##############################
  # Atributos                  #
  ##############################
  attr_accessible :codigo_ibge, :nome_uf, :sigla_uf
  attr_protected :id

  ##############################
  # Validações                #
  ##############################
  validates_presence_of :codigo_ibge, :nome_uf, :sigla_uf
  validates_length_of :codigo_ibge, :nome_uf, minimum: 2, maximum: 255
  validates_length_of :sigla_uf, minimum: 2, maximum: 2
end
