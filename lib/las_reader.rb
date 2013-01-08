require "las_reader/version"
require "las_reader/curve_info"
require "las_reader/curve"
require "las_reader/mnemonic"
require "las_reader/well_info"

module LasReader

  attr_reader :version
  attr_reader :wrap
  attr_reader :curves
  attr_reader :parameters
  attr_reader :well_info

  def set_version(info)
    version = info.match(/(VERS\.).+([1-3]\.[0-9]).*:\s*(.*)/)
    if version.nil?
      wrap_mode = info.match(/(WRAP\.).+(YES|NO).*:\s*(.*)/)
      if not wrap_mode.nil?
          @wrap =  (wrap_mode[2] == "YES") ? true : false
      end
    else
      @version = version[2]
      raise "LAS version not supported" if @version.to_f > 2.0
    end
  end

  def set_curve_info(info)
    mnemonic = info.match(/(\w+)\s*\.(\S*)\s+(.*):\s*(.*)/)
    unless mnemonic.nil?
      @curves["#{mnemonic[1]}"] = Curve.new(mnemonic[1],mnemonic[2],mnemonic[3],mnemonic[4])
      @acurves << mnemonic[1]
    end
  end

  def set_parameters(info)
    mnemonic = info.match(/(\w+)\s*\.(\S+)\s+(.*):\s*(.*)/)
    unless mnemonic.nil?
      @parameters["#{mnemonic[1]}"] = Mnemonic.new(mnemonic[1],mnemonic[2],mnemonic[3],mnemonic[4])
    end
  end

  def set_well_info(info)

    strt = info.match(/(STRT)\s*\.(\w).+\s([0-9]+\.[0-9]+).*:\s*(.*)/)
    unless strt.nil?
      @well_info.start_depth = strt[3].to_f
      @well_info.depth_unit = strt[2]
      return
    end

    stop = info.match(/(STOP)\s*\.(\w).+\s([0-9]+\.[0-9]+).*:\s*(.*)/)
    unless stop.nil?
      @well_info.stop_depth = stop[3].to_f
      return
    end

    step = info.match(/(STEP)\s*\.(\w).+\s(-?[0-9]+\.[0-9]+).*:\s*(.*)/)
    unless step.nil?
      @well_info.step = step[3].to_f
      return
    end

    null = info.match(/(NULL)\s*\..+\s(-?[0-9]+\.[0-9]+).*:\s*(.*)/)
    unless null.nil?
      @well_info.null_value = null[2].to_f
      return
    end

    comp = info.match(/(COMP\s*\..+COMPANY:\s*(.*))|(COMP\s*\.\s*(.*)\s+:COMPANY)/)
    unless comp.nil?
      @well_info.company_name = (comp[2] or comp[4]).strip
      return
    end

    well = info.match(/(WELL\s*\..+WELL:\s*(.*))|(WELL\s*\.\s*(.*)\s+:WELL)/)
    unless well.nil?
      @well_info.well_name = (well[2] or well[4]).strip
      return
    end

    fld = info.match(/(FLD\s*\..+FIELD:\s*(.*))|(FLD\s*\.\s*(.*)\s+:FIELD)/)
    unless fld.nil?
      @well_info.field_name = (fld[2] or fld[4]).strip
      return
    end

    loc = info.match(/(LOC\s*\..+LOCATION:\s*(.*))|(LOC\s*\.\s*(.*)\s+:LOCATION)/)
    unless loc.nil?
      @well_info.location = (loc[2] or loc[4]).strip
      return
    end

    prov = info.match(/(PROV\s*\..+PROVINCE:\s*(.*))|(PROV\s*\.\s*(.*)\s+:PROVINCE)/)
    unless prov.nil?
      @well_info.province = (prov[2] or prov[4]).strip
      return
    end

    cnty = info.match(/(CNTY\s*\..+COUNTY:\s*(.*))|(CNTY\s*\.\s*(.*)\s+:COUNTY)/)
    unless cnty.nil?
      @well_info.county = (cnty[2] or cnty[4]).strip
      return
    end

    stat = info.match(/(STAT\s*\..+STATE:\s*(.*))|(STAT\s*\.\s*(.*)\s+:STATE)/)
    unless stat.nil?
      @well_info.state = (stat[2] or stat[4]).strip
      return
    end

    ctry  = info.match(/(CTRY\s*\..+COUNTRY:\s*(.*))|(CTRY\s*\.\s*(.*)\s+:COUNTRY)/)
    unless ctry.nil?
      @well_info.country = (ctry[2] or ctry[4]).strip
      return
    end

    srvc = info.match(/(SRVC\s*\..+SERVICE COMPANY:\s*(.*))|(SRVC\s*\.\s*(.*)\s+:SERVICE COMPANY)/)
    unless srvc.nil?
      @well_info.service_company = (srvc[2] or srvc[4]).strip
      return
    end

    data = info.match(/(DATE\s*\..+LOG DATE:\s*(.*))|(DATE\s*\.\s*(.*)\s+:LOG DATE)/)
    unless data.nil?
      @well_info.date_logged = (data[2] or data[4]).strip
      return
    end

    uwi = info.match(/(UWI\s*\..+UNIQUE WELL ID:\s*(.*))|(UWI\s*\.\s*(.*)\s+:UNIQUE WELL ID)/)
    unless uwi.nil?
      @well_info.uwi = (uwi[2] or uwi[4]).strip
      return
    end

  end

  def set_other_info(info)
  end

  def log_wrap_data(info,temp_array)
    d=info.scan(/[-]?[0-9]+.[0-9]+/)
    a = temp_array + d if not d.nil?
    if a.size == self.curves.size
      self.curves.each do |k,v|
        value = a[@acurves.index(k)].to_f
        v.log_data << ((value == @well_info.null_value) ? nil : value)
      end
      a = []
    end
    return a
  end

  def log_nowrap_data(info)
    d=info.scan(/[-]?[0-9]+.[0-9]+/)
    unless d.nil?
      self.curves.each do |k,v|
        value = d[@acurves.index(k)].to_f
        v.log_data << ((value == @well_info.null_value) ? nil : value)
      end
    end
  end

  def load_file(file_name)

    temp_array = []
    @curves = {}
    @parameters = {}
    @acurves = []

    read_state = 0

    unless File.exist?(file_name)
      raise "No such file or directory"
    end

    File.open(file_name).each do |line|
      # ignore comments
      next if line[0].chr == '#' 
      # The '~' is used to inform the beginning of a section
      if line[0].chr == '~' 
          case line[1].chr
            when 'V' # Version information section
              read_state = 1 
            when 'W' # Well identification section
              @well_info = WellInfo.new
              read_state = 2 
            when 'C' # Curve information section
              read_state = 3
            when 'P' # Parameters information section
              #set_log_pattern(curves.size)
              read_state = 4 
            when 'O' # Other information section
              read_state = 5 
            when 'A' # ASCII Log data section
              read_state = 6 
          else
            raise "unsupported file format for #{line}"
            read_state = 0 # Unknow file format
          end
      else
        case read_state
          when 1
            set_version(line.lstrip)
          when 2
            set_well_info(line.lstrip) 
          when 3
            set_curve_info(line.lstrip)
          when 4
            set_parameters(line.lstrip)
          when 5
            set_other_info(line) 
          when 6
            if self.wrap
              temp_array = log_wrap_data(line,temp_array)
            else
              log_nowrap_data(line)
            end 
        end
      end
    end
  end

end

class CWLSLas

  include LasReader

  def initialize(filename=nil)
    load_file(filename) if not filename.nil?
  end

  def curve_names
    self.curves.keys
  end

  def curve(curve_name)
    self.curves[curve_name]
  end

  def well_name
    self.well_info.well_name
  end

  def company_name
    self.well_info.company_name
  end

  def field_name
    self.well_info.field_name
  end

  def location
    self.well_info.location
  end
 
  def province
    self.well_info.province
  end

  def service_company
    self.well_info.service_company
  end

  def log_date
    self.well_info.date_logged
  end

  def uwi
    self.well_info.uwi
  end

end
