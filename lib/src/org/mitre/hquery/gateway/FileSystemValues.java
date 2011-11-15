package org.mitre.hquery.gateway;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.Iterator;

import org.apache.commons.io.FileUtils;

/**
 * This iterator requires one parameter that indicates a directory; each file in that directory will be treated as a single value.
 * 
 * @author PMORK
 */
public class FileSystemValues implements ValueIterator {

	protected File[] files;
	
	@Override
	public void init(String[] args) {
		File dir = new File(args[0]);
		if (!dir.isDirectory()) throw new IllegalArgumentException(args[0] + " is not a directory");
		files = dir.listFiles();
	}

	@Override
	public Iterator<String> iterator() {
		return new Iterator<String>() {
			
			Iterator<File> fileItr = Arrays.asList(files).iterator();

			@Override
			public boolean hasNext() {
				return fileItr.hasNext();
			}

			@Override
			public String next() {
				File f = fileItr.next();
				try {
					return FileUtils.readFileToString(f);
				} catch (IOException e) {
					e.printStackTrace();
					return null;
				}
			}

			@Override
			public void remove() {
				fileItr.remove();
			}
			
		};
	}

}