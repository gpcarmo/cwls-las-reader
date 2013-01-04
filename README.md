# LasReader

cwls-las-reader
Ruby gem for reading CWLS LAS files

The Canadian Well Logging Society's Floppy Disk Committee has designed a standard format for log data on floppy disks. It is known as the LAS format (Log ASCII Standard). LAS consists of files written in ASCII containing minimal header information and is intended for optical curves only.

Details of the LAS format are described in this paper (http://www.cwls.org/docs/LAS12_Standards.txt).

## Installation

Add this line to your application's Gemfile:

    gem 'las_reader'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install las_reader

## Quick irb Usage
    
    irb> require 'rubygems'
    irb> require 'las_reader'
    irb> my_las = CWLSLas.new('my_well.las')

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
