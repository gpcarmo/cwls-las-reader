class LasReader::CurveInfo
  attr_reader :name, :unit, :api, :description
  def initialize(name,unit,api,info)
    @name = name
    @unit = unit
    @api = api
    @description = info
  end
end
