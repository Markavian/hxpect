package hxpect.core;

class TestRunner
{
	static inline var TEXT_PASS:String = "\033[32m";
	static inline var TEXT_INFO:String = "\033[36m";
	static inline var TEXT_WARNING:String = "\033[33m";
	static inline var TEXT_FAIL:String = "\033[31m";
	static inline var TEXT_RESET:String = "\033[0m";
	
	private var registeredTests:Array<Dynamic>;
	
	private var totalTestCount:Int = 0;
	private var totalSuccessCount:Int = 0;
	
	public function new()
	{
		// e.g. registerTestClass(CheckoutTest);
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
		logInfo("Hxpect Test Runner - tests initialised");
		logInfo("Operating system: " + Sys.systemName());
	}
	
	function runTestsOn(testClass:Class<Dynamic>):Void
	{
		var tests = Type.getInstanceFields(testClass);
		var instance:BaseTest = Type.createEmptyInstance(testClass);
		
		log("");
		log("Running tests on " + Type.getClassName(testClass));
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
		log("Tests passed: " + classSuccessCount + "/" + classTestCount);
		
		totalTestCount += classTestCount;
		totalSuccessCount += classSuccessCount;
	}
	
	function runTest(instance:BaseTest, testName:String):Bool
	{
		try
		{
			Reflect.callMethod(instance, Reflect.field(instance, testName), []);
		}
		catch (exception:Dynamic)
		{
			logPass("- Test failed: " + testName + ", reason: " + exception);
			return false;
		}
		
		logPass("+ Test passed: " + testName);
		
		return true;
	}
	
	function testsComplete():Void
	{
		log("");
		logInfo("Total tests passed: " + totalSuccessCount + "/" + totalTestCount);
		if (totalSuccessCount == totalTestCount)
		{
			logPass("SUCCESS");
		}
		else
		{
			logFail("FAILIURE");
		}
	}
	
	function logPass(message:String)
	{
		logColor(message, TEXT_PASS);
	}
	
	function logFail(message:String)
	{
		logColor(message, TEXT_FAIL);
	}
	
	function logWarning(message:String)
	{
		logColor(message, TEXT_WARNING);
	}
	
	function logInfo(message:String)
	{
		logColor(message, TEXT_INFO);
	}
	
	function logColor(message:String, textColor:String)
	{
		if (Sys.systemName() == "Windows")
		{
			log(message);
		}
		else
		{
			log(textColor + message + TEXT_RESET);
		}
	}
	
	function log(message:String)
	{
		Sys.println(message);
	}
	
	public function failiures():Int
	{
		return (totalTestCount - totalSuccessCount);
	}
}