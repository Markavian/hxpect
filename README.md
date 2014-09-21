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

Hxpect should work with any haxe project, although specifically it was designed for [OpenFL projects](http://www.openfl.org). 

### Expectations

Hxpect allows tests to be written in the form:
	
	expect(actual).to.be(expected);
	expect(actual).to.not.be(expected);

	expect(method).to.throwException();
	expect(method).to.throwException(specificException);
	
	expect(method).to.not.throwException();
	expect(method).to.not.throwException(specificException);
	
### Specs or Tests
	
You can either extend from BaseTest, and write XUnit style tests, or extend from BaseSpec, and write nested specs, depending on your familiarity with each style.

### Test Class Example

An example test class:

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

Currently tests must extend from BaseTest and are recognised from each class if they begin with "test_". Tests are attempted to be run in isolation by creating a new object instance for each test execution, and beforeEach and afterEach steps are ran if found.

### Spec Class Example

An example spec class:
	
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
	
Current specs must extend from BaseSpec and override the run method. Spec files are run in isolation, but because of the nesting and hierarchy, some shared state may occur depending on how you structure the file.
	
The main advantage of using the spec style of tests is that it produces a more readable test report, and encourages concise naming of tests around specific features.
	
### Assertions

Underlying the fluid expect calls are basic assertions that will throw exceptions, for example:
	
	Assert.isTrue(value);
	Assert.isFalse(value);
	
	Assert.isEqual(expected, actual);
	Assert.isNotEqual(expected, actual);
	
	Assert.isNull(value);
	Assert.isNotNull(value)

### Test Runner and Spec Runner

At present, test classes must be manually added to a compiled runner.
As such, the main program for a BaseTest runner might look like:
	
	class Main 
	{
		static function main() 
		{
			var testRunner = new TestRunner();
			testRunner.registerTestClass(AssertTests);
			testRunner.registerTestClass(BaseTestTests);
			testRunner.registerTestClass(BaseSpecTests);
			testRunner.registerTestClass(ExpectAssertionTests);
			testRunner.registerTestClass(LoggerTests);
			testRunner.run();
			
			var successful = testRunner.successful();
			
			#if (flash || html5)
				var result = (successful) ? "Success" : "Failed";
				trace("Test runner: " + result);
			#else
				Sys.exit(successful ? 0 : 1);
			#end
		}
	}
	
The main class for a BaseSpec runner might look like:
	
	class Main 
	{
		static function main() 
		{
			var specRunner = new SpecRunner();
			specRunner.registerSpecClass(BaseSpecSpecs);
			specRunner.run();
			
			var successful = specRunner.successful();
			
			#if (flash || html5)
				var result = (successful) ? "Success" : "Failed";
				trace("Test runner: " + result);
			#else
				Sys.exit(successful ? 0 : 1);
			#end
		}
	}
	 	
The above program examples can be compiled and run with the command:
	
	haxe  -cp src -neko bin/HxpectTests.n -main "hxpect.tests.Main"
	neko bin/HxpectTests.n
	
Plans for future
----------------

See tasklist.md at https://github.com/Markavian/hxpect/blob/master/tasklist.md
	
Release notes
-------------

### 0.0.3
- Updated readme.md to include better information about project.

### 0.0.2
- Working set of tests, ready for inclusion in to an external project.
	
