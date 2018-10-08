class StatsController < ApplicationController
  def index
    weigh_ins = WeighIn.order(when: :asc).all

    timeline = (weigh_ins.first.when.to_datetime .. weigh_ins.last.when.to_datetime + 1).map do |date|
      [
        date,
        weigh_ins.find { |weigh_in| weigh_in.when.to_datetime.to_date == date.to_date }
      ]
    end

    @rolling_7day_average = timeline.each_slice(7).map do |slice|
      values = slice.map(&:last).compact
      {
        weight_average: values.inject(0) { |sum, el| sum + el.weight }.to_f / values.size,
        fat_average: values.inject(0) { |sum, el| sum + el.fat }.to_f / values.size,
        date_range: [slice.last.first, slice.first.first],
        size: values.size
      }
    end.reverse
  end
end
