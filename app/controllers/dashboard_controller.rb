class DashboardController < ApplicationController
  def index
    latest = WeighIn.order(when: :desc).first
    first = WeighIn.order(when: :asc).first

    distance = first.weight - StatsHelper::WEIGHT_GOAL
    current_distance = latest.weight - StatsHelper::WEIGHT_GOAL

    @progress = latest.present? ? (current_distance * 100 / distance).to_i  : nil
  end
end
