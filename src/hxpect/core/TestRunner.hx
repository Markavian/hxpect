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
		registeredTests = new Array<Dynamic>();
	}
	
	public function registerTestClass(testClass:Class<Dynamic>):Void
	{
		registeredTests.push(testClass);
	}
	
	public function run():Void
	{
		printTitle();
		
		for (testClass in registeredTests)
		{
			runTestsOn(testClass);
		}
		
		testsComplete();
	}
	
	function printTitle():Void
	{
		logger.logEmptyLine();
		logger.logInfo("Hxpect Test Runner - tests initialised");
		logger.logInfo("Operating system: " + logger.systemName());
	}
	
	function runTestsOn(testClass:Class<Dynamic>):Void
	{
		var tests = Type.getInstanceFields(testClass);
		
		logger.logEmptyLine();
		logger.log("Running tests on " + Type.getClassName(testClass));
		
		var classTestCount:Int = 0;
		var classSuccessCount:Int = 0;
		for (testName in tests)
		{
			var instance:BaseTest = Type.createEmptyInstance(testClass);
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
		runMethodIfDefined(instance, "beforeEach");
	}
	
	function runAfterTest(instance:BaseTest):Void
	{
		runMethodIfDefined(instance, "afterEach");
	}
	
	function runMethodIfDefined(instance:BaseTest, fieldName:String):Void
	{
		try
		{
			var method:Void->Void = cast Reflect.field(instance, fieldName);
			if (method != null)
			{
				Reflect.callMethod(instance, method, []); 
			}
		}
		catch (exception:Dynamic)
		{
			// do nothing
		}
	}
	
	function testsComplete():Void
	{
		logger.logEmptyLine();
		logger.logInfo("Total tests passed: " + totalSuccessCount + "/" + totalTestCount);
		if (totalSuccessCount == totalTestCount)
		{
			logger.logPass("SUCCESS - All tests passed");
		}
		else
		{
			if (totalSuccessCount == 0)
			{
				logger.logFail("FAILIURE - No tests run");
			}
			else
			{
				logger.logFail("FAILIURE - " + failiures() + " tests failed");
			}
		}
		
		logger.logEmptyLine();
	}
	
	function failiures():Int
	{
		return (totalTestCount - totalSuccessCount);
	}
	
	public function successful():Bool
	{
		return (failiures() == 0) && (totalSuccessCount > 0);
	}
}