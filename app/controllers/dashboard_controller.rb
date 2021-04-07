class DashboardController < ApplicationController
  before_action :authenticate_user!
  def index
    @uploads = current_user.uploads
    @uploads = @uploads.where(id: params[:upload_id]) if params[:upload_id]
    # Get statistics data
    @statistics = Statistic.where(upload_id: @uploads.ids)
    @total_traffic = @statistics.sum(&:total_records)
    @total_attacks = @statistics.sum(&:total_attacks)
    @total_normal_traffic = @total_traffic - @total_attacks
    @total_ddos = @statistics.sum(&:total_ddos)
    @total_dos = @statistics.sum(&:total_dos)
    @total_theft = @statistics.sum(&:total_theft)
    @total_reconnaissance = @statistics.sum(&:total_reconnaissance)

    # Get attacks data
    @attacks = Attack.where(upload_id: @uploads.ids)
    @latest_attacks = @attacks.limit(10).order(started_at: :desc)
  end

  def attacks_per_day
    # NOT IMPORTANT:
    # NOTE: every group_by & map is actually looping through the attacks
    # we can enhancee the performance here by looping through the attacks for ONE time, and add the data to a hash map
    # so it would bee something like:
    # results = { 'ddos' => [], 'dos' => [], 'theft' => [], 'reconnaissance' => [] }
    # @attacks.each |att| do
    #   sdate = att.started_at.strftime("%Y-%m-%d")
    #   arr = results[att.attack_type]
      # day_attacks = arr.find { |d| d[:x] == sdate }
      # if day_attacks
      #   day_attacks[:y] += 1
      # else
      #   arr.push({x: sdate, y: 1})
      # end
    # end
    start_date = params['start_date']&.to_datetime
    end_date = params['end_date']&.to_datetime

    # Main query
    @attacks = Attack.joins(upload: :user).order(:started_at).where('users.id = ?', current_user.id)
    @attacks = @attacks.where(started_at: start_date..end_date) if start_date && end_date
    @attacks = @attacks.where(upload_id: params[:upload_id]) if params[:upload_id]

    attacks_per_type = @attacks.group_by { |a| a.attack_type }
    @ddos = attacks_per_type['ddos']&.group_by{ |a| a.started_at.strftime("%Y-%m-%d") }&.map { |k, v| { x: k, y: v.count } }
    @dos = attacks_per_type['dos']&.group_by{ |a| a.started_at.strftime("%Y-%m-%d") }&.map { |k, v| { x: k, y: v.count } }
    @theft = attacks_per_type['theft']&.group_by{ |a| a.started_at.strftime("%Y-%m-%d") }&.map { |k, v| { x: k, y: v.count } }
    @reconnaissance = attacks_per_type['reconnaissance']&.group_by{ |a| a.started_at.strftime("%Y-%m-%d") }&.map { |k, v| { x: k, y: v.count } }
    render json: { ddos: @ddos, dos: @dos, theft: @theft, reconnaissance: @reconnaissance }, status: :ok
  end
end
