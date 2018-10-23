class DashboardController < ApplicationController
  def index
    @weight_ema = WeighIn.last(15).pluck(:weight).ema
    first_weight = WeighIn.order(when: :asc).pluck(:weight).first

    if @weight_ema.present? && first_weight.present?
      @progresses = StatsHelper::WEIGHT_GOALS.each_with_index.map do |weight_goal, i|
        {
          goal: weight_goal,
          progress: ((1 - (@weight_ema - weight_goal) / (first_weight - weight_goal)) * 100).to_i
        }
      end
    end
  end
end
