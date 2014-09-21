package hxpect.core;

class BaseTest
{
	function expect(actualValue:Dynamic):ExpectAssertion
	{
		return new ExpectAssertion(actualValue);
	}
}