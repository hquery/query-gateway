package org.mitre.hquery.gateway;

/**
 * This interface encapsulates the generic methods needed to temporarily associate a set of
 * keys each with a set of values.  It is used in the following way:
 * The init method is invoked to create any temporary storage needed.
 * The emit method is invoked multiple times to associate a key with a single value.
 * NB: The same key can be associated with multiple values.
 * The iterator method is used to retrieve the keys.
 * The get method is used to lookup the values associated with each key.
 * The delete method is used to clean up any temporary storage.
 * 
 * @author PMORK
 */
public interface EmitIterator extends Iterable<Object> {
	/**
	 * This method is invoked before any other calls.
	 * @param obj Parameters needed to initialize the iterator.
	 */
	public void init(String[] args);
	/**
	 * This method is invoked by JavaScript to store key/value pairs.
	 * @param key The key to be saved temporarily.
	 * @param value A value to be associated with the key.
	 */
	public void emit(Object key, Object value);
	/**
	 * This method returns all of the values associated with the key.
	 * @param key A key stored using emit().
	 * @return All of the associated values.
	 */
	public Object[] get(Object key);
	/**
	 * This method is invoked when processing is complete;
	 * implementing classes should use this to delete any temporary storage.
	 */
	public void delete();
}
