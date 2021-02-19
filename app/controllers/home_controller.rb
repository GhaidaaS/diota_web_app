class HomeController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  def index
  end

  def scan
  end

  def dashboard
  end
end
