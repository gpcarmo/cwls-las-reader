class LasReader::WellInfo

  @@attrs =  %w{start_depth depth_unit stop_depth step null_value company_name well_name field_name location province county state country service_company date_logged uwi api }.map! { |s| s.to_sym }.freeze

  attr_accessor *@@attrs

end
