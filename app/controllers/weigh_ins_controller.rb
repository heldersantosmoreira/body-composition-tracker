class WeighInsController < ApplicationController
  def index
    @weigh_ins = WeighIn.all.order(when: :desc)
  end

  def upload

    puts params
    redirect_to weigh_ins_path
  end
end
