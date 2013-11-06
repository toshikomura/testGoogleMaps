# encoding: UTF-8
# Órgãos da prefeitura(locais de atendimento), registros no banco de dados
# podem ser carregados usando o script: "script/orgaos.rb", que carrega os
# valores do arquivo CSV: "script/csv/orgaos.csv".
# Nenhum registro é excluído do banco de dados, apenas recebe uma indicação
# que está inativo, atributo "ativo" igual a "false".
# Um órgão sempre deve estar associado a prefeitura, se a prefeitura não
# exister o órgão não pode ser salvo.
#
# @todo
#   Remover a associação desnecessária com a tabela de estados (Tufibge).
#
# @todo
#   Remover a associação desnecessária com a tabela Agendamento.
#
# @todo
#   Remover validação de tamanho do email, implementar essa verificação no
#   validador {PhonesValidator}.
# 
# = Associações
# == has_and_belongs_to_many
# - {TipoAtendimento}   
#
# == has_many
# - {Profissional}
# - {Escala} 
# - {Agendamento}
#
# = Validações
# == presence_of
# - +nome+
# - +bairro+
# - +endereco+
# - +numero_endereco+
# - +tufibge_id+
# - +tmibge_id+
# - +prefeitura_id+
#
# == numericality_of
# - +numero_endereco+ -> only_integer true, greater_than 0, less_than 2147483648,
#   ver referência {http://www.postgresql.org/docs/8.3/interactive/datatype-numeric.html}
#
# == inclusion_of
# - +ativo+ -> in [true, false]
#
# == length_of
# - +nome+ -> maximum 255
# - +bairro+ -> maximum 255
# - +endereco+ -> maximum 255
# - +complemento_endereco+ -> maximum 255
# - +email+ -> maximum 255
# - +url+ -> maximum 255
#
# == validates_with
# - {EmailValidator}
# - {CepValidator}
# - {PhonesValidator} -> fields [telefone1, telefone2]
#  
# = Callbacks
# == before_validation
# - {#default_create_values} -> on create
# - {#default_update_values} -> on update
# 
# = Scopes
# - {#tipo_atendimento}
#
# @!attribute [rw] bairro
#   Bairro do endereço do órgão da prefeitura.
#   @return [String]
#
# @!attribute [rw] cep
#   CEP do endereço do órgão da prefeitura, ver {CepValidator} sobre o
#   formato esperado.
#   @return [String]
#
# @!attribute [rw] complemento_endereco
#   Complemento do endereço do órgão da prefeitura.
#   @return [String]
#
# @!attribute [rw] email
#   E-mail da prefeitura, ver {EmailValidator} sobre o formato esperado.
#   @return [String]
#
# @!attribute [rw] endereco
#   Endereço do órgão da prefeitura.
#   @return [String]
#
# @!attribute [rw] nome
#   Nome da órgão.
#   @return [String]
#
# @!attribute [rw] numero_endereco
#   Número do endereço do órgão da prefeitura.
#   @return [Integer]
#
# @!attribute [rw] telefone1
#   Primeiro telefone do órgão, ver {PhonesValidator} sobre o formato
#   esperado.
#   @return [String]
#
# @!attribute [rw] telefone2
#   Segundo telefone do órgão, ver {PhonesValidator} sobre o formato
#   esperado.
#   @return [String]
#
# @!attribute [rw] url
#   URL do órgão da prefeitura.
#   @return [String]
#
# @!attribute [rw] ativo
#   Situação do órgão, ativo(true) ou inativo(false).
#   @return [Boolean]
#
# @!attribute [rw] tufibge_id
#   Estado do órgão, chave estrangeira para {Tufibge}.
#   @return [Integer]
#
# @!attribute [rw] tmibge_id
#   Município do órgão, chave estrangeira para {Tmibge}.
#   @return [Integer]
#
# @!attribute [rw] prefeitura_id
#   Prefeitura do órgão, chave estrangeira para {Prefeitura}.
#   @return [Integer]
# 
# @!attribute [rw] tipo_atendimento_ids
#   Tipos de atendimentos associados ao órgão, lista de chaves estrangeiras
#   para {TipoAtendimento}.
#   @return [Array<Integer>]
#
# @!attribute [rw] id
#   Chave primária.
#   @return [Integer]
#
class Orgao < ActiveRecord::Base
  ##############################
  # Associações                #
  ##############################
  belongs_to :tufibge, :foreign_key => "tufibge_id"
  belongs_to :tmibge, :foreign_key => "tmibge_id"
  belongs_to :prefeitura, :foreign_key => "prefeitura_id"
  has_and_belongs_to_many :tipo_atendimentos
  has_many :profissionais
  has_many :escalas
  has_many :agendamentos

  ##############################
  # Atributos                  #
  ##############################
  attr_accessible :prefeitura_id, :tufibge_id, :tmibge_id, :bairro, :cep,
  :complemento_endereco, :email, :endereco, :nome, :numero_endereco,
  :telefone1, :telefone2, :url, :tipo_atendimento_ids, :ativo, :id

  ##############################
  # Callbacks                  #
  ##############################
  before_validation :default_create_values, :on => :create
  before_validation :default_update_values, :on => :update

  ##############################
  # Validações                #
  ##############################
  validates_presence_of :nome, :bairro, :endereco, :numero_endereco,
    :tufibge_id, :tmibge_id, :prefeitura_id
  
  # Ref.: http://www.postgresql.org/docs/8.3/interactive/datatype-numeric.html
  validates_numericality_of :numero_endereco, only_integer: true, greater_than: 0, less_than: 2147483648
  
  validates_inclusion_of :ativo, :in => [true, false]
  validates_with EmailValidator
  validates_with CepValidator
  validates_with PhonesValidator, fields: [:telefone1, :telefone2]
  validates_length_of :bairro, :complemento_endereco, :email,
    :endereco, :nome, :url, maximum: 255

  ##############################
  # Scopes                     #
  ##############################

  # Scope: 
  # Obtêm todos os órgãos associados ao tipo de atendimento fornecido.
  # @param tipo_atendimento_id [Integer] chave primária do tipo de
  #     atendimento.
  # @return [Array<Orgao Object>] retorna ógãos associados ao tipo de
  #     atendimento fornecido.
  # @example Órgãos associados ao "tipo_atendimento.id = 1"
  #    Orgao.tipo_atendimento(1) => [Array<Orgao Object>] 
  scope :tipo_atendimento, lambda { |tipo_atendimento_id| joins(:tipo_atendimentos).where(:tipo_atendimentos => { :id => tipo_atendimento_id.to_i}) unless tipo_atendimento_id.nil? } 

  ##############################
  # Métodos                    #
  ##############################
  protected
    # Atribui valores padrões na criação do órgão, antes da validação.
    # @note O órgão é associado a Prefeitura na criação, se a prefeitura não estiver
    #   cadastrada recebe nil, assim a criação irá falhar na validação, isto
    #   é, um órgão não pode ser criado sem prefeitura.
    def default_create_values
      self.ativo = true
      if prefeitura = Prefeitura.first
        self.prefeitura_id = prefeitura.id 
      else
        self.prefeitura_id = nil
      end
    end
    # Atribui valores padrões na atualização do órgão, antes da validação.
    # @note O órgão é associado a Prefeitura na atualização, se a prefeitura não estiver
    #   cadastrada recebe nil, assim a atualização irá falhar na validação, isto
    #   é, um órgão não pode ser atualizado sem prefeitura.
    def default_update_values
      if prefeitura = Prefeitura.first
        self.prefeitura_id = prefeitura.id
      else
        self.prefeitura_id = nil
      end
    end
end
