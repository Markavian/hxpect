package hxpect.core;
import hxpect.core.BaseSpec.DescribeStep;

class BaseSpec
{
	public var beforeStep:Void->Void; 
	public var specs:Array<DescribeStep>;
	
	private var currentSpec:DescribeStep;
	
	public function run():Void
	{
		var NL = "\n";
		var TAB = "\t";
		var exception = "Run method not implemented:" + NL
			+ "Add the following to " + Type.getClassName(Type.getClass(this)) + ":" + NL
			+ TAB + 'override public function run() {' + NL
			+ TAB + TAB + 'describe("My feature", function() {' + NL
			+ TAB + TAB + TAB + 'it("should evaluate true to be true", function() {' + NL
			+ TAB + TAB + TAB + TAB + 'expect(true).to.be(false);' + NL
			+ TAB + TAB + TAB + '});' + NL
			+ TAB + TAB + '});' + NL
			+ TAB + '}' + NL;
			
		throw exception;
	}
	
	function describe(feature:String, spec:Void->Void):Void
	{
		if (specs == null)
		{
			specs = new Array<DescribeStep>();
		}
		
		var previousSpec = currentSpec;
		
		// create and register spec
		currentSpec = new DescribeStep(feature);
		currentSpec.setParent(previousSpec);
		specs.push(currentSpec);
		spec();
		
		currentSpec = previousSpec;
	}
	
	function beforeEach(testBlock:Void->Void):Void
	{
		Assert.assertNotNull(testBlock);
		
		if (currentSpec == null)
		{
			beforeStep = testBlock;
		}
		else
		{
			currentSpec.setBeforeStep(testBlock);
		}
	}
	
	function it(should:String, testBlock:Void->Void):Void
	{
		Assert.assertNotNull(currentSpec);
		
		var test = new ShouldStep(should, testBlock);
		currentSpec.steps.push(test);
	}
	
	function expect(actualValue:Dynamic):ExpectAssertion
	{
		return new ExpectAssertion(actualValue);
	}
}

class ShouldStep
{
	public var name:String;
	public var step:Void->Void;
	
	public function new(name:String, step:Void->Void)
	{
		this.name = name;
		this.step = step;
	}
}

class DescribeStep
{
	public var name:String;
	public var steps:Array<ShouldStep>;
	
	private var parent:DescribeStep;
	private var beforeStep:Void->Void;
	
	public function new(name:String)
	{
		this.name = name;
		this.beforeStep = function() { };
		this.steps = new Array<ShouldStep>();
	}
	
	public function setBeforeStep(step:Void->Void):Void
	{
		this.beforeStep = step;
	}
	
	public function setParent(parent:DescribeStep):Void
	{
		this.parent = parent;
	}
	
	public function beforeSteps():Void
	{
		if (parent != null)
		{
			parent.beforeSteps();
		}
		
		this.beforeStep();
	}
	
	public function tabLevel():Int
	{
		if (parent == null)
		{
			return 0;
		}
		else
		{
			return parent.tabLevel() + 1;
		}
	}
}