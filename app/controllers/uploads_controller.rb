class UploadsController < ApplicationController
  before_action :authenticate_user!

  def index
    @upload = Upload.new
    @uploads = Upload.limit(10).order(created_at: :desc)
  end

  def create
    # read file
    uploaded_io = params[:upload][:csv_file]
    # TODO: Validate that CSV file has correct columns & has at least 1 row
    # Create upload record
    upload = Upload.create!(user: current_user, status: :processing)

    # TODO: insert all data in temo_upload table
    # POST JSON content
    require 'CSV'
    data = []
    CSV.foreach(uploaded_io.path, encoding: "UTF-8-BOM", headers: true, header_converters: lambda { |name| Constants.csv_column_names_lookup[name] }) do |row|
      data << row.to_hash # hash
    end
    resp = Faraday.post("http://localhost:5000/predict", { data: data }.to_json, "Content-Type" => "application/json")

    # UploadWorker.perform_async(upload.id)
    # DataUploader.run(upload, file)

    redirect_to uploads_path
  end
end
