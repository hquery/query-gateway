require File.expand_path('../../../config/environment', __FILE__)

namespace :js do

  desc 'Load extension libraries into Mongo system.js collection'
  task :load do
    Dir.glob(File.join(Rails.root, 'db', 'js', '*')).each do |js_file|
      fn_name = File.basename(js_file, '.js')
      raw_js = File.read(js_file)
      Mongoid.master['system.js'].save(
        {
          '_id' => fn_name,
          'value' => BSON::Code.new(raw_js)
        }
      )
    end 
  end
  
end
