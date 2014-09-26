package hxpect;

import hxpect.core.Logger;
import hxpect.runner.Compiler;
import hxpect.runner.Help;
import hxpect.runner.Utils;
import sys.FileSystem;

class Runner
{
	var logger:Logger;
	var help:Help;
	var compiler:Compiler;
	
	var args:Array<String>;
	var workingPath:String;
	
	var sourceFolder:String;
	var testFolder:String;
	var excludeHxpectLib:Bool;
	var regenerateHxml:Bool;
	
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
		
		if (args.remove("-excludeHxpectLib"))
		{
			excludeHxpectLib = true;
		}
		
		if (args.remove("-regen"))
		{
			regenerateHxml = true;
		}
		
		workingPath = Sys.getCwd();
		if (args.length > 0)
		{
			var lastArg = args.pop();
			if (FileSystem.exists(lastArg) && FileSystem.isDirectory(lastArg))
			{
				workingPath = lastArg;
			}
			else
			{
				args.push(lastArg);
			}
		}
		
		sourceFolder = Utils.shiftArg(args, "src");
		testFolder = Utils.shiftArg(args, "src");
	}
	
	function tryToCompile():Void
	{		
		logger.logInfo("Source folder: " + sourceFolder);
		logger.logInfo("Tests folder: " + testFolder);
		logger.logInfo("Additional arguments: " + args.join(" "));
		
		try
		{
			compiler.setup(workingPath, sourceFolder, testFolder, args);
			
			if (excludeHxpectLib)
			{
				logger.logInfo("Option enabled: Excluding hxpect lib from runner.");
				compiler.excludeHxpectLib();
			}
			
			if (regenerateHxml)
			{
				logger.logInfo("Option enabled: Regenerating HXML file.");
				compiler.regenerateHxmlFile();
			}
			
			logger.logEmptyLine();
			logger.log("Building test runner:");
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