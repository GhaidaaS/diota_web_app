class AttacksController < ApplicationController
  before_action :authenticate_user!
  def index
    @uploads = current_user.uploads
    @attacks = Attack.where(upload_id: @uploads.ids)
  end
end
