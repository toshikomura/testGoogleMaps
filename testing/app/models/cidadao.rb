# encoding: UTF-8
# Cidadãos, sistema de autenticação foi implementado usando a gem Devise
# {https://github.com/plataformatec/devise}.
#
# @todo Definir se os atributos do Devise, como por exemplo
#   'reset_password_token', devem ser protegidos(attr_protected).
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
# - {Bloqueio} 
# - {Agendamento}
#
# = Validações
# == presence_of
# - +nome+
# - +rg+
# - +cpf+
# - +password+ -> if {#password_required?}
#
# == confirmation_of
# - +password+ -> if {#password_required?}
#
# == length_of
# - +nome+ -> maximum 255
# - +rg+ -> maximum 11
# - +password+ -> within 6..128, allow_blank true
# 
# == validates_with
# - {EmailValidator}
# - {CpfValidator}
# - {PhonesValidator} -> fields [telefone1]
#
# == uniqueness_of
# - +cpf+ -> allow_blank true, if #cpf_changed?, 
#   ver {http://api.rubyonrails.org/classes/ActiveModel/Dirty.html#method-i-changed-3F ActiveModel#changed?}
#
# @!attribute [rw] nome
#   Nome completo do cidadão.
#   @return [String]
#
# @!attribute [rw] password
#   Senha do cidadão, atributo virtual, usado nos formulários apenas, o
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
#   CPF do cidadão, é usado como identificação na autenticação, deve ser
#   único, ver {CpfValidator} sobre o formato esperado.
#   @return [String]
#
# @!attribute [rw] telefone1
#   Primeiro telefone do cidadão, ver {PhonesValidator} sobre o formato
#   esperado.
#   @return [String]
#
# @!attribute [rw] email
#   E-mail do cidadão, ver {EmailValidator} sobre o formato esperado.
#   @return [String]
#
# @!attribute [rw] rg
#   RG do cidadão, nenhum formato esperado, apenas o tamanho é verificado,
#   estados possuem diferentes formatos de RG.
#   @return [String]
# 
# @!attribute [rw] cartao_sus
#   Cartão SUS do cidadão.
#   @return [String]
#
# @!attribute [rw] id
#   Chave primária.
#   @return [Integer]
#
class Cidadao < ActiveRecord::Base
  ##############################
  # Associações               #
  ##############################
  has_many :bloqueios
  has_many :agendamentos

  ##############################
  # Devise                     #
  ##############################
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  #
  # Modulos padrões removidos:
  # :validatable # Apenas se a identificação do usuário for pelo email.
  # :rememberable # Lembrar nome do usuário no login.
  devise :database_authenticatable, :registerable, 
         :recoverable, :trackable, :authentication_keys => [:cpf]

  ##############################
  # Atributos                  #
  ##############################
  attr_accessible :email, :password, :password_confirmation,
  :current_password, :nome, :cpf, :telefone1, :email, :rg, :cartao_sus, 
  :id

#  attr_protected :encrypted_password, :reset_password_token,
#  :reset_password_sent_at, :sign_in_count, :current_sign_in_at,
#  :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip

  ############################## 
  # Validações Devise          #
  ##############################
  validates_with CpfValidator
  validates_presence_of :cpf
  validates_uniqueness_of :cpf, :allow_blank => true, :if => :cpf_changed?
  validates_presence_of :password, :if => :password_required?
  validates_confirmation_of :password, :if => :password_required?
  validates_length_of :password, :within => 6..128, :allow_blank => true

  ##############################
  # Validações                 #
  ##############################
  validates_presence_of :nome, :rg
  validates_with PhonesValidator, fields: [:telefone1]
  validates_with EmailValidator
  validates_length_of :nome, maximum: 255
  validates_length_of :rg, maximum: 11

  ##############################
  # Métodos                    #
  ##############################
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
    #    validates_confirmation_of :password, :if => :password_required?
    def password_required?
      !persisted? || !password.nil? || !password_confirmation.nil?
    end
end
