class LasReader::Curve
  attr_reader :name, :unit, :api, :description
  attr_accessor :log_data
  def initialize(name,unit,api,info)
    @name = name
    @unit = unit
    @api = api
    @description = info
    @log_data = []
  end
  def add(*p)
    p.each do |point|
      if point.respond_to?(:each) 
        @log_data += point 
      else
        @log_data << point 
      end
    end
  end
end

