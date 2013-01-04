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

  def set_version(info)
    version = info.match(/(VERS\.).+([1-3]\.[0-9]).*:\s*(.*)/)
    if version.nil?
      wrap_mode = info.match(/(WRAP\.).+(YES|NO).*:\s*(.*)/)
      if not wrap_mode.nil?
          @wrap =  (wrap_mode[2] == "YES") ? true : false
      end
    else
      @version = version[2]
    end
  end

  def set_curve_info(info)
    mnemonic = info.match(/(\w+)\s*\.(\S*)\s+(.*):\s*(.*)/)
    unless mnemonic.nil?
      @curves["#{mnemonic[1]}"] = Curve.new(mnemonic[1],mnemonic[2],mnemonic[3],mnemonic[4])
    end
  end

  def set_parameters(info)
    mnemonic = info.match(/(\w+)\s*\.(\S+)\s+(.*):\s*(.*)/)
    unless mnemonic.nil?
      @parameters["#{mnemonic[1]}"] = Mnemonic.new(mnemonic[1],mnemonic[2],mnemonic[3],mnemonic[4])
    end
  end

  def set_well_info(info)

    strt = info.match(/(STRT)\.(\w).+\s([0-9]+\.[0-9]+).*:\s*(.*)/)
    unless strt.nil?
      @well_info.start_depth = strt[3].to_f
      @well_info.depth_unit = strt[2]
      return
    end

    stop = info.match(/(STOP)\.(\w).+\s([0-9]+\.[0-9]+).*:\s*(.*)/)
    unless stop.nil?
      @well_info.stop_depth = stop[3].to_f
      return
    end

    step = info.match(/(STEP)\.(\w).+\s(-?[0-9]+\.[0-9]+).*:\s*(.*)/)
    unless step.nil?
      @well_info.step = step[3].to_f
      return
    end

    null = info.match(/(NULL)\..+\s(-?[0-9]+\.[0-9]+).*:\s*(.*)/)
    unless null.nil?
      @well_info.null_value = null[2].to_f
      return
    end

    comp = info.match(/COMP\..+COMPANY:\s*(.*)/)
    unless comp.nil?
      @well_info.company_name = comp[1]
      return
    end

    well = info.match(/WELL\..+WELL:\s*(.*)/)
    unless well.nil?
      @well_info.well_name = well[1]
      return
    end

    fld = info.match(/FLD \..+FIELD:\s*(.*)/)
    unless fld.nil?
      @well_info.field_name = fld[1]
      return
    end

    loc = info.match(/LOC \..+LOCATION:\s*(.*)/)
    unless loc.nil?
      @well_info.location = loc[1]
      return
    end

    prov = info.match(/PROV\..+PROVINCE:\s*(.*)/)
    unless prov.nil?
      @well_info.province = prov[1]
      return
    end

    cnty = info.match(/CNTY\..+COUNTY:\s*(.*)/)
    unless cnty.nil?
      @well_info.county = cnty[1]
      return
    end

    stat = info.match(/STAT\..+STATE:\s*(.*)/)
    unless stat.nil?
      @well_info.state = stat[1]
      return
    end

    ctry  = info.match(/CTRY\..+COUNTRY:\s*(.*)/)
    unless cnty.nil?
      @well_info.county = cnty[1]
      return
    end

    srvc = info.match(/SRVC\..+SERVICE COMPANY:\s*(.*)/)
    unless srvc.nil?
      @well_info.service_company = srvc[1]
      return
    end

    data = info.match(/DATE\..+LOG DATE:\s*(.*)/)
    unless data.nil?
      @well_info.date_logged = data[1]
      return
    end

    uwi = info.match(/UWI\..+UNIQUE WELL ID:\s*(.*)/)
    unless uwi.nil?
      @well_info.uwi = uwi[1]
      return
    end

  end

  def set_other_info(info)
  end

  def log_wrap_data(info,temp_array)
    d=info.scan(/[-]?[0-9]+.[0-9]+/)
    a = temp_array + d if not d.nil?
    if a.size == self.curves.size
      i=0
      self.curves.each do |k,v|
        v.log_data << a[i].to_f
        i+=1
      end
      a = []
    end
    return a
  end

  def log_nowrap_data(info)
    i=0
    d=info.scan(/[-]?[0-9]+.[0-9]+/)
    unless d.nil?
      self.curves.each do |k,v|
        v.log_data << d[i].to_f
        i+=1
      end
    end
  end

  def load_file(file_name)

    temp_array = []
    @curves = {}
    @parameters = {}

    read_state = 0

    section_definition = {
      'V' => "Version and wrap mode information",
      'W' => "well identification",
      'C' => "curve information",
      'P' => "parameters or constants",
      'O' => "other information such as comments",
      'A' => "ASCII log data"
    }

    unless File.exist?(file_name)
      raise "No such file or directory"
    end

    File.open(file_name).each do |line|
      # ignore comments
      next if line[0].chr == '#' 
      # The '~' is used to inform the beginning of a section
      if line[0].chr == '~' 
          unless section_definition.keys.include? line[1].chr
            puts "unsupported_file_format for #{line}"
          end
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
end