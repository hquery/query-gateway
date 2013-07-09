source 'https://rubygems.org'
#gem 'java-query-gateway', '0.1', :git =>"http://github.com/rdingwell/java-hquery-executor.git", :platforms => :jruby


gem 'rails', '~> 3.2.1'
gem 'jruby-openssl', :platforms => :jruby
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

gem 'daemons'
gem 'jquery-rails'

gem 'mongoid' #, '2.4.2'
#gem 'bson_ext', '~> 1.3', :platforms => :mri

gem 'delayed_job'
gem 'delayed_job_mongoid' #, '~> 1.0.8'

gem 'hquery-patient-api', :git => 'http://github.com/scoophealth/patientapi.git', :tag => 'v1.0.0'
gem "health-data-standards", :git => 'http://github.com/scoophealth/health-data-standards.git', :branch => 'scoop-develop' #:tag => 'v2.1.4'
gem "hqmf2js", :git => 'http://github.com/hquery/hqmf2js.git', :tag => 'V0.3'
#gem 'hqmf2js', path: '../hqmf2js'
gem 'hqmf-parser', :git => 'http://github.com/scoophealth/hqmf-parser.git', :branch => 'scoop-develop'

gem 'coderay'

gem 'kramdown'
gem 'pry'

# Specific to the SCOOP staging environment
#gem 'heroku'

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

