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
    # @attack_seq = @attacks.select(:sequence_id)
    # @attack_type = @attack_seq.select(:attack_type)
    @attacks_per_date = []

  end
end
