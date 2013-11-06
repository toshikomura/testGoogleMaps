# encoding: UTF-8
# Cidadãos bloqueados, quando um cidadão é bloqueado por não comparecimento
# cria um registro na tabela.
#
# = Associações
# == belongs_to
# - {Cidadao}   
#
# = Validações
# == presence_of
# - +data_entrada+
# - +data_expira+
# - +cidadao_id+
#
# == Outras validações
# - {#data_entrada_nao_pode_ser_maior_que_data_expira}
# - {#data_expira_is_valid_date}
#
# @!attribute [rw] data_entrada
#   Data em que o cidadão foi bloqueado.
#   @return [Date]
#
# @!attribute [rw] data_expira
#   Data em que o bloqueio expira.
#   @return [Date]
#
# @!attribute [rw] cidadao_id
#   Cidadão, chave estrangeira para {Cidadao}.
#   @return [Integer]
#
# @!attribute [rw] id
#   Chave primária.
#   @return [Integer]
#
class Bloqueio < ActiveRecord::Base
  ##############################
  # Associações                #
  ##############################
  belongs_to :cidadao

  ##############################
  # Atributos                 #
  ##############################
  attr_accessible :data_entrada, :data_expira, :cidadao_id

  ##############################
  # Validações                 #
  ##############################
  validates_presence_of :data_entrada, :data_expira, :cidadao_id
  validate :data_entrada_nao_pode_ser_maior_que_data_expira,
    :data_expira_is_valid_date

  ##############################
  # Scopes                     #
  ##############################

  # Scope: 
  # Obtêm os bloqueios de um cidadão.
  # @param cidadao_id [Integer] chave primária do cidadão.
  # @return [Array<Bloqueio Object>] retorna os bloqueios associados ao cidadão
  #     fornecido, em ordem decrescente de +data_expira+.
  # @example Bloqueios associados ao "cidadao.id = 1"
  #    Bloqueio.situacao(1) => [Array<Bloqueio Object>] 
  scope :situacao, lambda { |cidadao| where("cidadao_id = ?", cidadao.id).order("data_expira DESC") unless cidadao.nil? }

  ##############################
  # Métodos                    #
  ##############################

  # Verifica se a data de entrada(+data_entrada+) é maior que a data em que
  # expira(+data_expira+).
  # @note Se a data de entrada for maior que data expira adiciona na
  #     variável +errors+ uma mensagem de erro e falha a validação.
  def data_entrada_nao_pode_ser_maior_que_data_expira
    if data_entrada.present? && data_expira.present? && (data_entrada > data_expira)
      errors.add(:data_entrada, "não pode ser maior que a data de expiração do bloqueio.")
    end
  end

  # Verifica se a data em que expira(+data_expira+) é uma data válida.
  # @note Se a data em que expira for inválida adiciona na
  #     variável +errors+ uma mensagem de erro e falha a validação.
  def data_expira_is_valid_date
    if data_expira.present?
      unless data_expira.is_a?(Date)
        errors.add(:data_expira, "não é uma data válida.")
      end
    end
  end
end
