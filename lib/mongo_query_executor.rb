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
    db =  Mongoid.master
    exts = []
    exts << @functions_js    
    results = db[PATIENTS_COLLECTION].map_reduce(build_map_function(exts), build_reduce_function(), :query => @filter, raw: true, out: {inline: 1})
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
      var hQuery = this.hQuery;
      #{exts.join}
      #{QueryUtilities.patient_api_javascript}
      #{@map_js}
      var patient = new hQuery.Patient(this);
      map(patient);
    };"
  end
  
  def build_reduce_function()
    "function(k,v){
       
       var iter = function(x){
         this.index = 0;
         this.arr = (x==null)? [] : x;
         
         this.hasNext = function(){
           return this.index < this.arr.length;
         };
         
         this.next = function(){
           return this.arr[this.index++];
         }
       };
       
       #{@reduce_js}
       return reduce(k,new iter(v));
    }"
  end
end
