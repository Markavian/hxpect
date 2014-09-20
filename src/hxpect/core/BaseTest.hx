package hxpect.core;

class BaseTest
{
	public function expect(actualValue:Dynamic):ExpectAssertion
	{
		return new ExpectAssertion(actualValue);
	}
}