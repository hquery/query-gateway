package org.mitre.hquery.gateway;

/**
 * This interface encapsulates the generic methods needed to iterate over a set of records.
 * It is used in the following way:
 * The init method is invoked to establish a set of records.
 * The iterator method is used to retrieve the records, one at a time.
 * 
 * @author PMORK
 */
public interface ValueIterator extends Iterable<String> {
	/**
	 * This method is invoked before any other calls.
	 * @param obj An object that contains any data needed by init.
	 */
	public void init(String[] args);
}
