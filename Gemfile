source 'http://rubygems.org'
#gem 'java-query-gateway', '0.1', :git =>"http://github.com/rdingwell/java-hquery-executor.git", :platforms => :jruby
gem 'rails'
gem 'jruby-openssl', :platforms => :jruby
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

gem 'jquery-rails'

gem "mongoid", "~> 2.0"
gem "bson_ext", "~> 1.3", :platforms => :mri

gem 'delayed_job_mongoid', :git => 'https://github.com/collectiveidea/delayed_job_mongoid.git'

gem "hquery-patient-api", :git => 'http://github.com/hquery/patientapi.git', :tag => 'V0.2'
gem "health-data-standards", :git => 'http://github.com/projectcypress/health-data-standards.git', :branch => 'develop'

gem 'coderay'

gem 'kramdown'

# needed but not specified by macaddr
# macaddr comes in from quality-measure-engine -> resque-status -> uuid -> macaddr (feels like Maven)
gem 'systemu', :git => 'http://github.com/rdingwell/systemu'

group :test do

  # Pretty printed test output
  gem 'minitest'
  gem 'turn', :require => false
  gem 'cover_me', '>= 1.0.0.rc6', :platforms => :ruby
  gem 'factory_girl', '1.3.3'
  gem 'awesome_print', :require => 'ap'
  gem 'mocha', :require => false
  gem 'pry'
  gem 'therubyracer', :platforms => :ruby
  gem 'therubyrhino', :platforms => :jruby

end

