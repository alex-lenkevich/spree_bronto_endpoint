# This file is used by Rack-based servers to start the application.
$stdout.sync = true

Dir[::File.expand_path('../script/decorator/hook/*.rb',  __FILE__)].each {|file| require file }
Dir[::File.expand_path('../script/decorator/bronto/*.rb',  __FILE__)].each {|file| require file }
Dir[::File.expand_path('../script/decorator/helper/*.rb',  __FILE__)].each {|file| require file }
Dir[::File.expand_path('../script/decorator/converter/*.rb',  __FILE__)].each {|file| require file }

run Rack::Cascade.new [API]
