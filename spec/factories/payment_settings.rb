FactoryBot.define do
  factory :payment_setting do
    pix_key { '' }
    bank_code { '' }
    company_code { '' }
    agency_number { '' }
    account_number { '' }
    # type
    company
    payment_method
  end

  factory :xcredit_card_setting, parent: :payment_setting do
    company_code { 'Yke0hLtqZKPVurU2eAEr' }
  end

  factory :xpix_setting, parent: :payment_setting do
    pix_key { '11.111.111/1111-11' }
    bank_code { '075' }
  end

  factory :xboleto_setting, parent: :payment_setting do
    bank_code { '245' }
    agency_number { '229482394' }
    account_number { '3129039120' }
  end
end
