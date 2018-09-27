class WeighInsController < ApplicationController
  helper WeighInHelper

  def index
    @weigh_ins = WeighIn.order(when: :desc).page(params[:page]).per(20)
  end

  def upload
    if params[:data].content_type == 'text/csv'

      data = []
      File.open(params[:data].tempfile, 'r') do |f|
        f.each_line do |line|
          originals = Hash[*line.split(',')]
          prettified = {}

          WeighInHelper::DESIRED.each { |keyword| prettified[keyword] = originals[WeighInHelper::KEYWORDS[keyword]] }

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
          ) if prettified['date'] > (WeighIn.maximum(:when) || START_DATE)
        end
      end

      # review this to make a bulk insert (INSERT INTO X VALUES (x,y,z),(p,l,m))
      # if the turns out that one inserts lots of records using this feature
      # typically it should be no more than 10 at the most
      data.each(&:save!)
      flash[:notice] = "#{data.size} records inserted."
    else
      flash[:warning] = "File should be a CSV."
    end
    redirect_to weigh_ins_path
  end
end
