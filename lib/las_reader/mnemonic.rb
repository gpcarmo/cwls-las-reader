class LasReader::Mnemonic
  attr_reader :name, :unit, :value, :description
  def initialize(name,unit,value,info)
    @name = name
    @unit = unit
    @value = value
    @description = info
  end
end
