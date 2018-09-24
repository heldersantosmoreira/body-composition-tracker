module WeighInHelper
  START_DATE = Date.new(2018, 8, 28)

  KEYWORDS = {
    'date' => 'DT',
    'time' => 'Ti',
    'gender' => 'GE',
    'age' => 'AG',
    'height' => 'Hm',
    'activity' => 'AL',
    'weight' => 'Wk',
    'bmi' => 'MI',
    'fat' => 'FW',
    'fat_rarm' => 'Fr',
    'fat_larm' => 'Fl',
    'fat_rleg' => 'FR',
    'fat_lleg' => 'FL',
    'fat_trunk' => 'FT',
    'muscle' => 'mW',
    'muscle_rarm' => 'mr',
    'muscle_larm' => 'ml',
    'muscle_rleg' => 'mR',
    'muscle_lleg' => 'mL',
    'muscle_trunk' => 'mT',
    'bones' => 'bw',
    'visceral' => 'IF',
    'meta_age' => 'rA',
    'water' => 'ww',
  }

  DESIRED = %w(date time weight fat muscle visceral meta_age water)
end
