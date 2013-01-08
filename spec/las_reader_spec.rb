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
      it { expect { las.load_file(file_path+'LAS_30a_Revised_2010.las') }.to raise_error("LAS version not supported") } 
    end
  
    # LAS v1.2   
    context "when loading LAS v1.2 file: 'example1.las'" do
        las = CWLSLas.new
        las.load_file(file_path+'/example1.las')
        it { las.should be_true }
    end
    context "when loading LAS v1.2 file: 'example2.las'" do
        las = CWLSLas.new
        las.load_file(file_path+'/example2.las')
        it { las.should be_true }
    end
    context "when loading LAS v1.2 file: 'example3.las'" do
        las = CWLSLas.new
        las.load_file(file_path+'/example3.las')
        it { las.should be_true }
    end
    
    # LAS v2.0   
    context "when loading LAS v2.0 file: 'example21.las'" do
        las = CWLSLas.new
        las.load_file(file_path+'/example21.las')
        it { las.should be_true }
    end
    context "when loading LAS v2.0 file: 'example22.las'" do
        las = CWLSLas.new
        las.load_file(file_path+'/example22.las')
        it { las.should be_true }
    end
    context "when loading LAS v2.0 file: 'example23.las'" do
        las = CWLSLas.new
        las.load_file(file_path+'/example23.las')
        it { las.should be_true }
    end
  
  end
  
  describe CWLSLas, "#curve_names" do
    context "number of curves in file example1.las" do
      las = CWLSLas.new
      las.load_file(file_path+'/example1.las')
      it { las.curve_names.size.should == 8 }
    end
    context "number of curves in file example2.las" do
      las = CWLSLas.new
      las.load_file(file_path+'/example2.las')
      it { las.curve_names.size.should == 8 }
    end
    context "number of curves in file example3.las" do
      las = CWLSLas.new
      las.load_file(file_path+'/example3.las')
      it { las.curve_names.size.should == 36 }
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
      las.load_file(file_path+'/example3.las')
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

end
