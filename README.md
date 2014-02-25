# Otis::Generator

This is a gem wrapper generator for [Otis Framework](https://github.com/tbueno/otis).

The current version is able to generate SOAP wrappers based on a input WSDL file.

## Installation

    $ gem install otis-generator

## Usage

In order to generate a gem, you need a WSDL file as input. 

    $ otis generate mygem --wsdl=my_file.wsdl

This command will generate a [Otis](https://github.com/tbueno/otis) wrapper, containing models, mapper and integration test infrastructure.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
