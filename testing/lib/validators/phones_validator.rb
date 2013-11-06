# encoding: UTF-8
# Validador de telefones, verifica se os telefones está no formato correto, permite
# valor nulo(nil), ver referência
# {http://guides.rubyonrails.org/v3.2.13/active_record_validations_callbacks.html#performing-custom-validations
# Rails Guide Custom Validations}.
class PhonesValidator < ActiveModel::Validator
  # Formato esperado do atributo, (99)9999-9999 ou vazio("").
  PHONE_REGEX = /^(\([0-9]{2}\)[0-9]{4}\-[0-9]{4})?$/

  # Valida os atributos com a expressão regular {PHONE_REGEX},
  # mostra uma mensagem de erro quando um dos atributos não corresponde a
  # expressão, permite valor nulo(nil) e vazio("").
  #
  # @param record [Object] record o objeto para a validação
  #
  # @note Se um dos atributos for inválido adiciona na
  #     variável +errors+ uma mensagem de erro e falha a validação.
  #
  # @note A opção +fields+ deve ser uma lista, caso contrário a interação
  #     +.each+ irá falhar!
  #
  # @example Verificar os telefones +telefone1+ e +telefone2+:
  #     validates_with PhonesValidator, fields: [:telefone1, :telefone2]
  def validate(record)
    unless options[:fields].blank?
      error = "inválido formato deve ser (99)9999-9999"
      options[:fields].each do |field|
        # Allow nil
        if (record.send(field) != nil)
          unless PHONE_REGEX.match(record.send(field))
            record.errors[field] << error 
          end
        end
      end
    end
  end
end
