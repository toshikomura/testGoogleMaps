# encoding: UTF-8
# Validador de e-mail, verifica se o e-mail está no formato correto, permite
# valor nulo(nil), ver referência
# {http://guides.rubyonrails.org/v3.2.13/active_record_validations_callbacks.html#performing-custom-validations
# Rails Guide Custom Validations}.
class EmailValidator < ActiveModel::Validator
  # Formato esperado do atributo +email+, *@\*.\*
  EMAIL_REGEX = /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/

  # Valida o atributo +email+ com a expressão regular {EMAIL_REGEX},
  # mostra uma mensagem de erro quando não corresponde a expressão,
  # permite valor nulo(nil).
  #
  # @param record [Object] record o objeto para a validação
  #
  # @note Se o atributo +email+ for inválido adiciona na
  #     variável +errors+ uma mensagem de erro e falha a validação.
  #
  # @example Verificar E-mail:
  #     validates_with EmailValidator
  def validate(record)
    # Allow nil
    if record.email.present? and not record.email.blank?
      unless EMAIL_REGEX.match(record.email)
        record.errors[:email] << "inválido formato deve ser <usuario>@<provedor>"
      end
    end
  end
end 

