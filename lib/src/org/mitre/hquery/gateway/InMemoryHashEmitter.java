package org.mitre.hquery.gateway;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

/**
 * No parameters are needed to initialize this iterator.
 * 
 * @author PMORK
 */
public class InMemoryHashEmitter implements EmitIterator {
	
	private HashMap<Object, ArrayList<Object>> results;

	@Override
	public void init(String[] args) {
		results = new HashMap<Object, ArrayList<Object>>();
	}

	@Override
	public void emit(Object key, Object value) {
		ArrayList<Object> valueList = find(key);
		valueList.add(value);
	}
	
	private ArrayList<Object> find(Object key) {
		if (results.containsKey(key)) return results.get(key);
		ArrayList<Object> result = new ArrayList<Object>();
		results.put(key, result);
		return result;
	}
	
	@Override
	public Iterator<Object> iterator() {
		return results.keySet().iterator();
	}

	@Override
	public Object[] get(Object key) {
		Object[] array = new Object[0];
		return results.get(key).toArray(array);
	}

	@Override
	public void delete() {
		results = null;
	}

}
