package hxpect.tests;

import hxpect.core.TestRunner;
import neko.Lib;

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
		
		return testRunner.failiures();
	}
	
}