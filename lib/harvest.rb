class Harvest
  attr_reader :bee_id, :day, :pollen_id, :milligrams_harvested

  def initialize(bee_id, day, pollen_id, milligrams_harvested)
    @bee_id	= bee_id
    @day = day
    @pollen_id = pollen_id
    @milligrams_harvested = milligrams_harvested
  end
end
