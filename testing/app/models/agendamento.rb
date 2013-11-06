# encoding: UTF-8
# Agendamentos, os agendamentos são criados automaticamente quando uma
# escala é criada/alterada, o número de agendamentos criados é o
# número de atendimentos indicado na escala.
#
# = Associações
# == belongs_to
# - {Cidadao}   
# - {TipoSituacao}
# - {Escala}
# - {Orgao}
#
# = Validações
# == presence_of
# - +tipo_situacao_id+
# - +escala_id+
# - +orgao_id+
# - +horario_fim_consulta+
# - +horario_inicio_consulta+
# - +cidadao_id+ -> on update
#
# == Outras validações
# - {#horarios_de_inicio_e_fim_consulta_datetime}
# - {#horario_inicio_consulta_menor_que_horario_fim_consulta}
#
# = Callbacks
# == before_save
# - {#set_schedule_date}
#
# @!attribute [rw] horario_inicio_consulta
#   Horário de inicio da consulta.
#   @return [Datetime]
#
# @!attribute [rw] horario_fim_consulta
#   Horário de fim da consulta.
#   @return [Datetime]
#
# @!attribute [rw] observacao
#   Uma observação do cidadão sobre o agendamento.
#   @return [Text]
#
# @!attribute [rw] tipo_situacao_id
#   Situação do agendamento, chave estrangeira para {TipoSituacao}.
#   @return [Integer]
#
# @!attribute [rw] escala_id
#   Escala do agendamento, chave estrangeira para {Escala}.
#   @return [Integer]
#
# @!attribute [rw] cidadao_id
#   Cidadão agendado, chave estrangeira para {Cidadao}.
#   @return [Integer]
#
# @!attribute [rw] id
#   Chave primária.
#   @return [Integer]
#
class Agendamento < ActiveRecord::Base
  ##############################
  # Associações                #
  ##############################
  belongs_to :tipo_situacao
  belongs_to :escala
  belongs_to :cidadao
  belongs_to :orgao

  ##############################
  # Atributos                  #
  ##############################
  attr_accessible :tipo_situacao_id, :escala_id, :cidadao_id, :orgao_id,
  :horario_fim_consulta, :horario_inicio_consulta, :observacao

  ##############################
  # Validações                 #
  ##############################
  validates_presence_of :tipo_situacao_id, :escala_id, :orgao_id,
  :horario_fim_consulta, :horario_inicio_consulta
  validate :horarios_de_inicio_e_fim_consulta_datetime
  validate :horario_inicio_consulta_menor_que_horario_fim_consulta

  ##############################
  # Callbacks                  #
  ##############################
  before_save :set_schedule_date

  ##############################
  # Scopes                     #
  ##############################

  # Scope: 
  # Obtêm os agendamentos disponíveis.
  # @return [Array<Agendamento Object>] retorna os agendamentos
  #     disponíveis, com tipo de situação "Vago".
  scope :vagos, lambda { where("tipo_situacao_id = ?", TipoSituacao.find_by_descricao("Vago").id) }

  # Scope: 
  # Obtêm os agendamentos agendados.
  # @return [Array<Agendamento Object>] retorna os agendamentos
  #     disponíveis, com tipo de situação "Agendado".
  scope :agendados, lambda { where("tipo_situacao_id = ?", TipoSituacao.find_by_descricao("Agendado").id) }

  # Scope: 
  # Obtêm os agendamentos em que o cidadãos não compareceram.
  # @return [Array<Agendamento Object>] retorna os agendamentos
  #     em que o cidadãos não compareceram, com tipo de situação "Não
  #     Compareceu".
  scope :faltas, lambda { where("tipo_situacao_id = ?", TipoSituacao.find_by_descricao("Não Compareceu").id) }

  # Scope: 
  # Obtêm os agendamentos de um cidadão.
  # @param cidadao [Cidadao Object] cidadão.
  # @return [Array<Agendamento Object>] retorna os agendamentos
  #     do cidadão, em ordem crescente de +horario_inicio_consulta+. 
  # @example Agendamentos associados ao "cidadao.id = 1"
  #    Agendamento.situacao(cidadao) => [Array<Agendamento Object>] 
  scope :historico, lambda { |cidadao| where("cidadao_id = ?", cidadao.id).order("tipo_situacao_id DESC, horario_inicio_consulta ASC") unless cidadao.nil? }

  # Scope: 
  # Obtêm os agendamentos agendados de um cidadão.
  # @param cidadao [Cidadao Object] cidadão.
  # @return [Array<Agendamento Object>] retorna os agendamentos agendados
  #     do cidadão. 
  # @example Agendamentos agendados associados ao "cidadao.id = 1"
  #    Agendamento.cidadao_agendados(cidadao) => [Array<Agendamento Object>]
  # @note Usa o scope {#agendados}.
  scope :cidadao_agendados, lambda { |cidadao| where("cidadao_id = ?", cidadao.id).agendados unless cidadao.nil? }

  # Scope: 
  # Obtêm os agendamentos faltos de um cidadão.
  # @param cidadao [Cidadao Object] cidadão.
  # @return [Array<Agendamento Object>] retorna os agendamentos faltos
  #     do cidadão. 
  # @example Agendamentos faltos associados ao "cidadao.id = 1"
  #    Agendamento.cidadao_faltas(cidadao) => [Array<Agendamento Object>]
  # @note Usa o scope {#faltas}. 
  scope :cidadao_faltas, lambda { |cidadao| where("cidadao_id = ?", cidadao.id).faltas unless cidadao.nil? }

  # Scope: 
  # Obtêm os agendamentos de um órgão.
  # @param orgao [Orgao Object] órgão.
  # @return [Array<Agendamento Object>] retorna os agendamentos do órgão.
  # @example Agendamentos associados ao "orgao.id = 1"
  #    Agendamento.orgao(orgao) => [Array<Agendamento Object>]
  scope :orgao, lambda { |orgao| joins(escala: :orgao).where(:orgaos => { :id => orgao.id }) unless orgao.nil? }

  # Scope: 
  # Obtêm os agendamentos num dado periodo de dias.
  # @param periodo [Integer] periodo.
  # @return [Array<Agendamento Object>] retorna os agendamentos de um
  #     nos últimos +periodo+ dias.
  # @example Agendamentos no "periodo = 30", isto é, agendamentos dos últimos 30 dias.
  #     Agendamento.periodo(30) => [Array<Agendamento Object>]
  scope :periodo, lambda { |periodo| joins(:escala).where("data_execucao >= ?", periodo.days.ago) unless (periodo <= 0)}

  # Scope: 
  # Obtêm os agendamentos num intervalo de horário.
  # @param inicio [Datetime] horário de inicio
  # @param fim [Datetime] horário de fim 
  # @return [Array<Agendamento Object>] retorna os agendamentos no
  #     intervalo.
  scope :intervalo, lambda { |inicio, fim| where("horario_inicio_consulta >= ?", inicio).where("horario_fim_consulta <= ?", fim) unless (inicio.nil? or fim.nil?) }

  ##############################
  # Métodos                    #
  ##############################
    
  # Formata o horário de inicio da consulta, para visualização.
  # @return [String] retorna a data +horario_inicio_consulta+ formatada.
  def data_agendamento
    I18n.l(self.horario_inicio_consulta, :format => ("%A %d/%m/%Y %H:%M:%S"))
  end

  # Verifica se o horário de inicio da consulta(+horario_inicio_consulta+) e
  # horário de fim da consulta(+horario_fim_consulta+) são datas válidas.
  # @note Se uma das datas for inválida adiciona na variável +errors+ uma
  #     mensagem de erro e falha a validação.
  def horarios_de_inicio_e_fim_consulta_datetime
    if horario_inicio_consulta.present? and horario_fim_consulta.present?
      if not (horario_inicio_consulta.is_a?(Time) or horario_inicio_consulta.is_a?(DateTime))
        errors.add(:horario_inicio_consulta, "não é uma data/horário válido")
      elsif not (horario_fim_consulta.is_a?(Time) or horario_fim_consulta.is_a?(DateTime))
        errors.add(:horario_fim_consulta, "não é uma data/horário válido")
      end
    end
  end

  # Verifica se o horário de inicio da consulta(+horario_inicio_consulta+) é
  # maior que o horário de fim da consulta(+horario_fim_consulta+).
  # @note Se o horário de inicio for maior que o horário de fim adiciona na
  #     variável +errors+ uma mensagem de erro e falha a validação. 
  def horario_inicio_consulta_menor_que_horario_fim_consulta
    if horario_inicio_consulta.present? and horario_fim_consulta.present?
      if horario_inicio_consulta > horario_fim_consulta
        errors.add(:horario_inicio_consulta, "inválido")
      end
    end
  end

  def horarios_de_inicio_e_fim_consulta_datetime
    if horario_inicio_consulta.present?
      unless (horario_inicio_consulta.is_a?(Time) or horario_inicio_consulta.is_a?(DateTime))
        errors.add(:horario_inicio_consulta, "não é uma data/horário válido")
      end
    end
   
    if horario_fim_consulta.present?
      unless (horario_fim_consulta.is_a?(Time) or horario_fim_consulta.is_a?(DateTime))
        errors.add(:horario_fim_consulta, "não é uma data/horário válido")
      end
    end
  end

  def horario_inicio_consulta_menor_que_horario_fim_consulta
    if horario_inicio_consulta.present? and horario_fim_consulta.present?
      if horario_inicio_consulta > horario_fim_consulta
        errors.add(:horario_inicio_consulta, "inválido")
      end
    end
  end

  # Verifica se um agendamento pode ser cancelado, isto é, o horário de
  # início(+horario_inicio_consulta+) é maior que um horário fornecido, a
  # situação do agendamento é "Vago" e a data(+escala.data_execucao+) é
  # maior que uma data fornecida.
  #
  # @param horario [DateTime] horario Horário de início para a verificação
  # @param data [Date] data Dia para a verificação
  #
  # @return [true,false] retorna +true+ se o agendamento pode ser cancelado,
  #     ou +false+ caso contrário
  #
  # @note Caso o +tipo_situacao+ seja nulo ou vazio retorna +false+ e caso
  #     a +escala+ seja nula ou vazia retorna +false+.
  def pode_cancelar?(horario, data)
    if self.tipo_situacao.nil?
      return false
    elsif self.escala.nil?
      return false
    else
      return (self.tipo_situacao.descricao.to_s == "Agendado" &&
              self.horario_inicio_consulta >= horario &&
              self.escala.data_execucao >= data)
    end
  end

  # Verifica se um agendamento pode ser atendido no dia, isto é, a situação
  # do agendamento é "Vago" e a data(+escala.data_execucao+) é igual a uma
  # data fornecida.
  #
  # @param data [Date] data Dia para a verificação
  #
  # @return [true,false] retorna +true+ se o agendamento pode ser atendido,
  #     ou +false+ caso contrário
  #
  # @note Caso o +tipo_situacao+ seja nulo ou vazio retorna +false+ e caso
  #     a +escala+ seja nula ou vazia retorna +false+.
  def pode_atender?(data)
    if self.tipo_situacao.nil?
      return false
    elsif self.escala.nil?
      return false
    else
      return (self.tipo_situacao.descricao.to_s == "Agendado" &&
              self.horario_inicio_consulta >= data.beginning_of_day &&
              self.horario_fim_consulta <= data.end_of_day &&
              self.escala.data_execucao = data)
    end
  end

  private
    # Atribui valores padrões na criação do agendamento.
    # @note Seta as datas do agendamento em relação as datas da escala
    #   associada.
    def set_schedule_date
      if self.escala_id.present?
        @escala = Escala.where(:id => self.escala_id).first
        if @escala != nil
          @data_execucao = @escala.data_execucao
          self.horario_inicio_consulta = Time.local(@data_execucao.year, @data_execucao.month, @data_execucao.day, self.horario_inicio_consulta.hour, self.horario_inicio_consulta.min)
          self.horario_fim_consulta = Time.local(@data_execucao.year, @data_execucao.month, @data_execucao.day, self.horario_fim_consulta.hour, self.horario_fim_consulta.min)
        end
      end
    end
end
