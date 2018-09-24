class WeighInsController < ApplicationController
  include WeighInHelper
  include ApplicationHelper

  def index
    @weigh_ins = WeighIn.all.order(when: :desc)
  end

  def upload
    if params[:data].content_type == 'text/csv'

      data = []
      File.open(params[:data].tempfile, 'r') do |f|
        f.each_line do |line|
          originals = Hash[*line.split(',')]
          prettified = {}

          DESIRED.each { |keyword| prettified[keyword] = originals[KEYWORDS[keyword]] }

          # strip date and time field of quotes and escape characters
          prettified['date'] = Date.strptime(prettified['date'].gsub(/\A"|"\Z/, ''), "%d/%m/%Y")
          prettified['time'] = prettified['time'].gsub(/\A"|"\Z/, '')

          puts prettified

          data << WeighIn.new(
            when: DateTime.parse("#{prettified['date']} #{prettified['time']}"),
            weight: prettified['weight'].to_f,
            fat: prettified['fat'].to_f,
            muscle: prettified['muscle'].to_f,
            visceral_fat: prettified['visceral'].to_i,
            metabolic_age: prettified['meta_age'].to_i,
            water: prettified['water'].to_f,
          ) if prettified['date'] > WeighIn.maximum(:when)
        end
      end

      data.each(&:save!)
      flash[:notice] = "#{data.size} records inserted."
    else
      flash[:warning] = "File should be a CSV."
    end
    redirect_to weigh_ins_path
  end
end
