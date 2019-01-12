Progress = Struct.new(:goal, :start, :current) do
  def progress
    if start.present? && current.present?
      ((1 - (current - goal) / (start - goal)) * 100).to_i
    end
  end
end

class DashboardController < ApplicationController
  def index
    first_weight = WeighIn.order(when: :asc).pluck(:weight).first
    @last_7_days = WeighIn.last_7_days.order(when: :desc).pluck(:weight)
    @weight_ema = @last_7_days.size >= StatsHelper::MINIMUM_DAYS_REQUIRED ? @last_7_days.ema : nil

    @progresses =
      StatsHelper::WEIGHT_GOALS.each_with_index.map do |weight_goal, i|
        Progress.new(weight_goal, first_weight, @weight_ema)
      end
  end
end
