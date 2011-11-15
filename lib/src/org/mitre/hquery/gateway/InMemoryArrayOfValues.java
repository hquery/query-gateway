package org.mitre.hquery.gateway;

import java.util.Iterator;
import java.util.List;

import org.mozilla.javascript.edu.emory.mathcs.backport.java.util.Arrays;

/**
 * This iterator is initialized by passing it an array of strings that will be iterated over.
 * @author PMORK
 *
 */
public class InMemoryArrayOfValues implements ValueIterator {

	private List<String> values;
	
	@SuppressWarnings("unchecked")
	@Override
	public void init(String[] args) {
		values = Arrays.asList(args);
	}

	@Override
	public Iterator<String> iterator() {
		return values.iterator();
	}

}
