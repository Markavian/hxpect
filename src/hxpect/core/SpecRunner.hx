package hxpect.core;
import hxpect.core.BaseSpec.DescribeStep;
import hxpect.core.BaseSpec.ShouldStep;

class SpecRunner
{
	private var logger:Logger;
	private var registeredSpecs:Array<Dynamic>;
	
	private var totalSpecCount:Int = 0;
	private var totalSuccessCount:Int = 0;
	
	private var classSpecCount:Int = 0;
	private var classSuccessCount:Int = 0;
	
	public function new()
	{
		// e.g. registerTestClass(CheckoutTest);
		
		logger = new Logger();
	}
	
	public function registerSpecClass(testClass:Class<Dynamic>):Void
	{
		if (registeredSpecs == null)
		{
			registeredSpecs = new Array<Dynamic>();
		}
		
		registeredSpecs.push(testClass);
	}
	
	public function run():Void
	{
		printTitle();
		
		for (testClass in registeredSpecs)
		{
			runSpecsOn(testClass);
		}
		
		specsComplete();
	}
	
	function printTitle():Void
	{
		logger.logInfo("Hxpect Spec Runner - specs initialised");
		logger.logInfo("Operating system: " + logger.systemName());
	}
	
	function runSpecsOn(specClass:Class<Dynamic>):Void
	{
		if (Type.getSuperClass(specClass) != BaseSpec)
		{
			logger.logEmptyLine();
			logger.log("Skipping non-spec class " + Type.getClassName(specClass));
			return;
		}
		
		classSpecCount = 0;
		classSuccessCount = 0;
		
		var instance:BaseSpec = Type.createEmptyInstance(specClass);
		runSpecs(instance, "run");
		
		logger.log("Specs passed: " + classSuccessCount + "/" + classSpecCount);
		
		totalSpecCount += classSpecCount;
		totalSuccessCount += classSuccessCount;
	}
	
	function runSpecs(instance:BaseSpec, specName:String):Void
	{
		var TAB = "\t";
		
		try
		{
			Reflect.callMethod(instance, Reflect.field(instance, specName), []);
			
			logger.logInfo("Running " + Type.getClassName(Type.getClass(instance)) + ":" + specName);
			
			for (spec in instance.specs)
			{
				var indent = makeIndent(spec.tabLevel());
				logger.log(indent + "+ " + spec.name);
				for (step in spec.steps)
				{
					classSpecCount++;
					instance.beforeStep();
					var success = runSpecStep(spec, step, indent);
					if (success)
					{
						classSuccessCount++;
					}
				}
			}
		}
		catch (exception:Dynamic)
		{
			logger.logFail("- Spec failed: " + specName + ", reason: " + exception);
		}
	}
	
	function makeIndent(tabLevel:Int):String
	{
		var TAB = "\t";
		
		var indent = "";
		for (i in 0...tabLevel)
		{
			indent = indent + TAB;
		}
		
		return indent;
	}
	
	function runSpecStep(spec:DescribeStep, step:ShouldStep, indent:String):Bool
	{
		var TAB = "\t";
		
		try
		{
			spec.beforeSteps();
			step.step();
		}
		catch (exception:Dynamic)
		{
			logger.logFail(indent + TAB + "- Failed: " + step.name + ", reason: " + exception);
			return false;
		}
		
		logger.logPass(indent + TAB + "+ " + step.name); 
		return true;
	}
	
	function specsComplete():Void
	{
		logger.logEmptyLine();
		logger.logInfo("Total specs passed: " + totalSuccessCount + "/" + totalSpecCount);
		if (successful())
		{
			logger.logPass("SUCCESS - All specs passed");
		}
		else
		{
			if (totalSuccessCount == 0)
			{
				logger.logFail("FAILIURE - No specs run");
			}
			else
			{
				logger.logFail("FAILIURE - " + failiures() + " specs failed");
			}
		}
		
		logger.logEmptyLine();
	}
	
	function failiures():Int
	{
		return (totalSpecCount - totalSuccessCount);
	}
	
	public function successful():Bool
	{
		return (failiures() == 0) && (totalSuccessCount > 0);
	}
}