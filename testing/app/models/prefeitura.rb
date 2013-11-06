# encoding: UTF-8
# Prefeitura, possui apenas um registro no banco de dados carregado usando o
# script: "script/prefeitura.rb", que cria uma prefeitura com valores
# padrões se não houver uma prefeitura existente, caso contrário reseta os
# valores.
#
# @todo
#   Remover a associação desnecessária com a tabela de estados (Tufibge).
#
# = Associações
# == has_many
# - {Orgao} 
#
# == belongs_to
# - {Tufibge}
# - {Tmibge}
#
# = Validações
# == presence_of
# - +nome+
# - +cep+
# - +bairro+
# - +endereco+
# - +numero_endereco+
# - +tufibge_id+
# - +tmibge_id+
# - +dias_bloqueio+
# - +limite_cancelamento+
# - +max_agendamentos+
# - +periodo_agendamentos+
# - +max_faltas+
# - +antecedencia_avisos+
#
# == numericality_of
# - +numero_endereco+ -> greater_than 0
# - +dias_bloqueio+ -> greater_than 0
# - +limite_cancelamento+ -> greater_than 0
# - +max_agendamentos+ -> greater_than 0
# - +max_faltas+ -> greater_than 0
# - +periodo_agendamentos+ -> greater_than 0
# - +antecedencia_avisos+ -> greater_than 0 
#
# == length_of
# - +nome+ -> maximum 255
# - +bairro+ -> maximum 255
# - +endereco+ -> maximum 255
# - +complemento_endereco+ -> maximum 255
#
# == validates_with
# - {EmailValidator}
# - {CepValidator}
# - {PhonesValidator} -> fields [telefone1, telefone2]
#
# @!attribute [rw] bairro
#   Bairro do endereço da sede da prefeitura.
#   @return [String]
#
# @!attribute [rw] cep
#   CEP do endereço da sede da prefeitura, ver {CepValidator} sobre o
#   formato esperado.
#   @return [String]
#
# @!attribute [rw] complemento_endereco
#   Complemento do endereço da sede da prefeitura.
#   @return [String]
#
# @!attribute [rw] email
#   E-mail da prefeitura, ver {EmailValidator} sobre o formato esperado.
#   @return [String]
#
# @!attribute [rw] endereco
#   Endereço da sede da prefeitura.
#   @return [String]
#
# @!attribute [rw] logo
#   Path para o logotipo da prefeitura, padrão:
#   app/assets/images/logotipo.png
#   @return [String]
#
# @!attribute [rw] nome
#   Nome da prefeitura
#   @return [String]
#
# @!attribute [rw] numero_endereco
#   Número do endereço da sede da prefeitura.
#   @return [Integer]
#
# @!attribute [rw] telefone1
#   Primeiro telefone da prefeitura, ver {PhonesValidator} sobre o formato
#   esperado.
#   @return [String]
#
# @!attribute [rw] telefone2
#   Segundo telefone da prefeitura, ver {PhonesValidator} sobre o formato
#   esperado.
#   @return [String]
#
# @!attribute [rw] tufibge_id
#   Estado da prefeitura, chave estrangeira para {Tufibge}.
#   @return [Integer]
#
# @!attribute [rw] tmibge_id
#   Município da prefeitra, chave estrangeira para {Tmibge}.
#   @return [Integer]
#
# @!attribute [rw] dias_bloqueio
#   Dias de bloqueio de um cidadão ao não comparecer aos agendamentos.
#   @return [Integer]
#
# @!attribute [rw] limite_cancelamento
#   Limite em horas para o cancelamento de um agendamento.
#   @return [Integer]
#
# @!attribute [rw] max_agendamentos
#   Número máximo de agendamentos(em aberto).
#   @return [Integer]
#
# @!attribute [rw] periodo_agendamentos
#   Periodo em dias para contagem dos agendamentos(usado para definir
#   bloqueio por não comparecimento).
#   @return [Integer]
#
# @!attribute [rw] antecedencia_avisos
#   Horas de antecedencia para gerar avisos sobre agendamentos.
#   @return [Integer]
#
# @!attribute [rw] max_faltas
#   Número máximo de faltas para gerar um bloqueio(dentro do periodo
#   estipulado por periodo_agendamentos).
#   @return [Integer]
#
# @!attribute [rw] id
#   Chave primária.
#   @return [Integer]
#
class Prefeitura < ActiveRecord::Base
  ##############################
  # Associações                #
  ##############################
  belongs_to :tufibge, :foreign_key => "tufibge_id"
  belongs_to :tmibge, :foreign_key => "tmibge_id"
  has_many :orgaos

  ##############################
  # Atributos                  #
  ##############################
  attr_accessible :bairro, :cep, :complemento_endereco, :email, :endereco,
:logo, :nome, :numero_endereco, :telefone1, :telefone2, :tufibge_id,
:tmibge_id, :dias_bloqueio, :limite_cancelamento, :max_agendamentos,
:periodo_agendamentos, :antecedencia_avisos, :max_faltas, :id

  ##############################
  # Validações                 #
  ##############################
  validates_presence_of :nome, :cep, :bairro, :endereco, :numero_endereco,
    :tufibge_id, :tmibge_id, :dias_bloqueio, :limite_cancelamento,
    :max_agendamentos, :periodo_agendamentos, :max_faltas,
    :antecedencia_avisos

  validates_with EmailValidator
  validates_with CepValidator
  validates_with PhonesValidator, fields: [:telefone1, :telefone2]

  validates_numericality_of :numero_endereco, :dias_bloqueio,
    :limite_cancelamento, :max_agendamentos, :max_faltas,
    :periodo_agendamentos, :antecedencia_avisos, :greater_than => 0 

  validates_length_of :nome, :bairro, :endereco, :complemento_endereco, maximum: 255
end
