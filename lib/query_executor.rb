require 'sprockets'
require 'tilt'
require 'query_utilities'

class QueryExecutor
  
  include QueryUtilities
  
  PATIENTS_COLLECTION = "records"

  def initialize(map_js, reduce_js, functions_js, query_id, filter={})
    @map_js = map_js
    @reduce_js = reduce_js
    @query_id = query_id
    @filter = filter
    @functions_js = functions_js
  end

  def execute
    db =  Mongoid.master
    exts = db['system.js'].find().to_a.collect do |ext|
          if (ext['value'].class == BSON::Code)
            "#{ext['_id']}();\n"
          else
            ""
          end
        end
    exts << @functions_js    
    results = db[PATIENTS_COLLECTION].map_reduce(build_map_function(exts) , @reduce_js, :query => @filter, raw: true, out: {inline: 1})
    result = Result.new
    result.query = Query.find(@query_id)
    
    results['results'].each do |rv|
      key = stringify_key(rv['_id'])
      result.write_attribute(key.to_sym, rv['value'])
    end
    
    result.save!
  end
  
  def stringify_key(key)
    if (key.is_a? BSON::OrderedHash)
      key = (key.map {|val| stringify_key(val)}).join('_')
    end
    if (key.is_a? Array)
      key = (key.map {|val| stringify_key(val)}).join('_')
    end
    key.to_s
  end
  
  def self.patient_api_javascript
    Tilt::CoffeeScriptTemplate.default_bare=true
    Rails.application.assets.find_asset("patient")
  end

  private
  def build_map_function(exts = "")
    
    "function() {
      this.hQuery || (this.hQuery = {});
      var hQuery = this.hQuery;
      #{exts.join}
      #{QueryExecutor.patient_api_javascript}
      #{@map_js}
      var patient = new hQuery.Patient(this);
      map(patient);
    };"

  end
end
