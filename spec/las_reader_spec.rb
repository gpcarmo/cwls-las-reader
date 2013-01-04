require 'spec_helper'
  
describe "CWLSLas LAS reader" do

  file_path = File.expand_path(File.dirname(__FILE__) + '/fixtures/files/')
  
  describe CWLSLas, "#load_file" do
    context "when loading a file that does not exist" do
      las = CWLSLas.new
      it { expect { las.load_file('whatever.las') }.to raise_error("No such file or directory") } 
    end
  
    context "when loading file: 'example1.las'" do
        las = CWLSLas.new
        las.load_file(file_path+'/example1.las')
        it { las.should be_true }
    end
    context "when loading file: 'example2.las'" do
        las = CWLSLas.new
        las.load_file(file_path+'/example2.las')
        it { las.should be_true }
    end
    context "when loading file: 'example3.las'" do
        las = CWLSLas.new
        las.load_file(file_path+'/example3.las')
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


  describe CWLSLas, "#curves" do
    context "get depth curve from no_wrap mode file 'example1.las'" do
      c=LasReader::Curve.new("DEPT","M","","Depth")
      c.add(1670.0, 1669.875 , 1669.750)
      las = CWLSLas.new
      las.load_file(file_path+'/example1.las')
      it { expect(las.curve('DEPT')).to eq(c) }
    end
    context "get depth curve from wrap_mode file 'example3.las'" do
      c=LasReader::Curve.new("DEPT","M","","Depth")
      c.add(910.0, 909.875, 909.75, 909.625, 909.5)
      las = CWLSLas.new
      las.load_file(file_path+'/example3.las')
      it { expect(las.curve('DEPT')).to eq(c) }
    end
  end
  
end
