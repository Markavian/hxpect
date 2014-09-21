package hxpect;

import hxpect.core.SpecRunner;
import hxpect.core.TestRunner;
import hxpect.tests.*;
import hxpect.specs.*;

class Main 
{
	static function main() 
	{
		var testRunner = new TestRunner();
		testRunner.registerTestClass(AssertTests);
		testRunner.registerTestClass(BaseTestTests);
		testRunner.registerTestClass(BaseSpecTests);
		testRunner.registerTestClass(ExpectAssertionTests);
		testRunner.registerTestClass(LoggerTests);
		testRunner.run();
		
		var specRunner = new SpecRunner();
		specRunner.registerSpecClass(BaseSpecSpecs);
		specRunner.run();
		
		var successful = (testRunner.successful() && specRunner.successful());
		
		#if (flash || html5)
			var result = (successful) ? "Success" : "Failed";
			trace("Test runner: " + result);
		#else
			Sys.exit(successful ? 0 : 1);
		#end
	}
}