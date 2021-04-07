class User < ApplicationRecord
  has_many :uploads, dependent: :destroy
  scope :by_id, -> id { where(id: id) }
  scope :by_name, -> name { where('first_name ilike ? OR last_name ilike ?', "%#{name}%", "%#{name}%") }
  scope :by_role, -> role { role == 'true' ? where(admin: true) : where(admin: false).or(where(admin: nil))  }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
end
