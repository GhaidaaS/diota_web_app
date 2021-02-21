class Upload < ApplicationRecord
  belongs_to :user
  enum status: [:processing, :failed, :processed]
end
