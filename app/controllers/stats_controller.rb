class StatsController < ApplicationController
  helper StatsHelper

  def index
    @latest_weigh_in = WeighIn.order(when: :desc).limit(1).first
  end
end
