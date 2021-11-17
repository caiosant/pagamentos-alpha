class CnpjValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    cnpj_regex = %r{^\d{2}\.\d{3}\.\d{3}/\d{4}-\d{2}$}

    record.errors.add(attribute, 'inválido') unless value.match(cnpj_regex)
  end
end
