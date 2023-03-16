class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :rememberable, :validatable, :timeoutable, :trackable

  extend Enumerize
  enumerize :role, in: Constants::ADMIN_ROLES, predicates: true, scope: true
  enumerize :status, in: Constants::ADMIN_STATUS, predicates: { prefix: true }

  validates :name, presence: true

  after_destroy :at_least_one_super_admin?
  after_save :at_least_one_super_admin?, if: -> { self.saved_change_to_role? }

  def is_not_current_admin?(current_admin)
    self != current_admin
  end

  private

    def at_least_one_super_admin?
      raise CustomExceptions::AtLeastOneSuperAdmin if Admin.with_role(:super_admin).count == 0
    end
end
