class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  belongs_to :company, optional: true

  validates :email, private_email: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :check_if_create_company

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
  def check_if_user_is_an_owner
    email_domain_query_element = "%@#{email.split('@')[-1]}"
    same_email_domain_users = User.where(
      'email LIKE :email_domain AND ID != :id', 
      email_domain: email_domain_query_element, 
      id: self.id
    )
    
    if !owner && !self.company
      self.owner = same_email_domain_users.empty?
      self.company = same_email_domain_users.last.company if !self.owner
    end
    save
  end

  def check_if_create_company
    check_if_user_is_an_owner

    return unless !company && owner

    create_company!
    save
  end
end
