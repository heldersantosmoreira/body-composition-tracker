class WeighIn < ApplicationRecord
  def self.last_7_days
    WeighIn.where("weigh_ins.when >= ?", Date.today - 7).order(when: :desc)
  end
end
