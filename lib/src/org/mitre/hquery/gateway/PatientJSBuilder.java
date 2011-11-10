package org.mitre.hquery.gateway;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

import org.apache.commons.io.FileUtils;
import org.jcoffeescript.JCoffeeScriptCompileException;
import org.jcoffeescript.JCoffeeScriptCompiler;
import org.jcoffeescript.Option;

public class PatientJSBuilder {
	public static String getPatientAPI() throws IOException, JCoffeeScriptCompileException {
		StringBuffer coffee = new StringBuffer();
		
		coffee.append(FileUtils.readFileToString(new File("c:\\hquery\\patientapi\\app\\assets\\javascripts\\core.js.coffee"))).append("\n");
		coffee.append(FileUtils.readFileToString(new File("c:\\hquery\\patientapi\\app\\assets\\javascripts\\medication.js.coffee"))).append("\n");
		coffee.append(FileUtils.readFileToString(new File("c:\\hquery\\patientapi\\app\\assets\\javascripts\\condition.js.coffee"))).append("\n");
		coffee.append(FileUtils.readFileToString(new File("c:\\hquery\\patientapi\\app\\assets\\javascripts\\encounter.js.coffee"))).append("\n");
		coffee.append(FileUtils.readFileToString(new File("c:\\hquery\\patientapi\\app\\assets\\javascripts\\procedure.js.coffee"))).append("\n");
		coffee.append(FileUtils.readFileToString(new File("c:\\hquery\\patientapi\\app\\assets\\javascripts\\result.js.coffee"))).append("\n");
		coffee.append(FileUtils.readFileToString(new File("c:\\hquery\\patientapi\\app\\assets\\javascripts\\immunization.js.coffee"))).append("\n");
		coffee.append(FileUtils.readFileToString(new File("c:\\hquery\\patientapi\\app\\assets\\javascripts\\allergy.js.coffee"))).append("\n");
		coffee.append(FileUtils.readFileToString(new File("c:\\hquery\\patientapi\\app\\assets\\javascripts\\provider.js.coffee"))).append("\n");
		coffee.append(FileUtils.readFileToString(new File("c:\\hquery\\patientapi\\app\\assets\\javascripts\\languages.js.coffee"))).append("\n");
		coffee.append(FileUtils.readFileToString(new File("c:\\hquery\\patientapi\\app\\assets\\javascripts\\pregnancy.js.coffee"))).append("\n");
		coffee.append(FileUtils.readFileToString(new File("c:\\hquery\\patientapi\\app\\assets\\javascripts\\socialhistory.js.coffee"))).append("\n");
		coffee.append(FileUtils.readFileToString(new File("c:\\hquery\\patientapi\\app\\assets\\javascripts\\patient.js.coffee"))).append("\n");
		
		ArrayList<Option> coffeeOptions = new ArrayList<Option>();
		coffeeOptions.add(Option.BARE);
		return new JCoffeeScriptCompiler(coffeeOptions).compile(coffee.toString());
	}


}
