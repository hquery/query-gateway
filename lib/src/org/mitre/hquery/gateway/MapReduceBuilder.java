package org.mitre.hquery.gateway;

import java.io.IOException;
import java.util.HashMap;

import org.jcoffeescript.JCoffeeScriptCompileException;

/**
 * This class runs a map/reduce job using a Java harness.
 * The outer class instantiates background data structures.
 * The inner class (MapReduce) actually executes a particular map/reduce job.
 * 
 * @author PMORK
 */
public class MapReduceBuilder {
	
	public final String api;
	public final String valueItr;
	public final String[] valueArgs;
	public final String emitItr;
	public final String[] emitArgs;

	/**
	 * @param api Included to support the Patient API, but an empty string can be passed if the API is not needed.
	 * @param valueItr The name of a class that implements the ValueIterator interface.
	 * @param valueArgs An array of arguments to be passed to the value iterator on initialization.
	 * @param emitItr The name of a class that implements the EmitIterator interface.
	 * @param emitArgs An array of arguments to be passed to the emit iterator on initialization.
	 */
	public MapReduceBuilder(String api, String valueItr, String[] valueArgs, String emitItr, String[] emitArgs) {
		this.api = api;
		this.valueItr = valueItr;
		this.valueArgs = valueArgs;
		this.emitItr = emitItr;
		this.emitArgs = emitArgs;
	}
	
	/**
	 * @param valueItr The name of a class that implements the ValueIterator interface.
	 * @param valueArgs An array of arguments to be passed to the value iterator on initialization.
	 * @param emitItr The name of a class that implements the EmitIterator interface.
	 * @param emitArgs An array of arguments to be passed to the emit iterator on initialization.
	 */
	public MapReduceBuilder(String valueItr, String[] valArgs, String emitItr, String[] emitArgs) throws IOException, JCoffeeScriptCompileException {
		// Use a static helper method to initialize the Patient API.
		this(PatientJSBuilder.getPatientAPI(), valueItr, valArgs, emitItr, emitArgs);
	}
	
	/**
	 * @return A new value iterator to be used by a MapReduce object.
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws ClassNotFoundException
	 */
	protected ValueIterator createValueIterator() throws InstantiationException, IllegalAccessException, ClassNotFoundException {
		// Create a new value iterator; use reflection so that the client can pass in the relevant class name.
		ValueIterator result = (ValueIterator) Class.forName(valueItr).newInstance();
		result.init(valueArgs);
		return result;
	}
	
	/**
	 * @return A new emit iterator to be used by a MapReduce object.
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws ClassNotFoundException
	 */
	protected EmitIterator createEmitIterator() throws InstantiationException, IllegalAccessException, ClassNotFoundException {
		// Create a new emit iterator; use reflection so that the client can pass in the relevant class name.
		EmitIterator result = (EmitIterator) Class.forName(emitItr).newInstance();
		result.init(emitArgs);
		return result;
	}
	
	public static void main(String args[]) throws IOException, JCoffeeScriptCompileException, InstantiationException, IllegalAccessException, ClassNotFoundException {
		String map_js = "function map(patient) {\n"
			+ "  if (patient.age() > 1) {\n"
			+ "    emit(\"age\", patient.age());\n"
			+ "    emit(\"count\", 1);\n"
			+ "  }\n"
			+ "}\n";
		String reduce_js = "function reduce(key, values) {\n"
			+ "  var sum = 0;\n"
			+ "  for(var i in values) sum += values[i];\n"
			+ "  return sum;\n"
			+ "};";
		String valueItr = "org.mitre.hquery.gateway.FileSystemValues";
		String[] valueArgs = { "c:\\hquery\\data" };
		String emitItr = "org.mitre.hquery.gateway.InMemoryHashEmitter";
		String[] emitArgs = null;
		MapReduceBuilder mrb = new MapReduceBuilder(valueItr, valueArgs, emitItr, emitArgs);
		MapReduce mr = new MapReduce(mrb, map_js, reduce_js, "", "X");
		HashMap<Object, Object> result = mr.run();
		for (Object key : result.keySet()) {
			System.out.println(key + "==>" + result.get(key));
		}
	}
	
}