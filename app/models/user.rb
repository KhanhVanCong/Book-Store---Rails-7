class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :trackable

  validate :password_complexity
  validates :first_name, presence: true
  validates :last_name, presence: true

  def display_firstname
    first_name.capitalize
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
