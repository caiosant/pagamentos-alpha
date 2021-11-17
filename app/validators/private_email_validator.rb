class PrivateEmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    public_domains = File.read('app/validators/public_email_domains.txt').split

    email_domain = value.split('@')[-1]

    record.errors.add(attribute, 'não pode ser um email de domínio público') if public_domains.include? email_domain
  end
end
