require 'sprockets'
require 'tilt'
require 'query_utilities'

class MongoQueryExecutor 

  include QueryUtilities
 
  PATIENTS_COLLECTION = "records"

  def initialize(format, map_js, reduce_js, functions_js, query_id, filter={})
    @format = format
    @map_js = map_js
    @reduce_js = reduce_js
    @query_id = query_id
    @filter = filter
    @functions_js = functions_js
  end

  def execute
    #db =  Mongoid.master
    db = Mongoid.default_session #.options[:database]
    exts = []
    exts << @functions_js
    #results = db[PATIENTS_COLLECTION].map_reduce(build_map_function(exts), build_reduce_function(), :query => @filter, raw: true, out: {inline: 1})

    # An example of using Moped to execute a map_reduce command on a session
    # can be found at http://mongoid.org/en/moped/docs/driver.html under
    # Session#command
    results = db.command(
        mapreduce: PATIENTS_COLLECTION,
        map: build_map_function(exts),
        reduce: @reduce_js,
        query: @filter,
        raw: true,
        out: {inline: 1}
    )

    result = {}
    results['results'].each do |rv|
      key = QueryUtilities.stringify_key(rv['_id'])
      result[key] =  rv['value']
    end  
    result
    
  end
  
  private
  
  def build_map_function(exts = "")
    "function() {
      this.hQuery || (this.hQuery = {});
      this.Specifics || (this.Specifics = {});
      var hQuery = this.hQuery;
      var Specifics = this.Specifics;
      #{QueryUtilities.patient_api_javascript}
      #{exts.join}
      #{@map_js}
      var patient = new hQuery.Patient(this);
      if (Specifics.initialize) {
        Specifics.initialize();
      }
      map(patient);
    };"
  end
end
