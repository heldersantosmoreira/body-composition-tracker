RollingAverage = Struct.new(:weight_average, :fat_average, :date_range, :size)

class StatsController < ApplicationController
  def index
    @lowest_weight = WeighIn.order(weight: :asc).first
    @lowest_fat = WeighIn.order(fat: :asc).first

    @highest_weight = WeighIn.order(weight: :desc).first
    @highest_fat = WeighIn.order(fat: :desc).first
  end

  def weekly_averages
    @weigh_ins = WeighIn.order(when: :asc).all
    @starting = @weigh_ins.first
    @latest = WeighIn.order(when: :desc).first

    if @starting.present? && @latest.present?
      timeline = @starting.when.to_date.upto(@latest.when.to_date).map do |date|
        [
          date,
          @weigh_ins.find { |weigh_in| weigh_in.when.to_date == date },
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
    @last_7_days = WeighIn.last_7_days.order(when: :asc).pluck(:weight)
    @weight_lr = @last_7_days.size >= StatsHelper::MINIMUM_DAYS_REQUIRED ? LinearRegression.new(@last_7_days) : nil
  end
end
