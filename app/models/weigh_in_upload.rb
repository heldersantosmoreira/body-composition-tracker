require 'csv'

class WeighInUpload
  include ActiveModel::Model

  attr_reader :file, :records

  def initialize(file)
    @file = file
  end

  def save
    # review this to make a bulk insert (INSERT INTO X VALUES (x,y,z),(p,l,m))
    # if the turns out that one inserts lots of records using this feature
    # typically it should be no more than 10 at the most
    @records ||= load_records
    @records.each(&:save!)
    @records.size
  rescue
    false
  end

  private

  def load_records
    start_date = WeighIn.maximum(:when) || WeighInHelper::START_DATE
    CSV.read(file.path).map do |row|
      originals = Hash[*row]
      prettified = {}

      WeighInHelper::DESIRED.each { |keyword| prettified[keyword] = originals[WeighInHelper::KEYWORDS[keyword]] }

      # strip date and time field of quotes and escape characters
      prettified['date'] = Date.strptime(prettified['date'].gsub(/\A"|"\Z/, ''), "%d/%m/%Y")
      prettified['time'] = prettified['time'].gsub(/\A"|"\Z/, '')

      WeighIn.new(
        when: DateTime.parse("#{prettified['date']} #{prettified['time']}"),
        weight: prettified['weight'].to_f,
        fat: prettified['fat'].to_f,
        muscle: prettified['muscle'].to_f,
        visceral_fat: prettified['visceral'].to_i,
        metabolic_age: prettified['meta_age'].to_i,
        water: prettified['water'].to_f,
      ) if prettified['date'] > start_date
    end.compact
  end
end
