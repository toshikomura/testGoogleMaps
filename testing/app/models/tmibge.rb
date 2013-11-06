# encoding: UTF-8
# Municípios dos estados brasileiros(Tmibge), número fixo de registros no
# banco de dados, carrega os valores do arquivo CSV:
# "script/csv/tmibges.csv", usando o script: "script/tmibges.rb", para
# adicionar um município alterar o arquivo csv e executar o script.
#
# @todo 
#   Os atributos codigo_ibge, nome_municipio e tufibge_id deveriam ser
#   protegidos ?, já que são registros fixos no banco de dados, isto é,
#   definir como attr_protected.
#
# = Associações
# == has_many
# - {Profissional}
# - {Orgao}
# - {Prefeitura}
#
# == belongs_to
# - {Tufibge}
#
# = Validações
# == presence_of
# - +codigo_ibge+
# - +nome_municipio+
# - +tufibge_id+
#
# == numericality_of
# - +tufibge_id+ -> only_integer
#
# == length_of
# - +codigo_ibge+ -> minimum 2, maximum 255
# - +nome_municipio+ -> minimum 2, maximum 255
#
# @!attribute [rw] codigo_ibge
#   Código do município no IBGE.
#   @return [String]
#   
# @!attribute [rw] nome_municipio
#   Nome do município.
#   @return [String] 
#
# @!attribute [rw] tufibge_id
#   Estado do município, chave estrangeira para {Tufibge}.
#   @return [Integer]
#
# @!attribute [r] id
#   Chave primária.
#   @return [Integer]
# 
class Tmibge < ActiveRecord::Base
  ##############################
  # Associações                #
  ##############################
  has_many :profissionais
  has_many :orgaos
  has_many :prefeituras
  belongs_to :tufibge

  ##############################
  # Atributos                  #
  ##############################
  attr_accessible :codigo_ibge, :nome_municipio, :tufibge_id
  attr_protected :id

  ##############################
  # Validações                #
  ##############################
  validates_presence_of :codigo_ibge, :nome_municipio, :tufibge_id
  validates_numericality_of :tufibge_id, only_integer: true
  validates_length_of :codigo_ibge, :nome_municipio, minimum: 2, maximum: 255
end
