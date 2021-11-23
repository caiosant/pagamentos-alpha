class PrivateEmailValidator < ActiveModel::EachValidator
  def initialize(options)
    super
    @public_domains = File.read('app/validators/support/public_email_domains.txt').split
  end

  def validate_each(record, attribute, value)
    email_domain = value.split('@')[-1]

    record.errors.add(attribute, 'não pode ser um email de domínio público') if @public_domains.include? email_domain
  end
end
