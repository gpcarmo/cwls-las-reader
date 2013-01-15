# LasReader

Ruby gem for reading CWLS LAS files

The Log ASCII Standard was created by the Canadian Well Logging Society in the late 1980’s. LAS was intended to supply basic digital log data to users of personal computers in a format that was quick and easy to use. LAS is an ASCII file with minimal header information, intended for optically presented log curves.  The world-wide acceptance of LAS proved the need for such a format. As users embraced the concept and the format, many new applications of the concept were attempted. Right now the latest version of the LAS format is 3.0. 

This gem does not read LAS 3.0 format yet because its initial intent is to be used in E&P data management applications.  Version 3.0 was released in June 10, 2000 so most of the data I have access right now is either in 1.2 or 2.0 format. 

## Installation

Add this line to your application's Gemfile:

    gem 'las_reader'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install las_reader

## Quick Usage
    
    require 'rubygems'
    require 'las_reader'
    my_las = CWLSLas.new('my_well.las')

## Usage

One of the main fucntionalities of the las_reader is to provide a way to access the curves inside the LAS file and other information regarding the well and about the logged data. Bellow an example of how to get the curve "DEEP RESISTIVITY" from the file [example1.las](https://github.com/gpcarmo/cwls-las-reader/blob/master/spec/fixtures/files/example1.las). You can find this example files inside [spec/fixtures/files](https://github.com/gpcarmo/cwls-las-reader/tree/master/spec/fixtures/files) folder.

### Examples

To begin the showing the basic examples, lets start a new CWLSLas object with a file name of an example las. Then we can get the well name:

     my_las = CWLSLas.new('example1.las')
     my_las.well_name
 
    => "ANY ET AL OIL WELL #12"
    

To get the curve mnemonics inside the file:

    my_las.curve_names
    
    => ["ILD", "ILM", "DT", "NPHI", "RHOB", "SFLA", "SFLU", "DEPT"] 

and to get a specific curve use:

    ild_curve = my_las.curve('ILD')


From this new curve object you may want to get the description:

    ild_curve.description

    => "8  DEEP RESISTIVITY"

Or, the values of the curve:

    ild_curve.log_data
    
    => [105.6, 105.6, 105.6]



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
