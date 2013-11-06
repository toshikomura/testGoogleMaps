# encoding: UTF-8
# Tipos de ocupações brasileiras definida pelo CBO-Ministério do Trabalho e
# Emprego (Tcbos), número fixo de registros no banco de dados, carrega os
# valores do arquivo CSV: "script/csv/tcbos.csv", usando o script:
# "script/tcbos.rb", para adicionar um tipo de ocupação alterar o
# arquivo csv e executar o script.
# Ver Classificação Brasileira de Ocupações:
# {http://www.mtecbo.gov.br/cbosite/pages/home.jsf}
#
# @todo 
#   verificar as validações, tamanho máximo de descrição e código CBO.
#
# @todo 
#   Os atributos codigo_cbo e descricao deveriam ser protegidos ?, já que são
#   registros fixos no banco de dados, isto é, definir como attr_protected.
#
# = Associações
# == has_many
#   - {Profissional} 
#
# = Validações
# == presence_of
#   - +descricao+
#   - +codigo_cbo+
#
# @!attribute [rw] descricao
#   Descrição do tipo de ocupação.
#   @return [String]
#
# @!attribute [rw] codigo_cbo
#   Código da ocupação no CBO-Ministério do Trabalho.
#   @return [String]
#
# @!attribute [r] id
#   Chave primária.
#   @return [Integer]
#
class Tcbo < ActiveRecord::Base
  ##############################
  # Associações                #
  ##############################
  has_many :profissionais

  ##############################
  # Atributos                  #
  ##############################
  attr_accessible :codigo_cbo, :descricao
  attr_protected :id

  ##############################
  # Validações                 #
  ##############################
  validates_presence_of :codigo_cbo, :descricao
end
