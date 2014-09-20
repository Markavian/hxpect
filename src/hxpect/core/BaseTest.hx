package hxpect.core;

class BaseTest
{
	public function expect(actualValue:Dynamic):ExpectAssertion
	{
		return new ExpectAssertion(actualValue);
	}
	
	public function expectNoExceptions(runBlock:Void->Void):Void
	{
		expect(runBlock).to.not.throwException();
	}
	
	public function expectException(runBlock:Void->Void, expectedException:Dynamic):Void
	{
		expect(runBlock).to.throwException(expectedException);
	}
}