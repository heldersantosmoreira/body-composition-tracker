class DashboardController < ApplicationController
  def index
    latest = WeighIn.order(when: :desc).first
    first = WeighIn.order(when: :asc).first

    if latest.present? && first.present?
      @progresses = StatsHelper::WEIGHT_GOALS.each_with_index.map do |weight, i|
        {
          goal: weight,
          progress: ((1 - (latest.weight - weight) / (first.weight - weight)) * 100).to_i
        }
      end
    end
  end
end
