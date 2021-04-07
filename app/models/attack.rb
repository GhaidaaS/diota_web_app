class Attack < ApplicationRecord
  belongs_to :upload

  scope :by_attack_type, -> attack_type { where(attack_type: attack_type) }
  scope :by_source_port, -> source_port { where(source_port: source_port) }
  scope :by_destination_port, -> destination_port{ where(destination_port: destination_port) }
  scope :by_source_ip, -> source_ip{ where(source_ip: source_ip) }

  enum attack_type: {
    ddos: 1,
    dos: 2,
    theft: 3,
    reconnaissance: 4,
  }
end
