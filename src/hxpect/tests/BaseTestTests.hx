package hxpect.tests;

import hxpect.core.Assert;
import hxpect.core.BaseTest;
import hxpect.core.ExpectAssertion;

class BaseTestTests extends BaseTest
{
	public function test_expectReturnsExpectAssert():Void
	{
		var actual = expect(20);
		
		Assert.assertNotNull(actual);
		Assert.assertTrue(Std.is(actual, ExpectAssertion));
	}
}