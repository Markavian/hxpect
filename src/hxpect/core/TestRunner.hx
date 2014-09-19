package hxpect.core;

class TestRunner
{
	private var logger:Logger;
	private var registeredTests:Array<Dynamic>;
	
	private var totalTestCount:Int = 0;
	private var totalSuccessCount:Int = 0;
	
	public function new()
	{
		// e.g. registerTestClass(CheckoutTest);
		
		logger = new Logger();
	}
	
	public function registerTestClass(testClass:Class<Dynamic>):Void
	{
		if (registeredTests == null)
		{
			registeredTests = new Array<Dynamic>();
		}
		
		registeredTests.push(testClass);
	}
	
	public function run():Void
	{
		beginTests();
		
		for (testClass in registeredTests)
		{
			runTestsOn(testClass);
		}
		
		testsComplete();
	}
	
	function beginTests():Void
	{
		logger.logInfo("Hxpect Test Runner - tests initialised");
		logger.logInfo("Operating system: " + Sys.systemName());
	}
	
	function runTestsOn(testClass:Class<Dynamic>):Void
	{
		var tests = Type.getInstanceFields(testClass);
		var instance:BaseTest = Type.createEmptyInstance(testClass);
		
		logger.logEmptyLine();
		logger.log("Running tests on " + Type.getClassName(testClass));
		var classTestCount:Int = 0;
		var classSuccessCount:Int = 0;
		for (testName in tests)
		{
			if (testName.indexOf("test") != -1)
			{
				classTestCount++;
				var success = runTest(instance, testName);
				if (success)
				{
					classSuccessCount++;
				}
			}
		}
		logger.log("Tests passed: " + classSuccessCount + "/" + classTestCount);
		
		totalTestCount += classTestCount;
		totalSuccessCount += classSuccessCount;
	}
	
	function runTest(instance:BaseTest, testName:String):Bool
	{
		try
		{
			runBeforeTest(instance);
			
			Reflect.callMethod(instance, Reflect.field(instance, testName), []);
			
			runAfterTest(instance);
		}
		catch (exception:Dynamic)
		{
			logger.logFail("- Test failed: " + testName + ", reason: " + exception);
			return false;
		}
		
		logger.logPass("+ Test passed: " + testName);
		
		return true;
	}
	
	function runBeforeTest(instance:BaseTest):Void
	{
		var beforeEach:Void->Void = cast Reflect.field(instance, "beforeEach");
		if (beforeEach != null)
		{
			Reflect.callMethod(instance, beforeEach, []); 
		}
	}
	
	function runAfterTest(instance:BaseTest):Void
	{
		var afterEach:Void->Void = cast Reflect.field(instance, "afterEach");
		if (afterEach != null)
		{
			Reflect.callMethod(instance, afterEach, []); 
		}
	}
	
	function testsComplete():Void
	{
		logger.logEmptyLine();
		logger.logInfo("Total tests passed: " + totalSuccessCount + "/" + totalTestCount);
		if (totalSuccessCount == totalTestCount)
		{
			logger.logPass("SUCCESS");
		}
		else
		{
			logger.logFail("FAILIURE");
		}
	}
	
	public function failiures():Int
	{
		return (totalTestCount - totalSuccessCount);
	}
}