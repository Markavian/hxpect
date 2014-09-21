package hxpect.specs;

import hxpect.core.BaseSpec;

class BaseSpecSpecs extends BaseSpec
{
	override public function run()
	{
		describe("An empty describe block", function()
		{
			expect(specs[0].name).to.be("An empty describe block");
		});
		
		describe("Using the it block", function()
		{
			var x = 0;
			
			it("should register a new step", function()
			{
				x++;
				expect(specs[1].name).to.be("Using the it block");
				expect(specs[1].steps[0].name).to.be("should register a new step");
				expect(x).to.be(1);
			});
		});
		
		describe("Using the beforeEach block", function()
		{
			var x = 0;
			beforeEach(function()
			{
				x++;
			});
			
			it("should call the before each block before each test", function()
			{ 
				expect(x).to.be(1);
			});
		});
		
		describe("A full spec", function()
		{
			var x = 0;
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
		
		describe("A nested spec", function()
		{
			var x = 0;
			var y = 0;
			
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
	}
}