# encoding: UTF-8
# Validador de CEP, verifica se o CEP está no formato correto, não permite
# valor nulo(nil), ver referência
# {http://guides.rubyonrails.org/v3.2.13/active_record_validations_callbacks.html#performing-custom-validations
# Rails Guide Custom Validations}.
class CepValidator < ActiveModel::Validator
  # Formato esperado do atributo +cep+, 99999-999.
  CEP_REGEX = /^[0-9]{5}-[0-9]{3}$/

  # Valida o atributo +cep+ com a expressão regular {CEP_REGEX},
  # mostra uma mensagem de erro quando não corresponde a expressão, não
  # permite valor nulo(nil).
  #
  # @param record [Object] record o objeto para a validação
  #
  # @note Se o atributo +cep+ for inválido adiciona na
  #     variável +errors+ uma mensagem de erro e falha a validação.
  #
  # @example Verificar CEP:
  #     validates_with CepValidator
  def validate(record)
    if record.cep.present? and not record.cep.blank?
      unless record.cep =~ CEP_REGEX
        record.errors[:cep] << "inválido. O formato deve ser 99999-999."
      end
    end
  end
end
