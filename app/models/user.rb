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

  private

  def create_incomplete_company
    # TODO: ADICIONAR O ATRIBUTO SELF.OWNER NESSA CONDICIONAL QUANDO ELE EXISTIR
    # "cria uma empresa se for dono, se nao for, nao faz nada"
    if !self.company && self.owner
      self.company = Company.create!()
      save
    end
  end
end
