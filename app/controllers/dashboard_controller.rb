class DashboardController < ApplicationController


  def index
    @uploads = current_user.uploads
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
    @attacks = Attack.joins(upload: :user).where('users.id = ?', current_user.id)
    attacks_per_type = @attacks.group_by { |a| a.attack_type }
    @ddos = attacks_per_type['ddos'].group_by{ |a| a.started_at.strftime("%Y-%m-%d") }.map { |k, v| { x: k, y: v.count } }
    @dos = attacks_per_type['dos'].group_by{ |a| a.started_at.strftime("%Y-%m-%d") }.map { |k, v| { x: k, y: v.count } }
    @theft = attacks_per_type['theft'].group_by{ |a| a.started_at.strftime("%Y-%m-%d") }.map { |k, v| { x: k, y: v.count } }
    @reconnaissance = attacks_per_type['reconnaissance'].group_by{ |a| a.started_at.strftime("%Y-%m-%d") }.map { |k, v| { x: k, y: v.count } }
    render json: { ddos: @ddos, dos: @dos, theft: @theft, reconnaissance: @reconnaissance }, status: :ok
  end
end
