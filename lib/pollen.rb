class Pollen
  attr_reader :id, :name, :sugar_per_mg

  def initialize(id, name, sugar_per_mg)
    @id = id
    @name = name
    @sugar_per_mg = sugar_per_mg
  end
end
