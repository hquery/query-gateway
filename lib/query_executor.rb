require 'sprockets'
require 'tilt'

class QueryExecutor

  PATIENTS_COLELCTION = "records"
  RESULTS_COLLECTION = "query_results"

  def initialize(map_js, reduce_js, query_id, filter={})
    @map_js = map_js
    @reduce_js = reduce_js
    @query_id = query_id
    @filter = filter
  end

  def execute
    db = Mongoid.master

    results = db[PATIENTS_COLELCTION].map_reduce(build_map_function , @reduce_js, :query => @filter, raw: true, out: {inline: 1})
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
  def build_map_function
    "function() {
      this.hQuery || (this.hQuery = {});
      var hQuery = this.hQuery;
      #{QueryExecutor.patient_api_javascript}
      #{@map_js}
      var patient = new hQuery.Patient(this);
      map(patient);
    };"

  end
end
