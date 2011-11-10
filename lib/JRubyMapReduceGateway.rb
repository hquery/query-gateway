require 'sprockets'
require 'tilt'
require 'query_utilities'

require 'java'
require 'jars/commons-io-2.1.jar'
require 'jars/jcoffeescript-1.1.jar'
require 'jars/js.jar'
require 'jars/js-14.jar'
$CLASSPATH << 'classes'

java_import "org.mitre.hquery.gateway.MapReduceBuilder"
java_import "org.mitre.hquery.gateway.MapReduce"

class QueryExecutor
  
  include QueryUtilities
  
  VALUE_ITERATOR = "org.mitre.hquery.gateway.FileSystemValues"
  VALUE_ARGS = ["c:\\hquery\\data"].to_java(:string)
  EMIT_ITERATOR = "org.mitre.hquery.gateway.InMemoryHashEmitter"
  EMIT_ARGS = [].to_java(:string)
  BUILDER = MapReduceBuilder.new(QueryExecutor.patient_api_javascript, VALUE_ITERATOR, VALUE_ARGS, EMIT_ITERATOR, EMIT_ARGS)
  
  def self.patient_api_javascript
    Tilt::CoffeeScriptTemplate.default_bare=true
    Rails.application.assets.find_asset("patient")
  end

  def initialize(map_js, reduce_js, functions_js, query_id, filter={})
    @engine = MapReduce.new(BUILDER, map_js, reduce_js, functions_js, query_id)
  end

  def execute
  	results = @engine.run
  end
  
end