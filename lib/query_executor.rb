class QueryExecutor
  PATIENTS_COLELCTION = "records"
  RESULTS_COLLECTION = "query_results"
  
  def initialize(map_js, reduce_js, job_id)
    @map_js = map_js
    @reduce_js = reduce_js
    @job_id = job_id
  end
  
  def execute
    db =  Mongoid.master
    results = db[PATIENTS_COLELCTION].map_reduce(build_map_function , @reduce_js , raw: true, out: {inline: 1})
    results["_id"] = @job_id
    db[RESULTS_COLLECTION].save(results)
  end
  
  private
  def build_map_function
    patient_coffee = File.read(Rails.root + 'lib/patient.coffee')
    patient_api = CoffeeScript.compile(patient_coffee, bare: true)
    "function() {
      #{patient_api}
      #{@map_js}
      
      var patient = new Patient(this);
      map(patient);
    };"
    
  end
end