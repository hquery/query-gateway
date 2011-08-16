require 'sprockets'
require 'tilt'
require 'query_utilities'

class QueryExecutor
  
  include QueryUtilities
  
  PATIENTS_COLLECTION = "records"
  RESULTS_COLLECTION = "query_results"

  def initialize(map_js, reduce_js, query_id, filter={})
    @map_js = map_js
    @reduce_js = reduce_js
    @query_id = query_id
    @filter = filter
  end

  def execute
    db =  Mongoid.master
    # convert the filter hash to a mongo query style hash.  Currently we are passing in a mongo style query hash so this is a no-op
    exts = db['system.js'].find().to_a.collect do |ext|
      if (ext['value'].class == BSON::Code)
        "#{ext['_id']}();\n"
      else
        ""
      end
    end
    results = db[PATIENTS_COLLECTION].map_reduce(build_map_function(exts) , @reduce_js, :query => @filter, raw: true, out: {inline: 1})
    result_document = {}
    result_document["_id"] = @query_id
    results['results'].each do |result|
      result_document[result['_id']] = result['value']
    end

    db[RESULTS_COLLECTION].save(result_document)
  end

  def self.patient_api_javascript
    Tilt::CoffeeScriptTemplate.default_bare=true
    Rails.application.assets.find_asset("patient")
  end

  private
  def build_map_function(exts)
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
