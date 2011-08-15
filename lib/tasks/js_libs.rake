require File.expand_path('../../../config/environment', __FILE__)

namespace :js do

  desc 'Load extension libraries into Mongo system.js collection'
  task :load do
    QueryUtilities.load_js_libs 
  end
  
  desc 'Remove the contents of the Mongo system.js collection'
  task :clean do
    QueryUtilities.clean_js_libs
  end
  
end
