# encoding: UTF-8
# Escalas dos profissionais, os agendamentos são criados automaticamente quando uma
# escala é criada/alterada, o número de agendamentos criados é o
# número de atendimentos indicado na escala, uma escala não é excluída
# apenas recebe um indicativo de que foi removida/fechada, atributo
# +tipo_acao_id+(chave estrangeira para TipoAcao).
#
# @todo Alterar o nome da associação dos profissionais, para o profissional
#   executor(+profissional_executor_id+) nomear +profissional_executor+ e para
#   o profissional responsável(+profissional_responsavel_id+) nomear
#   +profissional_responsavel+.
#
# = Associações
# == belongs_to
# - {TipoAtendimento}   
# - {TipoAcao}
# - {Orgao}
# - profissional -> {Profissional} foreign_key +profissional_executor_id+
# - profissional_2 -> {Profissional} foreign_key +profissional_responsavel_id+
#
# == has_many
# - {Agendamento}
#
# = Validações
# == presence_of
# - +tipo_atendimento_id+
# - +orgao_id+
# - +tipo_acao_id+
# - +data_execucao+
# - +horario_fim_execucao+
# - +horario_inicio_execucao+
# - +numero_sequencia+
# - +profissional_responsavel_id+
#
# == length_of 
# - +observacoes+ -> maximum 500
#
# == numericality_of
# - +numero_sequencia+ -> only_integer true, greater_than 0, less_than 2147483648,
#   ver referência {http://www.postgresql.org/docs/9.1/static/datatype-numeric.html}
# - +numero_atendimentos+ -> only_integer true, greater_than_or_equal_to 0, less_than 2147483648
#
# == Outras validações
# - {#data_execucao_valid_date}
# - {#horario_inicio_e_fim_execucao_valid_time}
#
# = Callbacks
# == before_save
# - {#verify_exist_scale}
#
# @!attribute [rw] horario_inicio_execucao
#   Horário de inicio da execução da escala.
#   @return [Datetime]
#
# @!attribute [rw] horario_fim_execucao
#   Horário de fim da execução da escala.
#   @return [Datetime]
#
# @!attribute [rw] observacoes
#   Observações do profissional responsável sobre a escala.
#   @return [Text]
#
# @!attribute [rw] numero_sequencia
#   Número de sequência da escala, para identificar alterações, valor padrão
#   na criação 1.
#   @return [Integer]
#
# @!attribute [rw] numero_atendimentos
#   Número de atendimentos para agendamento, indica quantos
#   registros de agendamentos serão criados.
#   @return [Integer]
#
# @!attribute [rw] tipo_acao_id
#   Ação da escala, chave estrangeira para {TipoAcao}.
#   @return [Integer]
#
# @!attribute [rw] tipo_atendimento_id
#   Tipo de atendimento da escala, chave estrangeira para {TipoAtendimento}.
#   @return [Integer]
#
# @!attribute [rw] orgao_id
#   Local de atendimento(Órgão) onde será executada a escala, chave
#   estrangeira para {Orgao}.
#   @note o valor padrão na criação é o órgão ao qual o
#       profissional responsável está associado. 
#   @return [Integer]
#
# @!attribute [rw] profissional_executor_id
#   Profissional que irá executar a escala, chave estrangeira para
#   {Profissional}.
#   @return [Integer]
#
# @!attribute [rw] profissional_responsavel_id
#   Profissional responsável que criou ou alterou a escala, chave
#   estrangeira para {Profissional}.
#   @return [Integer]
#
# @!attribute [rw] id
#   Chave primária.
#   @return [Integer]
#
class Escala < ActiveRecord::Base
  ##############################
  # Associações                #
  ##############################
  has_many :agendamentos
  belongs_to :tipo_atendimento
  belongs_to :orgao
  belongs_to :tipo_acao
  belongs_to :profissional, :foreign_key => :profissional_responsavel_id,
                            :class_name => "Profissional"
  belongs_to :profissional_2, :foreign_key => :profissional_executor_id, 
                              :class_name => "Profissional"

  ##############################
  # Atributos                  #
  ##############################
  attr_accessible :tipo_atendimento_id, :orgao_id,
  :tipo_acao_id, :data_execucao, :horario_fim_execucao,
  :horario_inicio_execucao, :numero_sequencia, :observacoes, 
  :numero_atendimentos, :profissional_executor_id,
  :profissional_responsavel_id

  ##############################
  # Callbacks                  #
  ##############################
  before_save :verify_exist_scale

  ##############################
  # Validações                 #
  ##############################
  validates_presence_of :tipo_atendimento_id, :orgao_id, :tipo_acao_id,
  :data_execucao, :horario_fim_execucao, :horario_inicio_execucao,
  :numero_sequencia, :profissional_responsavel_id
  validates_length_of :observacoes, maximum: 500

  # Ref.: http://www.postgresql.org/docs/9.1/static/datatype-numeric.html
  validates_numericality_of :numero_sequencia, only_integer: true,
  greater_than: 0, less_than: 2147483648
  validates_numericality_of :numero_atendimentos, only_integer: true,
  greater_than_or_equal_to: 0, less_than: 2147483648

  validate :data_execucao_valid_date, :horario_inicio_e_fim_execucao_valid_time

  ##############################
  # Métodos                    #
  ##############################
  
  # Verifica se a data de execução da escala(+data_execucao+) é
  # uma data válida.
  # @note Se a data de execução for inválida adiciona na
  #     variável +errors+ uma mensagem de erro e falha a validação.  
  def data_execucao_valid_date
    if data_execucao.present?
      unless data_execucao.is_a?(Date)
        errors.add(:data_execucao, "não é uma data válida.")
      end
    end
  end

  # Verifica se o hoário de inicio e fim da escala
  # (+horario_inicio_execucao+ e +horario_fim_execucao) são
  # válidos.
  # @note Se um dos horários for inválido adiciona na
  #     variável +errors+ uma mensagem de erro e falha a validação.   
  def horario_inicio_e_fim_execucao_valid_time
    if horario_inicio_execucao.present? and horario_fim_execucao.present?
      if not (horario_inicio_execucao.is_a?(Time) or horario_inicio_execucao.is_a?(DateTime))
        errors.add(:horario_inicio_execucao, "não é data/horário válido.")
      elsif not (horario_fim_execucao.is_a?(Time) or horario_fim_execucao.is_a?(DateTime))
        errors.add(:horario_fim_execucao, "não é data/horário válido.")
      end
    end
  end

  private
    # Varifica se há uma escala para o mesmo profissional na mesma data,
    # isto é, verifica se há conflito de escalas.
    # @return [true,false] retorna +true+ se há uma escala em conflito ou
    #   'false' caso contrário.
    # @note Caso exista um conflito de escalas a criação irá falhar.
    def verify_exist_scale
      @scale = Escala.where("(profissional_executor_id = ? AND data_execucao = ? AND (horario_inicio_execucao >= ? AND horario_inicio_execucao < ?)) OR (profissional_executor_id = ? AND data_execucao = ? AND (horario_inicio_execucao <= ? AND horario_fim_execucao > ? AND horario_fim_execucao <= ?))", self.profissional_executor_id, self.data_execucao, self.horario_inicio_execucao, self.horario_fim_execucao, self.profissional_executor_id, self.data_execucao, self.horario_inicio_execucao, self.horario_inicio_execucao, self.horario_fim_execucao)    
      if @scale.size > 0 
        return false
      else
        return true
      end
  end                                 
end
