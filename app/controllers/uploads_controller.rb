class UploadsController < ApplicationController
  before_action :authenticate_user!

  def index
    @upload = Upload.new
    @uploads = Upload.all
  end

  def create
    # TODO:
    # read file
    uploaded_io = params[:upload][:csv_file]
    file = CSV.read(uploaded_io.path)
    # Create upload record
    upload = Upload.new(user: current_user, status: :processing)
    if upload.save
      # Services::DataUploader.run(upload, file)
    else
      # display error
    end

    redirect_to uploads_path
  end
end
