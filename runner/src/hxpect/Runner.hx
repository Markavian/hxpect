package hxpect;

import hxpect.core.Logger;
import hxpect.runner.Compiler;
import hxpect.runner.Help;
import hxpect.runner.Utils;

class Runner
{
	var logger:Logger;
	var help:Help;
	var compiler:Compiler;
	
	var args:Array<String>;
	var workingPath:String;
	
	var sourceFolder:String;
	var testFolder:String;
	
	function new()
	{
		logger = new Logger();
		help = new Help(logger);
		compiler = new Compiler(logger);
	}
	
	function compileAndRun():Void
	{
		processArguments();
		tryToCompile();
		tryToRunTests();
	}
	
	function processArguments():Void
	{
		args = Sys.args();
		workingPath = Sys.getCwd();
		if (args.length > 0)
		{
			workingPath = args.pop();
		}
		
		sourceFolder = Utils.shiftArg(args, "src");
		testFolder = Utils.shiftArg(args, "src");
	}
	
	function tryToCompile():Void
	{		
		logger.logInfo("Arguments: " + args.join(" "));
		logger.logEmptyLine();
		
		logger.log("Building test runner:");
		try
		{
			compiler.setup(workingPath, sourceFolder, testFolder, args);
			compiler.buildTestRunner();
		}
		catch (exception:Dynamic)
		{
			logger.logWarning("Caught exception: " + Std.string(exception));
			help.displayHelp();
			Sys.exit(1);
		}
	}
	
	function tryToRunTests():Void
	{
		logger.log("Running test runner:");
		try
		{
			compiler.runTestsAndExit();
		}
		catch (exception:Dynamic)
		{
			logger.logWarning("Caught exception: " + Std.string(exception));
			help.displayHelp();
			Sys.exit(1);
		}
	}
	
	public static function run():Void
	{
		var instance = new Runner();
		
		instance.compileAndRun();
	}
	
	public static function main() 
	{
		Runner.run();
		
		Sys.exit(0);
	}
}