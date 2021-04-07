class UploadsController < ApplicationController
  before_action :authenticate_user!

  # Index page for uploads (scan page)
  def index
    @upload = Upload.new
    @uploads = Upload.where(user: current_user).limit(10).order(created_at: :desc)
  end

  # Uploads CSV to the deep learning model
  def create
    ActiveRecord::Base.transaction do
      # read the file from the params
      uploaded_io = params[:upload][:csv_file]

      # Create upload record in the DB
      upload = Upload.create!(user: current_user, status: :processing)

      # Use CSV library to extract the data from the uploaded file
      require 'CSV'
      # headers = CSV.read(uploaded_io)
      data = []
      CSV.foreach(uploaded_io.path, encoding: "UTF-8-BOM", headers: true, header_converters: lambda { |name| Constants.csv_column_names_lookup[name] }).with_index do |row, i|
        validate_csv_headers(row.headers) if i.zero?
        data << row.to_hash # hash
      end

      # Call the Flask API to get the prediction results
      DataUploader.call(data, upload)
    rescue => error
      flash[:alert] = error.message
      raise ActiveRecord::Rollback
    end

    redirect_to uploads_path
  end

  private

  def validate_csv_headers(file_headers)
    missed_headers = []
    required_headers = Constants.required_csv_headers
    required_headers.each do |header|
      missed_headers.push(header) unless file_headers.include?(header)
    end
    return if missed_headers.empty?
    raise "Missing columns: #{missed_headers.join(', ')}"
  end
end
