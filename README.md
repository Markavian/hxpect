hxpect
======

Haxe based test framework for writing tests in a more natural language kind of way.

It includes hx source files for writing tests, assertions and expectations.

Hxpect currently only supports Haxe 3.

Installation
------------

To install you must have [Haxe](http://www.haxe.org) installed

Then just use haxelib to download the latest version

	haxelib install hxpect

Running Tests
-------------

	haxelib run hxpect
	
By default haxelib assumes your source code and tests live in a src/ folder. You can use this command as part of CI or as a pre-build command in your IDE.

Features
--------

### Cross Platform

Hxpect should work with any haxe project, although specifically it was designed for [OpenFL projects](http://www.openfl.org). 

### Expectations

Hxpect allows tests to be written in the form:
```haxe	
	expect(actual).to.be(expected);
	expect(actual).to.not.be(expected);

	expect(method).to.throwException();
	expect(method).to.throwException(specificException);
	
	expect(method).to.not.throwException();
	expect(method).to.not.throwException(specificException);
	
	expect(actual).to.beOfType(ExpectedType);
	expect(actual).to.not.beOfType(UnexpectedType);
	
	expect(actual).to.beNull();
	expect(actual).to.not.beNull();
```	
The reverse form of not works as well:
```haxe	
	expect(actual).to.be(expected);
	expect(actual).not.to.be(expected);
	expect(actual).to.not.be(expected);
```	
### Specs or Tests
	
You can either extend from BaseTest, and write XUnit style tests, or extend from BaseSpec, and write nested specs, depending on your familiarity with each style.

### Test reports

The default runners produce readable test reports to help you debug. They can also be written to fail with a non-zero error code, and baked in as a pre-compile step to your projects. 

Examples
--------

### Test Class Example

An example test class:
```haxe
	import hxpect.core.BaseTest;

	class ProjectTests extends BaseTest 
	{
		var thingUnderTest:SomeType;
		public function beforeEach():Void
		{
			thingUnderTest = new SomeType();
		}
		
		public function test_myTest():Void
		{
			var expected = "expected result";
			var actual = thingUnderTest.someResult();
			
			expect(actual).to.be(expected);
		}
	}
```
Currently tests must extend from BaseTest and are recognised from each class if they begin with "test_". Tests are attempted to be run in isolation by creating a new object instance for each test execution, and beforeEach and afterEach steps are ran if found.

### Spec Class Example

An example spec class:
```haxe	
	import hxpect.core.BaseSpec;
	
	class ProjectSpecs extends BaseSpec 
	{
		override public function run():Void
		{
			var thingUnderTest:SomeType;
			
			beforeEach(function()
			{
				thingUnderTest = new SomeType();
			});
			
			describe("Some feature", function()
			{
				it("should produce the correct result", function()
				{
					var expected = "expected result";
					var actual = thingUnderTest.someResult();
					
					expect(actual).to.be(expected);
				});
			});
		}
	}
```	
Current specs must extend from BaseSpec and override the run method. Spec files are run in isolation, but because of the nesting and hierarchy, some shared state may occur depending on how you structure the file.
	
The main advantage of using the spec style of tests is that it produces a more readable test report, and encourages concise naming of tests around specific features.
	
### Assertions

Underlying the fluid expect calls are basic assertions that will throw exceptions, for example:
```haxe	
	Assert.isTrue(value);
	Assert.isFalse(value);
	
	Assert.isEqual(expected, actual);
	Assert.isNotEqual(expected, actual);
	
	Assert.isNull(value);
	Assert.isNotNull(value)
```
### Test Runner and Spec Runner

To run tests on your project, put your BaseTest or BaseSpec files with your source code and run:

	haxelib run hxpect
	
By default, hxpect will look in the src/ folder and attempt to run all those tests.

To customise the source path, add a parameter:

	haxelib run source/code/path
	
If you want to organise your code to be in one place, and tests in another, add a second parameter:

	haxelib run source/code/path test/code/path
	
You can pass in additional compiler flags on the command line, and use the -regen flag to force tests.hxml to be regenerated every time, like so:

	haxelib run -regen -lib myhaxelib
	

### Sample Test Runner Report

	Hxpect Test Runner - tests initialised
	Operating system: Mac

	Running tests on hxpect.tests.AssertTests
	+ Test passed: test_assertNull_shouldWork
	+ Test passed: test_assertEqual_shouldThrowException
	+ Test passed: test_assertEqual_shouldWork
	+ Test passed: test_assertNull_shouldThrowAnException
	+ Test passed: test_assertNotNull_shouldWork
	+ Test passed: test_assertTrue_shouldThrowAnException
	+ Test passed: test_assertNotEqual_shouldThrowAnException
	+ Test passed: test_assertTrue_shouldWork
	+ Test passed: test_assertNotNull_shouldThrowAnException
	+ Test passed: test_assertNotEqual_shouldWork
	+ Test passed: test_assertFalse_shouldWork
	+ Test passed: test_assertFalse_shouldThrowAnException
	Tests passed: 12/12

	Running tests on hxpect.tests.ExpectAssertionTests
	+ Test passed: test_expectToThrowException_shouldCatchAnyException
	+ Test passed: test_expectToReturnsExpectAssert
	+ Test passed: test_expectToBeNull_shouldWork
	+ Test passed: test_expectToBe_shouldThrowAnException
	+ Test passed: test_expectToThrowException_shouldCatchException
	+ Test passed: test_expectNotReturnsExpectAssert
	+ Test passed: test_expectToNotThrowException_shouldCatchAnyException
	+ Test passed: test_expectToBe_shouldWork
	+ Test passed: test_expectToNotThrowException_shouldCatchASpecificException
	+ Test passed: test_expectToNotBe_shouldWork
	+ Test passed: test_expectToNotThrowException_shouldIgnoreExceptionsThatDontMatch
	+ Test passed: test_expectToNotBe_shouldThrowAnException
	+ Test passed: test_expectToBeNull_shouldThrowAnException
	Tests passed: 13/13

	Total tests passed: 25/25
	SUCCESS - All tests passed

### Sample Spec Runner Report

	Hxpect Spec Runner - specs initialised
	Operating system: Windows
	Running hxpect.specs.BaseSpecSpecs:run
	+ An empty describe block
	+ Using the it block
		+ should register a new step
	+ Using the beforeEach block
		+ should call the before each block before each test
	+ A full spec
		+ should process beforeEach, and then run the first spec
		+ should process beforeEach, and then run the second spec
	+ A nested spec
		+ should run a spec in isolation
		+ should run specs defined after nested steps in isolation
		+ The nested part
			+ should also be run in isolation
	+ Every describe block
		+ should run the beforeEach method
	Specs passed: 8/8

	Total specs passed: 8/8
	SUCCESS - All specs passed
	
Plans for future
----------------

See [tasklist.md](https://github.com/Markavian/hxpect/blob/master/tasklist.md) for a list of planned features and wishlist items.
	
Release notes
-------------

See the [hxpect lib](http://lib.haxe.org/p/hxpect) on haxelib.org for a full lis of release notes.

Other haxe based test frameworks
---------------------

You may also be interested in:
+ MassiveUnit - https://github.com/massiveinteractive/MassiveUnit
+ Buddy - https://github.com/ciscoheat/buddy
+ Hxunit - https://code.google.com/p/hxunit
