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

Features
--------

### Cross Platform

Hxpect should work with any haxe project, specifically for OpenFL projects - see http://www.openfl.org

### Expectations

Hxpect allows tests to be written in the form:
	
	expect(actual).to.be(expected);
	expect(actual).to.not.be(expected);
	
	expectNoExceptions(methodUnderTest)
	expectException(methodUnderTest, "Value out of bounds exception")
	
### Example

An example test class
	
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

### Assertions

Underlying the fluid expect calls are basic assertions that will throw exceptions, for example:
	
	Assert.isTrue(value);
	Assert.isFalse(value);
	Assert.isNull(value);
	Assert.isNotNull(value)
	

### Test Runner

At present, test classes must be manually added to a compiled runner. Such a program might look like:
	
	class Main 
	{
		static function main() 
		{
			var testRunner = new TestRunner();
			testRunner.registerTestClass(AssertTests);
			testRunner.registerTestClass(BaseTestTests);
			testRunner.registerTestClass(ExpectAssertionTests);
			testRunner.registerTestClass(LoggerTests);
			testRunner.run();
			
			var successful = (testRunner.failiures() == 0);
			
			Sys.exit(successful ? 0 : 1);
		}
	}
	
Currently tests are recognised from each class if they begin with "test_". Tests are attempted to be run in isolation by creating a new object instance for each test execution, and beforeEach and afterEach steps are ran if found.
 	
The above program can be compiled and run with the command:
	
	haxe  -cp ../src -neko ../bin/HxpectTests.n -main "hxpect.tests.Main"
	cd bin
	neko HxpectTests.n
	
Plans for future
----------------

See tasklist.md at https://github.com/Markavian/hxpect/blob/master/tasklist.md
	
Release notes
-------------

### 0.0.2
- Working set of tests, ready for inclusion in to an external project.
	
