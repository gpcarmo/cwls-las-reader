require 'spec_helper'
  
describe "CWLS LAS reader" do

  file_path = File.expand_path(File.dirname(__FILE__) + '/fixtures/files/')
  
  describe CWLSLas, "#load_file" do
    context "when loading a file that does not exist" do
      las = CWLSLas.new
      it { expect { las.load_file('whatever.las') }.to raise_error("No such file or directory") } 
    end

    context "when loading a LAS file version other then 1.2 or 2.0" do
      las = CWLSLas.new
      it { expect { las.load_file(file_path+'/LAS_30a_Revised_2010.las') }.to raise_error("LAS version not supported") } 
    end
  
    # LAS v1.2   
    context "when loading LAS v1.2 file: 'example1.las'" do
        las = CWLSLas.new
        las.load_file(file_path+'/example1.las')
        it { expect(las).to be_truthy }
    end
    context "when loading LAS v1.2 file: 'example2.las'" do
        las = CWLSLas.new
        las.load_file(file_path+'/example2.las')
        it { expect(las).to be_truthy }
    end
    context "when loading LAS v1.2 file: 'example3.las'" do
        las = CWLSLas.new
        las.load_file(file_path+'/example3.las')
        it { expect(las).to be_truthy }
    end
    
    # LAS v2.0   
    context "when loading LAS v2.0 file: 'example21.las'" do
        las = CWLSLas.new
        las.load_file(file_path+'/example21.las')
        it { expect(las).to be_truthy }
    end
    context "when loading LAS v2.0 file: 'example22.las'" do
        las = CWLSLas.new
        las.load_file(file_path+'/example22.las')
        it { expect(las).to be_truthy }
    end
    context "when loading LAS v2.0 file: 'example23.las'" do
        las = CWLSLas.new
        las.load_file(file_path+'/example23.las')
        it { expect(las).to be_truthy }
    end    
    context "when loading LAS v2.0 file: 'example24_check.las'" do
        las = CWLSLas.new
        las.load_file(file_path+'/example24_check.las')
        it { expect(las).to be_truthy }
    end
  
  end
  
  describe CWLSLas, "#curve_names" do
    context "number of curves in file example1.las" do
      las = CWLSLas.new
      las.load_file(file_path+'/example1.las')
      it { expect(las.curve_names.size).to eq(8) }
    end
    context "number of curves in file example2.las" do
      las = CWLSLas.new
      las.load_file(file_path+'/example2.las')
      it { expect(las.curve_names.size).to eq(8) }
    end
    context "number of curves in file example3.las" do
      las = CWLSLas.new
      las.load_file(file_path+'/example3.las')
      it { expect(las.curve_names.size).to eq(36) }
    end
  end

  describe CWLSLas, "#curve" do
    context "get depth curve from no_wrap mode LAS v1.2 file 'example1.las'" do
      c = [1670.0, 1669.875 , 1669.750]
      las = CWLSLas.new
      las.load_file(file_path+'/example1.las')
      it { expect(las.curve('DEPT').log_data).to eq(c) }
    end
    context "get depth curve from wrap_mode LAS v1.2 file 'example3.las'" do
      c = [910.0, 909.875, 909.75, 909.625, 909.5]
      las = CWLSLas.new
      las.load_file(file_path+'/example3.las')
      it { expect(las.curve('DEPT').log_data).to eq(c) }
    end
    context "get DT curve from wrap_mode with nil values from LAS v1.2 file 'example3.las'" do
      c = [nil, nil, nil, nil, nil]
      las = CWLSLas.new
      las.load_file(file_path+'/example3.las')
      it { expect(las.curve('DT').log_data).to eq(c) }
    end
    context "get DT curve from wrap_mode with nil values from LAS v2.0 file 'example23.las'" do
      c = [nil, nil, nil, nil, nil]
      las = CWLSLas.new
      las.load_file(file_path+'/example23.las')
      it { expect(las.curve('DT').log_data).to eq(c) }
    end
  end

  describe CWLSLas, "#well_name" do
    context "get well name from las v1.2 file 'example1.las'" do
      well_name = "ANY ET AL OIL WELL #12"
      las = CWLSLas.new
      las.load_file(file_path+'/example1.las')
      it { expect(las.well_name).to eq(well_name) }
    end
    context "get well name from las v2.0 file 'example21.las'" do
      well_name = "ANY ET AL 12-34-12-34"
      las = CWLSLas.new
      las.load_file(file_path+'/example21.las')
      it { expect(las.well_name).to eq(well_name) }
    end
  end

  describe CWLSLas, "#company_name" do
    context "get company name from las v1.2 file 'example1.las'" do
      company_name = "ANY OIL COMPANY LTD."
      las = CWLSLas.new
      las.load_file(file_path+'/example1.las')
      it { expect(las.company_name).to eq(company_name) }
    end
    context "get company name from las v2.0 file 'example21.las'" do
      company_name = "ANY OIL COMPANY INC."
      las = CWLSLas.new
      las.load_file(file_path+'/example21.las')
      it { expect(las.company_name).to eq(company_name) }
    end
  end

  describe CWLSLas, "#field_name" do
    context "get company name from las v1.2 file 'example1.las'" do
      field_name = "EDAM"
      las = CWLSLas.new
      las.load_file(file_path+'/example1.las')
      it { expect(las.field_name).to eq(field_name) }
    end
    context "get company name from las v2.0 file 'example21.las'" do
      field_name = "WILDCAT"
      las = CWLSLas.new
      las.load_file(file_path+'/example21.las')
      it { expect(las.field_name).to eq(field_name) }
    end
  end

  describe CWLSLas, "#location" do
    context "get location from las v1.2 file 'example1.las'" do
      location = "A9-16-49-20W3M"
      las = CWLSLas.new
      las.load_file(file_path+'/example1.las')
      it { expect(las.location).to eq(location) }
    end
    context "get location from las v2.0 file 'example21.las'" do
      location = "12-34-12-34W5M"
      las = CWLSLas.new
      las.load_file(file_path+'/example21.las')
      it { expect(las.location).to eq(location) }
    end
  end

  describe CWLSLas, "#province" do
    context "get province from las v1.2 file 'example1.las'" do
      province = "SASKATCHEWAN"
      las = CWLSLas.new
      las.load_file(file_path+'/example1.las')
      it { expect(las.province).to eq(province) }
    end
    context "get province from las v2.0 file 'example21.las'" do
      province = "ALBERTA"
      las = CWLSLas.new
      las.load_file(file_path+'/example21.las')
      it { expect(las.province).to eq(province) }
    end
  end

  describe CWLSLas, "#service_company" do
    context "get service company from las v1.2 file 'example1.las'" do
      service_company = "ANY LOGGING COMPANY LTD."
      las = CWLSLas.new
      las.load_file(file_path+'/example1.las')
      it { expect(las.service_company).to eq(service_company) }
    end
    context "get service company from las v2.0 file 'example21.las'" do
      service_company = "ANY LOGGING COMPANY INC."
      las = CWLSLas.new
      las.load_file(file_path+'/example21.las')
      it { expect(las.service_company).to eq(service_company) }
    end
  end

  describe CWLSLas, "#log_date" do
    context "get log date from las v1.2 file 'example1.las'" do
      log_date = "25-DEC-1988"
      las = CWLSLas.new
      las.load_file(file_path+'/example1.las')
      it { expect(las.log_date).to eq(log_date) }
    end
    context "get log date from las v2.0 file 'example21.las'" do
      log_date = "13-DEC-86"
      las = CWLSLas.new
      las.load_file(file_path+'/example21.las')
      it { expect(las.log_date).to eq(log_date) }
    end
  end

  describe CWLSLas, "#uwi" do
    context "get unique well id from las v1.2 file 'example1.las'" do
      uwi = "100091604920W300"
      las = CWLSLas.new
      las.load_file(file_path+'/example1.las')
      it { expect(las.uwi).to eq(uwi) }
    end
    context "get unique well id from las v2.0 file 'example21.las'" do
      uwi = "100123401234W500"
      las = CWLSLas.new
      las.load_file(file_path+'/example21.las')
      it { expect(las.uwi).to eq(uwi) }
    end
  end

end
