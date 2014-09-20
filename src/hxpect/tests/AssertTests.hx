package hxpect.tests;

import hxpect.core.Assert;
import hxpect.core.BaseTest;

class AssertTests extends BaseTest
{
	public function test_assertTrue_shouldWork()
	{
		expect(function() {
			Assert.assertTrue(true);
		}).to.not.throwException();
	}
	
	public function test_assertTrue_shouldThrowAnException()
	{
		expect(function() {
			Assert.assertTrue(false);
		}).to.throwException("Actual value " + false + " should be true");
	}
	
	public function test_assertFalse_shouldWork()
	{
		expect(function() {
			Assert.assertFalse(false);
		}).to.not.throwException();
	}
	
	public function test_assertFalse_shouldThrowAnException()
	{
		expect(function() {
			Assert.assertFalse(true);
		}).to.throwException("Actual value " + true + " should be false");
	}
	
	public function test_assertEqual_shouldWork()
	{
		var expected:Dynamic = { };
		var actual:Dynamic = expected;
		
		expect(function() {
			Assert.assertEqual(expected, actual);
		}).to.not.throwException();
	}
	
	public function test_assertEqual_shouldThrowException()
	{
		var expected:Dynamic = 1;
		var actual:Dynamic = 2;
		
		expect(function() {
			Assert.assertEqual(expected, actual);
		}).to.throwException("Actual value " + actual + " should equal expected value " + expected);
	}
	
	public function test_assertNotEqual_shouldWork()
	{
		var expected:Dynamic = { };
		var actual:Dynamic = { };
		
		expect(function() {
			Assert.assertNotEqual(expected, actual);
		}).to.not.throwException();
	}
	
	public function test_assertNotEqual_shouldThrowAnException()
	{
		var expected:Dynamic = { };
		var actual:Dynamic = expected;
		
		expect(function() {
			Assert.assertNotEqual(expected, actual);
		}).to.throwException("Actual value " + actual + " should not equal expected value " + expected);
	}
	
	public function test_assertNull_shouldWork()
	{
		var actual = null;
		
		expect(function() {
			Assert.assertNull(actual);
		}).to.not.throwException();
	}
	
	public function test_assertNull_shouldThrowAnException()
	{
		var actual = "hello";
		
		expect(function() {
			Assert.assertNull(actual);
		}).to.throwException("Actual value " + actual + " should be null");
	}
	
	public function test_assertNotNull_shouldWork()
	{
		var actual = "goodbye";
		
		expect(function() {
			Assert.assertNotNull(actual);
		}).to.not.throwException();
	}
	
	public function test_assertNotNull_shouldThrowAnException()
	{
		var actual = null;
		
		expect(function() {
			Assert.assertNotNull(actual);
		}).to.throwException("Actual value " + actual + " should not be null");
	}
}