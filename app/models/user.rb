class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  belongs_to :company, optional: true

  validates :email, private_email: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  before_validation :check_ownership_and_company_unless_already_set
  after_validation :create_company!, if: :user_is_owner_without_company?

  def incomplete_company?
    company&.incomplete?
  end

  def owns?(received_company)
    received_company.owner == self
  end

  def in_company?(received_company)
    received_company == company
  end

  private

  def query_same_email_domain_users
    email_domain_query_element = "%@#{email.split('@')[-1]}"

    User.where(
      'email LIKE :email_domain',
      email_domain: email_domain_query_element
    ).where.not(company: nil)
  end

  def check_ownership_and_company_unless_already_set
    return if owner || company

    same_email_domain_users = query_same_email_domain_users

    self.owner = same_email_domain_users.empty?
    return if owner

    user_company = same_email_domain_users.first.company

    if user_company&.accepted?
      self.company = user_company
    else
      errors.add :base, 'Sua empresa ainda não foi aceita no nosso sistema'
    end
  end

  def user_is_owner_without_company?
    !company && owner
  end
end
