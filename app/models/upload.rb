class Upload < ApplicationRecord
  belongs_to :user
  has_many :attacks
  has_one :statistic
  enum status: [:processing, :failed, :processed]
end
