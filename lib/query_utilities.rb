# module for utilities related to generation of map/reduce queries
module QueryUtilities

  # Load query extension libraries into Mongo system.js collection
  def self.load_js_libs
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
  
  # Remove the contents of the Mongo system.js collection
  def self.clean_js_libs
    Mongoid.master['system.js'].remove()
  end
  
end
