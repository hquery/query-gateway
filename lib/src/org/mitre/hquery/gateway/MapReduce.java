package org.mitre.hquery.gateway;

import java.util.HashMap;

import org.mozilla.javascript.Context;
import org.mozilla.javascript.Function;
import org.mozilla.javascript.Scriptable;
import org.mozilla.javascript.ScriptableObject;
import org.mozilla.javascript.edu.emory.mathcs.backport.java.util.Arrays;

public class MapReduce {
	public final MapReduceBuilder builder;
	public final String map_js;
	public final String reduce_js;
	public final String functions_js;
	public final String query_id;
	public final Context context;
	public final Scriptable scope;
	public final ValueIterator valueItr;
	public final EmitIterator emitItr;
	
	/**
	 * @param map_js The map function to be executed.
	 * @param reduce_js The reduce function to be executed.
	 * @param functions_js Any other functions needed by map or reduce.
	 * @param query_id Currently unused.
	 * @param mapReduceBuilder TODO
	 * @throws ClassNotFoundException 
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 */
	public MapReduce(MapReduceBuilder builder, String map_js, String reduce_js, String functions_js, String query_id) throws InstantiationException, IllegalAccessException, ClassNotFoundException {
		this.builder = builder;
		this.map_js = map_js;
		this.reduce_js = reduce_js;
		this.functions_js = functions_js;
		this.query_id = query_id;
		
		// Separate objects are created for each invocation to avoid trampling on shared data structures.
		// TODO: Seal the context?
		this.context = Context.enter();
		this.scope = context.initStandardObjects();
		this.valueItr = builder.createValueIterator();
		this.emitItr = builder.createEmitIterator();
	}

	/**
	 * Runs the map/reduce framework.
	 * @return A set of key value pairs following the reduce phase.
	 */
	public HashMap<Object, Object> run() {
		HashMap<Object, Object> result = new HashMap<Object, Object>();
		
		// The iterator is added to the context as $emit so that emit can be invoked as $emit.emit().
		Object wrappedE = Context.javaToJS(emitItr, scope);
		ScriptableObject.putProperty(scope, "$emit", wrappedE);
		
		// Add a wrapper for $emit.emit called emit so that the emit function works from within Javascript.
		// And, add $map as a function, which will be called once (from Java) for each value; eval converts the string into an object.
		// Finally, add $reduce as a function (called from Java); eval converts an array string into an actual array.
		String helper_js = "\n"
			+ "function emit(k,v){$emit.emit(k,v);}\n"
			+ "function $map(patient){map(new hQuery.Patient(eval(\"(\" + patient + \")\")));}\n"
			+ "function $reduce(key,values){return reduce(key, eval(\"(\" + values + \")\"));}\n";
	    context.evaluateString(scope, builder.api + helper_js + functions_js + map_js + reduce_js, "DUMMY", 1, null);

	    // Invoke $map once for each value returned by the value iterator.
	    Function mapFn = (Function) scope.get("$map", scope);
		for (String value : valueItr) {
			Object[] args = { value };
			mapFn.call(context, scope, scope, args);
		}

		// Invoke $reduce once for each key after converting the associated values into an array string.
		Function reduceFn = (Function) scope.get("$reduce", scope);
		for (Object key : emitItr) {
			// TODO: This approach flattens the objects into strings; is this always safe? 
			String[] args = { key.toString(), Arrays.toString(emitItr.get(key)) };
			Object reducedValue = reduceFn.call(context, scope, scope, args);
			result.put(key, reducedValue);
		}
		
		// Return the final set of key/value pairs.
		return result;
	}
	
}