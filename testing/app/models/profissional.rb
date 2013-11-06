# encoding: UTF-8
# Profissionais, sistema de autenticação foi implementado usando a gem Devise
# {https://github.com/plataformatec/devise}.
# Profissionais possuem níveis de permissões, implementada com a gem CanCan
# {https://github.com/ryanb/cancan}, ver {ProfissionalAbility}.
# Nenhum registro é excluído do banco de dados, apenas recebe uma indicação
# que está inativo, atributo "ativo" igual a "false".
#
# @todo Definir se os atributos do Devise, como por exemplo
#   'reset_password_token', devem ser protegidos(attr_protected).
#
# @todo Definir a associação has_many escalas, como profissional
#   responsável.
#
# @todo
#   Remover a associação desnecessária com a tabela de estados (Tufibge).
#
# = Opções Devise
# - +database_authenticatable+
# - +registerable+
# - +recoverable+
# - +trackable+.
# - +authentication_keys+ -> cpf
#
# - Modulos padrões removidos  :
#   - validatable - Usado apenas se a identificação do usuário for pelo atributo 'email'.
#   - rememberable - Lembrar nome do usuário no login.
#
# = Associações
# == has_many
# - {Escala} -> foreign_key +profissional_executor_id+ 
#
# == belongs_to
# - {Tmibge}
# - {Tufibge}
# - {Tcbo}
# - {Tconselho}
# - {Orgao}
#
# = Validações
# == presence_of
# - +nome+
# - +rg+
# - +cpf+
# - +data_nascimento+
# - +emissao_rg+
# - +tcbo_id+
# - +orgao_id+
# - +role+
# - +password+ -> if {#password_required?}
#
# == inclusion_of
# - +ativo+ -> in [true,false]
# - +role+ -> in {ROLES}
#
# == confirmation_of
# - +password+ -> if {#password_required?}
#
# == length_of
# - +password+ -> within 6..128, allow_blank true
# 
# == validates_with
# - {EmailValidator}
# - {CpfValidator}
# - {PhonesValidator} -> fields [telefone1, telefone2]
#
# == uniqueness_of
# - +cpf+ -> allow_blank true, if #cpf_changed?, ver {http://api.rubyonrails.org/classes/ActiveModel/Dirty.html#method-i-changed-3F ActiveModel#changed?}
#
# = Callbacks
# == before_create
# - {#default_values}
#
# @!attribute [rw] nome
#   Nome completo do profissional.
#   @return [String]
#
# @!attribute [rw] password
#   Senha do profissional, atributo virtual, usado nos formulários apenas, o
#   valor salvo no banco de dados é a senha criptografada, +crypted_password+.
#   @return [String]
#
# @!attribute [rw] password_confirmation
#   Confirmação da senha, atributo virutal, usado nos formulários apenas.
#   @return [String]
#
# @attribute [rw] current_password
#   Senha atual, atributo virtual, usado nos formulários apenas.
#   @return [String]
#
# @!attribute [rw] cpf
#   CPF do profissional, é usado como identificação na autenticação, deve ser
#   único, ver {CpfValidator} sobre o formato esperado.
#   @return [String]
#
# @!attribute [rw] telefone1
#   Primeiro telefone do profissional, ver {PhonesValidator} sobre o formato
#   esperado.
#   @return [String]
#
# @!attribute [rw] telefone2
#   Segundo telefone do profissional, ver {PhonesValidator} sobre o formato
#   esperado.
#   @return [String]
#
# @!attribute [rw] email
#   E-mail do profissional, ver {EmailValidator} sobre o formato esperado.
#   @return [String]
#
# @!attribute [rw] rg
#   RG do profissional, nenhum formato esperado, apenas o tamanho é verificado,
#   estados possuem diferentes formatos de RG.
#   @return [String]
#
# @!attribute [rw] emissao_rg
#   Órgão emissor do RG.
#   @return [String]
# 
# @!attribute [rw] bairro
#   Bairro do endereço do profissional.
#   @return [String]
#
# @!attribute [rw] cep
#   CEP do endereço do profissional, ver {CepValidator} sobre o
#   formato esperado.
#   @return [String]
#
# @!attribute [rw] complemento_endereco
#   Complemento do endereço do profissional.
#   @return [String]
#
# @!attribute [rw] numero_endereco
#   Número do endereço do profissional.
#   @return [Integer]
#
# @!attribute [rw] tufibge_id
#   Estado do endereço do profissional, chave estrangeira para {Tufibge}.
#   @return [Integer]
#
# @!attribute [rw] tmibge_id
#   Município do endereço do profissional, chave estrangeira para {Tmibge}.
#   @return [Integer]
#
# @!attribute [rw] data_nascimento
#   Data de nascimento do profissional, usado como senha padrão na criação
#   de um registro.
#   @return [String]
#
# @!attribute [rw] role
#   Nível de permissão do profissional no sistema, ver
#   {ProfissionalAbility}.
#   @return [String]
#
# @!attribute [rw] ativo
#   Situação do profissional, ativo(true) ou inativo(false).
#   @return [Boolean]
#
# @!attribute [rw] matricula
#   Matrícula do profissional na prefeitura.
#   @return [String]
#
# @!attribute [rw] id
#   Chave primária.
#   @return [Integer]
#
class Profissional < ActiveRecord::Base
  ##############################
  # Associações                #
  ##############################
  belongs_to :tmibge
  belongs_to :tufibge
  belongs_to :tcbo
  belongs_to :tconselho
  belongs_to :orgao
  has_many :escalas, :foreign_key => "profissional_executor_id"

  ##############################
  # CanCan                     #
  ##############################

  # Níveis de permissões dos profissionais, ver {ProfissionalAbility}.
  ROLES = %w[tecnico atendente administrador administradorsistema]
  # Verifica se profissional possui a permissão fornecida.
  # @param base_role [String] a permissão a verificar se o profissional
  #   possui.
  # @return [true, false] retorna 'true' se o profissional possui a
  #   permissão +base_role+ ou 'false' caso contrário.
  def role?(base_role)
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

  ##############################
  # Devise                     #
  ##############################
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  #
  # Modulos padrões removidos:
  # :validatable # Apenas se a identificação do usuário for pelo email
  # :rememberable
  devise :database_authenticatable, :registerable, 
         :recoverable, :trackable, :authentication_keys => [:cpf]

  ##############################
  # Atributos                  #
  ##############################
  attr_accessible :email, :password, :password_confirmation, :current_password,
  :bairro, :cep, :complemento_endereco, :cpf, :data_nascimento, :emissao_rg,
  :nome, :endereco, :numero_endereco, :rg, :tcbo_id, :tconselho_id, :orgao_id,
  :tmibge_id, :tufibge_id, :telefone1, :telefone2, :role, :matricula, :ativo

#  attr_protected :encrypted_password, :reset_password_token,
#  :reset_password_sent_at, :sign_in_count, :current_sign_in_at,
#  :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip

  ##############################
  # Validações Devise          #
  ##############################
  validates_with CpfValidator
  validates_presence_of :cpf
  validates_uniqueness_of :cpf, :allow_blank => true, :if => :cpf_changed?
  validates_presence_of :password, :if => :password_required?, :on => :update
  validates_confirmation_of :password, :if => :password_required?, :on => :update
  validates_length_of :password, :within => 6..128, :allow_blank => true

  ##############################
  # Validações                 #
  ##############################
  validates_inclusion_of :ativo, :in => [true,false]
  validates_inclusion_of :role, :in => ROLES
  validates_presence_of :nome, :data_nascimento, :rg, :emissao_rg, :tcbo_id,
  :orgao_id, :role
  validates_with PhonesValidator, fields: [:telefone1, :telefone2]
  validates_with EmailValidator

  ##############################
  # Callbacks                  #
  ############################## 
  before_create :default_values

  ##############################
  # Métodos                    #
  ##############################

  # Verifica se o profissional possui permissão de administrador do sistema.
  # @return [true, false] retorna 'true' se o profissional possui permissão
  #     de administrador do sistema, ou retorna 'false' caso contrário.
  # @note usa a função {#role?}
  def administradorsistema?
      self.role? :administradorsistema
  end

  # Verifica se o profissional possui permissão de administrador(órgão da
  # prefeitura).
  # @return [true, false] retorna 'true' se o profissional possui permissão
  #     de administrador, ou retorna 'false' caso contrário.
  # @note Um profissional administrador do sistema também é
  #     administrador(órgão da prefeitura), usa as funções
  #     {#administradorsistema?} e {#role?}
  def administrador?
      self.role? :administrador || administradorsistema?
  end

  # Verifica se o profissional possui permissão de atendente.
  # @return [true, false] retorna 'true' se o profissional possui permissão
  #     de atendente, ou retorna 'false' caso contrário.
  # @note Um profissional administrador(órgão da prefeitura) ou
  #     administrador do sistema também é atendente, usa as funções
  #     {#administrador?} e {#role?}
  def atendente?
      self.role? :atendente || administrador?
  end
  protected
    # Verifica se o atributo virtual +password+ é necessário na validação,
    # por exemplo na validação da atualização do registro o campo é
    # opcional(mudança de senha).
    #
    # @return [true, false] retorna 'true' se o +password+ é necessário ou
    #   'false' caso contrário; a senha é necessária se: +password+ foi
    #   fornecido, ou +password_confirmation+ foi fornecido, ou o
    #   registro é mantido(não é um novo registro ou não será destruido),
    #   ver
    #   {http://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-persisted-3F
    #   ActiveRecord#persisted?}
    #
    # @example Verificar a confirmação da senha apenas se necessário.
    #   validates_confirmation_of :password, :if => :password_required? 
    def password_required?
      !persisted? || !password.nil? || !password_confirmation.nil?
    end

    # Atribui valores padrões na criação do profissional.
    # @note A senha padrão do profissional é sua data de nascimento no
    #   formato DDMMAAAA.
    def default_values
      self.password = self.password_confirmation ||= self.data_nascimento.strftime("%d%m%Y")
      self.ativo = true 
    end
end
