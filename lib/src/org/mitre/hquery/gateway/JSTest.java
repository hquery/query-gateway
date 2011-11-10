package org.mitre.hquery.gateway;

import org.mozilla.javascript.Context;
import org.mozilla.javascript.Function;
import org.mozilla.javascript.Scriptable;

public class JSTest {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		Context context = Context.enter();
		Scriptable scope = context.initStandardObjects();
		
		String js = "var bob = { fist: \"Bob\", age: 32 };\nfunction pullName(obj) {\n  return eval(\"(\" + obj + \")\").first;\n}";
//		js = "var arr = [1, 2];\nfunction sum(obj) {\n var sum = 0;\n for (i in eval(\"(\" + obj + \")\")) sum += arr[i];\n return sum;\n}";
	    context.evaluateString(scope, js, "DUMMY", 1, null);
	    
	    Function fn = (Function) scope.get("pullName", scope);
	    String[] fnArgs = { "{ \"first\": \"Bob\", age: 32 }" };
//	    String[] fnArgs = { "[1, 2]" };
	    Object obj = fn.call(context, scope, scope, fnArgs);
	    
	    System.out.println(Context.toString(obj));
	    
	    System.out.println("DONE!");
	}

}
