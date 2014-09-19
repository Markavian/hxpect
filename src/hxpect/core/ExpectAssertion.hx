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
	
	public function get_not():ExpectAssertion
	{
		negativeFlag = true;
		return this;
	}
	
	public function get_to():ExpectAssertion
	{
		return this;
	}
}