class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  belongs_to :company, optional: true

  validates :email, private_email: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :create_incomplete_company

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

  def create_incomplete_company
    return unless !company && owner

    create_company!
    save
  end
end
