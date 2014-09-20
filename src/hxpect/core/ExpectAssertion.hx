package hxpect.core;

class ExpectAssertion
{
	public var to(get, null):ExpectAssertion;
	public var not(get, null):ExpectAssertion;
	
	var actualValue:Dynamic;
	var negativeFlag:Bool;
	
	public function new(actualValue:Dynamic) 
	{
		this.actualValue = actualValue;
		negativeFlag = false;
	}
	
	public function be(expected:Dynamic):Void
	{
		if (negativeFlag)
		{
			Assert.assertNotEqual(expected, actualValue);
		}
		else
		{
			Assert.assertEqual(expected, actualValue);
		}
	}
	
	public function beNull():Void
	{
		if (negativeFlag)
		{
			Assert.assertNotNull(actualValue);
		}
		else
		{
			Assert.assertNull(actualValue);
		}
	}
	
	public function throwException(?exception:Dynamic):Void
	{
		var runBlock = actualValue;
		
		if (negativeFlag)
		{
			testForNoException(runBlock, exception);
		}
		else
		{
			testForException(runBlock, exception);
		}
	}
	
	function testForNoException(runBlock:Void->Dynamic, unexpectedException:Dynamic)
	{
		try
		{
			runBlock();
		}
		catch (exception:Dynamic)
		{
			if (exception == unexpectedException)
			{
				throw "Method incorrectly threw the unexpected exception: " + exception;
			}
			else if (unexpectedException == null)
			{
				throw "Method unexpectedly threw an exception: " + exception;
			}
		}
	}
	
	function testForException(runBlock:Void->Dynamic, expectedException:Dynamic)
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
			else if (expectedException == null)
			{
				testPassed = true;
			}
			else
			{
				throw "Method threw unexpected exception: " + exception;
			}
		}
		
		if (!testPassed)
		{
			throw "Method failed to throw any exception.";
		}
	}
	
	function get_not():ExpectAssertion
	{
		negativeFlag = true;
		return this;
	}
	
	function get_to():ExpectAssertion
	{
		return this;
	}
}