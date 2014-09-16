require 'side_effecter'
class Car
  attr_accessor :make, :model, :trim, :color, :price

  VALID_FUEL_TYPES = {
    focus: {
      blue: :smurf_berries,
      red: :flex
    },
    mustang: {
      blue: :smurf_berries,
      red: :rocket_fuel
    }
  }

  def initialize args={}
    @make  = args[:make]
    @model = args[:model]
    @trim  = args[:trim]
    @color = args[:color]
    @price = args[:price] || 0
  end

  class << self
    def create args={}
      Car.new args
    end
  end

  def available_fuel_type
    VALID_FUEL_TYPES[model.to_sym][color.to_sym]
  end

  def create_side_effect
    SideEffecter.create_side_effect_1 if color == 'blue'
    SideEffecter.create_side_effect_2 if color == 'red'
  end
end
