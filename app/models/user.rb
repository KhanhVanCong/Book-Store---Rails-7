class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :trackable

  validate :password_complexity
  validates :first_name, presence: { message: ErrorDescriptions::Error_List[:VALUE_CANT_BE_EMPLTY] }
  validates :last_name, presence: { message: ErrorDescriptions::Error_List[:VALUE_CANT_BE_EMPLTY] }

  has_one :cart, dependent: :destroy

  after_create_commit :create_new_cart

  def display_firstname
    first_name.capitalize
  end

  def create_new_cart
    self.create_cart
  end

  private
    def password_complexity
      return if password.blank? || password =~ /(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-])/

      errors.add :password, 'Complexity requirement not met. Please use: 1 uppercase, 1 lowercase, 1 digit and 1 special character'
    end
end

class User::ParameterSanitizer < Devise::ParameterSanitizer
  def initialize(*)
    super
    permit(:sign_up, keys: [:first_name, :last_name, :email])
  end
end
