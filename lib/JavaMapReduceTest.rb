require 'java'
require 'jars/commons-io-2.1.jar'
require 'jars/jcoffeescript-1.1.jar'
require 'jars/js.jar'
require 'jars/js-14.jar'
$CLASSPATH << 'classes'

java_import "org.mitre.hquery.gateway.MapReduceBuilder"
java_import "org.mitre.hquery.gateway.MapReduce"

mrb = MapReduceBuilder.new("org.mitre.hquery.gateway.FileSystemValues", ["c:\\hquery\\data"].to_java(:string), "org.mitre.hquery.gateway.InMemoryHashEmitter", [].to_java(:string))
map_js =
'function map(patient) {
  if (patient.age() > 1) {
    emit("age", patient.age());
    emit("count", 1);
  }
};'
reduce_js =
'function reduce(key, values) {
  var sum = 0;
  for(var i in values) sum += values[i];
  return sum;
};'
mr = MapReduce.new(mrb, map_js, reduce_js, '', 'X')

result = mr.run
keys = result.keySet.iterator
while keys.hasNext
	key = keys.next
	value = result.get(key)
	puts "#{key}==>#{value}"
end

puts "Done!"
