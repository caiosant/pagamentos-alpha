class CnpjValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    cnpj_regex = /^\d{2}\.\d{3}\.\d{3}\/\d{4}\-\d{2}$/
    
    unless value.match(cnpj_regex)
      record.errors.add(attribute, 'inválido')
    end
  end
end