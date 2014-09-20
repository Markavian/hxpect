package hxpect.tests;

import hxpect.core.TestRunner;

class Main 
{
	static function main() 
	{
		var testRunner = new TestRunner();
		testRunner.registerTestClass(AssertTests);
		testRunner.registerTestClass(BaseTestTests);
		testRunner.registerTestClass(ExpectAssertionTests);
		testRunner.registerTestClass(LoggerTests);
		testRunner.run();
		
		var successful = (testRunner.failiures() == 0);
		
		Sys.exit(successful ? 0 : 1);
	}
}