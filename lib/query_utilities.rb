# module for utilities related to generation of map/reduce queries and pre-filteres
module QueryUtilities
  
  # parse json string to an equivolent hash
  # this will strip the string and throw an exception if the string is not valid JSON
  def parse_json_to_hash(json)
    if (json.nil? or json.strip.length == 0) 
      return {}
    else 
      return ActiveSupport::JSON.decode json.strip
    end
  end
  
  # currently a no-op method.  If a format other than mongo query format is used for pre-filters, this method would do the appropriate conversion
  def convert_filter_to_mongo_query(filter) 
    filter
  end

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
