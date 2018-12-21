RollingAverage = Struct.new(:weight_average, :fat_average, :date_range, :size)

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
        RollingAverage.new(
          values.inject(0) { |sum, el| sum + el.weight }.to_f / values.size,
          values.inject(0) { |sum, el| sum + el.fat }.to_f / values.size,
          [slice.last.first, slice.first.first],
          values.size
        )
      end.reverse
    end
  end

  def predictions
    weights = WeighIn.last_7_days.pluck(:weight)
    @weight_lr = LinearRegression.new(weights)
  end
end
