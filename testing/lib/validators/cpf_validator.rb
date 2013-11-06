# encoding: UTF-8
# Validador de CPF, verifica se o CPF está no formato correto e se é de
# fato válido, não permite valor nulo(nil), ver referência
# {http://guides.rubyonrails.org/v3.2.13/active_record_validations_callbacks.html#performing-custom-validations
# Rails Guide Custom Validations}.
class CpfValidator < ActiveModel::Validator
  # Formato esperado do atributo +cpf+, 999.999.999-99.
  CPF_REGEX = /^[0-9]{3}\.[0-9]{3}\.[0-9]{3}\-[0-9]{2}$/

  # Valida o atributo +cpf+ com a expressão regular {CPF_REGEX} e
  # com a fórmula do CPF, mostra uma mensagem de erro quando não
  # corresponde a expressão ou não é válido pelo cálculo, não permite valor
  # nulo(nil).
  #
  # @param record [Object] record o objeto para a validação
  #
  # @note Se o atributo +cpf+ for inválido adiciona na
  #     variável +errors+ uma mensagem de erro e falha a validação.
  #
  # @example Verificar CPF:
  #     validates_with CpfValidator
  def validate(record)
    if (record.cpf != nil) && CPF_REGEX.match(record.cpf)
      cpfcompleto = record.cpf.gsub(/[^0-9]/,'')
      # Calcula primeiro dígito verificador (dv1)
      cpf = cpfcompleto[0..8]
      valores = [10,9,8,7,6,5,4,3,2]
      total = 0
      (0..8).each do |i|
        total += cpf[i].to_i * valores[i]
      end
      resto = total % 11
      if resto < 2
        dv1 = 0
      else
        dv1 = 11 - resto
      end
      # Calcula segundo dígito verificador (dv2)
      valores = [11,10,9,8,7,6,5,4,3,2]
      cpf = cpf + dv1.to_s
      total = 0
      (0..9).each do |i|
        total += cpf[i].to_i * valores[i]
      end
      resto = total % 11
      if resto < 2
        dv2 = 0
      else
        dv2 = 11 - resto
      end
      # Verfica os dígitos no cpf
      if (dv1 != cpfcompleto[9].to_i) ||
         (dv2 != cpfcompleto[10].to_i) ||
         (cpfcompleto.to_s == "99999999999") ||
         (cpfcompleto.to_s == "88888888888") ||
         (cpfcompleto.to_s == "77777777777") ||
         (cpfcompleto.to_s == "66666666666") ||
         (cpfcompleto.to_s == "55555555555") ||
         (cpfcompleto.to_s == "44444444444") ||
         (cpfcompleto.to_s == "33333333333") ||
         (cpfcompleto.to_s == "22222222222") ||
         (cpfcompleto.to_s == "11111111111") ||
         (cpfcompleto.to_s == "00000000000")
        record.errors[:cpf] << "inválido" # CPF inválido
      end
    else
      # CPF não está na formatação correta
      record.errors[:cpf] << "inválido formato deve ser 999.999.999-99"
    end
  end
end
