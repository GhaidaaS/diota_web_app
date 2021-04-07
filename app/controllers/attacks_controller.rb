class AttacksController < ApplicationController
  before_action :authenticate_user!

  # Scopes
  has_scope :by_attack_type
  has_scope :by_source_port
  has_scope :by_destination_port
  has_scope :by_source_ip
  has_scope :by_destination_ip

  def index
    @uploads = current_user.uploads
    # @attacks = Attack.where(upload_id: @uploads.ids)
    @attacks = apply_scopes(Attack).where(upload_id: @uploads.ids)
  end
end
