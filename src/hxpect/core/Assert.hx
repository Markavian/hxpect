package hxpect.core;

class Assert
{
	public static function assertTrue(actual:Bool):Void
	{
		if (!actual)
		{
			throw "Actual value '" + actual + "' should be true";
		}
	}
	public static function assertFalse(actual:Bool):Void
	{
		if (actual)
		{
			throw "Actual value '" + actual + "' should be false";
		}
	}
	
	public static function assertEqual(expected:Dynamic, actual:Dynamic):Void
	{
		if (expected != actual)
		{
			throw "Actual value '" + actual + "' should equal expected value '" + expected + "'";
		}
	}
	
	public static function assertNotEqual(expected:Dynamic, actual:Dynamic):Void
	{
		if (expected == actual)
		{
			throw "Actual value '" + actual + "' should not equal expected value '" + expected + "'";
		}
	}
	
	public static function assertNull(actual:Dynamic):Void
	{
		if (actual != null)
		{
			throw "Actual value '" + actual + "' should be null";
		}
	}
	
	public static function assertNotNull(actual:Dynamic):Void
	{
		if (actual == null)
		{
			throw "Actual value '" + actual + "' should not be null";
		}
	}
}