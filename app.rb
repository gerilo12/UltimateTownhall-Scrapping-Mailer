require "bundler"

Bundler.require
$:.unshift File.expand_path("./../lib", __dir__)
$:.unshift File.expand_path('./../db', __dir__)
$:.unshift File.expand_path('lib/views', __dir__)

require_relative "./lib/views/index.rb"
require_relative "./lib/views/done.rb"
require_relative "./lib/app/townhall_scrapper"
require_relative './lib/app/townhall_follower'
require_relative './lib/app/townhall_mailer'

Dotenv.load

Menu.new
