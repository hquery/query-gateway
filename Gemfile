source 'https://rubygems.org'

gem 'rails'
gem 'jruby-openssl', :platforms => :jruby
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

gem 'daemons'
gem 'jquery-rails'

gem 'mongoid'

gem 'delayed_job'
gem 'delayed_job_mongoid'

gem 'hquery-patient-api', :git => 'http://github.com/scoophealth/patientapi.git', :branch => 'scoop-develop'
#gem 'hquery-patient-api', path: '../patientapi'
gem "health-data-standards", :git => 'http://github.com/scoophealth/health-data-standards.git', :branch => 'scoop-develop'
#gem "health-data-standards", :git => 'http://github.com/scoophealth/health-data-standards.git', :branch => 'scoop-e2e-1.35'
gem "hqmf2js", :git => 'http://github.com/scoophealth/hqmf2js.git', :branch => 'scoop-develop'
#gem 'hqmf2js', path: '../hqmf2js'
gem 'hqmf-parser', :git => 'http://github.com/scoophealth/hqmf-parser.git', :branch => 'scoop-develop'

gem 'coderay'

gem 'kramdown'
gem 'pry'

group :test do

  # Pretty printed test output
  gem 'minitest', '< 5.0.0'
  gem 'turn', :require => false
  gem 'cover_me', '>= 1.0.0.rc6', :platforms => :ruby
  gem 'factory_girl'
  gem 'awesome_print', :require => 'ap'
  gem 'mocha', :require => false
  gem 'therubyracer', :platforms => :ruby
  gem 'therubyrhino', :platforms => :jruby

end

#group :production do
#  gem 'thin'
#end

