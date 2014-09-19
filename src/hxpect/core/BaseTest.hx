package hxpect.core;

class BaseTest
{
	public function expect(actualValue:Dynamic):ExpectAssertion
	{
		return new ExpectAssertion(actualValue);
	}
	
	public function expectNoExceptions(runBlock:Void->Void):Void
	{
		try
		{
			runBlock();
		}
		catch (exception:Dynamic)
		{
			throw "Assertion failed unexpectedly: " + exception;
		}
	}
	
	public function expectException(runBlock:Void->Void, expectedException:Dynamic):Void
	{
		var testPassed:Bool = false;
		try
		{
			runBlock();
		}
		catch (exception:Dynamic)
		{
			if (exception == expectedException)
			{
				testPassed = true;
			}
			else
			{
				throw "Assertion failed for wrong reason: " + exception;
			}
		}
		
		if (!testPassed)
		{
			throw "Assertion failed to fail.";
		}
	}
}