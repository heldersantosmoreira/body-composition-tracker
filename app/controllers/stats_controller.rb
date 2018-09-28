class StatsController < ApplicationController
  def index
    @latest_weigh_in = WeighIn.order(when: :desc).limit(1).first
  end
end
