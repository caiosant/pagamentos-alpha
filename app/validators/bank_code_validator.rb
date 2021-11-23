require 'csv'

class BankCodeValidator < ActiveModel::EachValidator
  def initialize(options)
    super
    @bank_codes = CSV.read('app/validators/support/bank_codes.csv', headers: true, quote_char: "\x00",
                                                                    col_sep: ';').by_col[0].compact!
  end

  def validate_each(record, attribute, value)
    record.errors.add(attribute, 'inválido') unless @bank_codes.include? value
  end
end
