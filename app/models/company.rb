class Company < ApplicationRecord
    has_many :users

    enum status: { incomplete: 0, pending: 10, accepted: 20, rejected: 30 }

    has_one :owner, -> { where owner: true },
    class_name: 'User'

    after_update :check_if_still_incomplete

    # APENAS ON UPDATE 
    validates :cnpj, :legal_name, :billing_address, :billing_email,
    presence: true, on: :update
    validates :billing_email, private_email: true, on: :update
    validates :cnpj, cnpj: true, on: :update

    private
    def any_essential_info_blank?
        [cnpj, legal_name, billing_address, billing_email].each do |info|
            return true if info.blank?
        end
        false
    end

    def check_if_still_incomplete
        if !any_essential_info_blank? && incomplete?
            pending!
        end
    end
end
