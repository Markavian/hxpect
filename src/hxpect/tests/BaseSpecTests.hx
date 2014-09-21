package hxpect.tests ;

import hxpect.core.BaseSpec;

class BaseSpecTests extends BaseSpec
{
	public function test_describe():Void
	{
		describe("An empty describe block", function()
		{
			expect(specs[0].name).to.be("An empty describe block");
		});
		
		evaluate();
	}
	
	public function test_it():Void
	{
		var x = 0;
		describe("Using the it block", function()
		{
			it("should register a new step", function()
			{
				x++;
				expect(specs[0].name).to.be("Using the it block");
				expect(specs[0].steps[0].name).to.be("should register a new step");
				expect(x).to.be(1);
			});
		});
		
		evaluate();
	}
	
	public function test_beforeEach():Void
	{
		var x = 0;
		describe("Using the beforeEach block", function()
		{
			beforeEach(function()
			{
				x++;
			});
			
			it("should call the before each block before each test", function()
			{ 
				expect(x).to.be(1);
			});
		});
		
		expect(x).to.be(0);
		
		evaluate();
		
		expect(x).to.be(1);
	}
	
	public function test_fullDescription():Void
	{
		var x = 0;
		describe("A full spec", function()
		{
			beforeEach(function()
			{
				x = 0;
			});
			
			it("should process beforeEach, and then run the first spec", function()
			{
				x = x + 1;
				expect(x).to.be(1);
			});
			
			it("should process beforeEach, and then run the second spec", function()
			{
				x = x + 2;
				expect(x).to.be(2);
			});
		});
		
		evaluate();
		
		expect(x).to.be(2);
	}
	
	public function test_nestedSpecs()
	{
		var x = 0;
		var y = 0;
			
		describe("A nested spec", function()
		{
			beforeEach(function()
			{
				x = 1;
				y = 1;
			});
			
			it("should run a spec in isolation", function()
			{
				x++;
				y++;
				expect(x).to.be(2);
				expect(y).to.be(2);
			});
			
			describe("The nested part", function()
			{
				beforeEach(function()
				{
					x = 2;
				});
				
				it("should also be run in isolation", function()
				{
					x = x + y;
					expect(x).to.be(3);
				});
			});
			
			it("should run specs defined after nested steps in isolation", function()
			{
				x = x + 2;
				y = y + 2;
				expect(x).to.be(3);
				expect(y).to.be(3);
			});
		});
		
		expect(specs.length).to.be(2);
		expect(specs[0].steps.length).to.be(2);
		expect(specs[1].steps.length).to.be(1);
		
		expect(specs[1].tabLevel()).to.be(1);
		
		evaluate();
	}
	
	public function test_beforeEach_describeBlock()
	{
		var x = 0;
		beforeEach(function()
		{
			x = 100;
		});
		
		describe("Every describe block", function()
		{
			it("should run the beforeEach method", function()
			{
				expect(x).to.be(100);
			});
		});
		
		evaluate();
	}
	
	function evaluate():Void
	{
		for (spec in specs)
		{
			for (step in spec.steps)
			{
				if (beforeStep != null)
				{
					beforeStep();
				}
				
				spec.beforeSteps();
				step.step();
			}
		}
	}
}