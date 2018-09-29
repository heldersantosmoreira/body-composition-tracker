class StatsController < ApplicationController
  def index
    @latest_weigh_in = WeighIn.order(when: :desc).limit(1).first
    @lowest_weight = WeighIn.order(weight: :asc).limit(1).first
    @lowest_fat = WeighIn.order(fat: :asc).limit(1).first
  end
end
