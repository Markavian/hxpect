package hxpect.tests;

import hxpect.core.Assert;
import hxpect.core.BaseTest;

class AssertTests extends BaseTest
{
	public function test_assertTrue_shouldWork()
	{
		expectNoExceptions(function() {
			Assert.assertTrue(true);
		});
	}
	
	public function test_assertTrue_shouldThrowAnException()
	{
		expectException(function() {
			Assert.assertTrue(false);
		}, "Actual value " + false + " should be true");
	}
	
	public function test_assertFalse_shouldWork()
	{
		expectNoExceptions(function() {
			Assert.assertFalse(false);
		});
	}
	
	public function test_assertFalse_shouldThrowAnException()
	{
		expectException(function() {
			Assert.assertFalse(true);
		}, "Actual value " + true + " should be false");
	}
	
	public function test_assertEqual_shouldWork()
	{
		var expected:Dynamic = { };
		var actual:Dynamic = expected;
		
		expectNoExceptions(function() {
			Assert.assertEqual(expected, actual);
		});
	}
	
	public function test_assertEqual_shouldThrowException()
	{
		var expected:Dynamic = 1;
		var actual:Dynamic = 2;
		
		expectException(function() {
			Assert.assertEqual(expected, actual);
		}, "Actual value " + actual + " should equal expected value " + expected);
	}
	
	public function test_assertNotEqual_shouldWork()
	{
		var expected:Dynamic = { };
		var actual:Dynamic = { };
		
		expectNoExceptions(function() {
			Assert.assertNotEqual(expected, actual);
		});
	}
	
	public function test_assertNotEqual_shouldThrowAnException()
	{
		var expected:Dynamic = { };
		var actual:Dynamic = expected;
		
		expectException(function() {
			Assert.assertNotEqual(expected, actual);
		}, "Actual value " + actual + " should not equal expected value " + expected);
	}
	
	public function test_assertNull_shouldWork()
	{
		var actual = null;
		
		expectNoExceptions(function() {
			Assert.assertNull(actual);
		});
	}
	
	public function test_assertNull_shouldThrowAnException()
	{
		var actual = "hello";
		
		expectException(function() {
			Assert.assertNull(actual);
		}, "Actual value " + actual + " should be null");
	}
	
	public function test_assertNotNull_shouldWork()
	{
		var actual = "goodbye";
		
		expectNoExceptions(function() {
			Assert.assertNotNull(actual);
		});
	}
	
	public function test_assertNotNull_shouldThrowAnException()
	{
		var actual = null;
		
		expectException(function() {
			Assert.assertNotNull(actual);
		}, "Actual value " + actual + " should not be null");
	}
}