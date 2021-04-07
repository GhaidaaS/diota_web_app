class Upload < ApplicationRecord
  belongs_to :user
  has_many :attacks, dependent: :destroy
  has_one :statistic, dependent: :destroy
  enum status: [:processing, :failed, :processed]
end
