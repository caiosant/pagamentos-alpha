class AdminEmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value =~ /^[A-Za-z0-9+_.-]+@pagapaga.com.br/

    record.errors.add attribute, (options[:message] || 'Este e-mail não é válido')
  end
end
