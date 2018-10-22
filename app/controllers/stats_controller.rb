class StatsController < ApplicationController
  def index
    @starting = WeighIn.order(when: :asc).first
    @latest = WeighIn.order(when: :desc).first

    @lowest_weight = WeighIn.order(weight: :asc).first
    @lowest_fat = WeighIn.order(fat: :asc).first
  end

  def weekly_averages
    @weigh_ins = WeighIn.order(when: :asc).all
    @starting = @weigh_ins.first
    @latest = WeighIn.order(when: :desc).first

    if @starting.present? && @latest.present?
      timeline = @starting.when.to_date.upto(@latest.when.to_date).map do |date|
        [
          date,
          @weigh_ins.find { |weigh_in| weigh_in.when.to_date == date }
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
end
