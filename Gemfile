source 'http://rubygems.org'

gem 'rails', '3.1.0.rc5'

group :assets do
  gem 'sass-rails', "~> 3.1.0.rc"
  gem 'coffee-rails', "~> 3.1.0.rc"
  gem 'uglifier'
end

gem 'jquery-rails'

gem 'therubyracer'

gem "mongoid", "~> 2.0"
gem "bson_ext", "~> 1.3", :platforms => :mri

gem 'quality-measure-engine', :git => 'http://github.com/pophealth/quality-measure-engine.git', :branch => 'develop'

gem 'delayed_job_mongoid', :git=>'https://github.com/collectiveidea/delayed_job_mongoid.git'

gem "hquery-patient-api", :git=>'http://github.com/hquery/patientapi.git'

gem 'coderay'

#gem 'pry'
gem 'bluecloth'

# needed but not specified by macaddr
# macaddr comes in from quality-measure-engine -> resque-status -> uuid -> macaddr (feels like Maven)
gem 'systemu'

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
  gem 'cover_me', '>= 1.0.0.rc6'
  gem 'factory_girl', '1.3.3'
  gem 'awesome_print', :require => 'ap'
  gem 'mocha', :require => false
end
