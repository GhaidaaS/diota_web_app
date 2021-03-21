class Attack < ApplicationRecord
  belongs_to :upload
  enum attack_type: {
    ddos: 1,
    dos: 2,
    theft: 3,
    reconnaissance: 4,
  }
end
