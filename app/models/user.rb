class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  belongs_to :company, optional: true

  validates :email, private_email: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :create_incomplete_company

  def incomplete_company?
    if company
      company.incomplete?
    end
  end

  def is_owner?(received_company)
    received_company.owner == self
  end

  def is_in_company?(received_company)
    received_company == self.company
  end

  private

  def create_incomplete_company
    if !self.company && self.owner
      self.create_company!
      save
    end
  end
end
