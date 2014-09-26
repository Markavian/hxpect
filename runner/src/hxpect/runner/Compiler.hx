package hxpect.runner;

import hxpect.core.Logger;
import sys.FileSystem;
import sys.io.File;

class Compiler
{
	var logger:Logger;
	
	public function new(logger:Logger) 
	{
		this.logger = logger;
	}
	
	private var flagIncludeHxpectLib:Bool;
	private var flagRegenerateHxmlFile:Bool;
	
	private var workingPath:String;
	private var sourcePath:String;
	private var testPath:String;
	private var additionalArgs:Array<String>;
	
	private var binarySourcePath:String;
	private var mainFilePath:String;
	private var hxmlFilePath:String;
	private var outputFilePath:String;
	
	public function setup(workingPath:String, sourceDirectory:String, testDirectory:String, additionalArgs:Array<String>):Void
	{
		this.flagIncludeHxpectLib = true;
		
		this.workingPath = workingPath;
		this.sourcePath = workingPath + sourceDirectory;
		this.testPath = workingPath + testDirectory;
		this.additionalArgs = additionalArgs;
		
		this.binarySourcePath = workingPath + "bin/temp";
		this.mainFilePath = binarySourcePath + "/hxpect/TempTestRunner.hx";
		this.hxmlFilePath = binarySourcePath + "/tests.hxml";
		this.outputFilePath = binarySourcePath + "/tests.n";
	}
	
	public function excludeHxpectLib()
	{
		this.flagIncludeHxpectLib = false;
	}
	
	public function regenerateHxmlFile()
	{
		this.flagRegenerateHxmlFile = true;
	}
	
	public function buildTestRunner()
	{
		checkSourcePaths();
		createDirectories();
		createMainFile();
		createHxmlFile();
		
		compile();
	}
	
	function checkSourcePaths():Void
	{
		logger.logInfo("Working path: " + workingPath);
		
		if (!FileSystem.exists(sourcePath))
		{
			throw "Source path does not exist: " + sourcePath;
		}
		
		if (!FileSystem.exists(testPath))
		{
			throw "Test path does not exist: " + testPath;
		}
	}
	
	function createDirectories():Void
	{
		FileSystem.createDirectory(binarySourcePath);
		FileSystem.createDirectory(binarySourcePath + "/hxpect");
	}
	
	function createMainFile():Void
	{
		logger.logInfo("Generating Test Runner class: " + mainFilePath);
		
		var sourceFiles = listFiles(testPath);
		var mainFileContents = Template.defineMain(testPath, sourceFiles);
		
		writeStringToFile(mainFileContents, mainFilePath);
		
		logger.logEmptyLine();
	}
	
	function createHxmlFile():Void
	{		
		if (FileSystem.exists(hxmlFilePath))
		{
			if (flagRegenerateHxmlFile)
			{
				logger.logInfo("Regenerating HXML File, overwriting existing file: " + hxmlFilePath);
			}
			else
			{
				logger.logWarning("HXML File already exists at " + hxmlFilePath + "\n - edit this file to suit your needs, or delete to regenerate.");
				return;
			}
		}
		
		var NL = "\n";
		
		var hxpectLib:String = (flagIncludeHxpectLib) ? "-lib hxpect " + NL : "";
		
		var fileContents = ""
			+ "-cp " + binarySourcePath + NL
			+ "-cp " + sourcePath + " " + NL
			+ "-cp " + testPath + " " + NL
			+ NL
			+ "-main hxpect.TempTestRunner " + NL
			+ NL
			+ hxpectLib
			+ "-lib openfl " + NL
			+ "--remap flash:openfl " + NL
			+ "-lib actuate " + NL
			+ "-neko " + outputFilePath;
		
		logger.logInfo("HXML File Contents:");
		logger.logInfo(fileContents);
		logger.logEmptyLine();
			
		writeStringToFile(fileContents, hxmlFilePath);
	}
	
	function compile():Void
	{
		logger.log("Compiling test runner: " + outputFilePath);
		var compileResult = runCommand("haxe " + hxmlFilePath, additionalArgs);
		if (!compileResult.ok())
		{
			Sys.exit(compileResult.code);
		}
		logger.logEmptyLine();
	}
	
	public function runTestsAndExit():Void
	{
		var testResult = runCommand("neko " + outputFilePath);
		
		Sys.exit(testResult.code);
	}
	
	function writeStringToFile(contents:String, filePath:String):Void
	{
		var file = File.write(filePath);
		file.writeString(contents);
		file.close();
	}
	
	function runCommand(command:String, ?args:Array<String>):CommandResult
	{
		var argsString = (args == null) ? "" : " " + args.join(" ");
		logger.logInfo(command + argsString);
		var resultCode = Sys.command(command, args);
		
		return new CommandResult(resultCode);
	}
	
	function listFiles(directory:String, ?appendTo:Array<String>):Array<String>
	{
		if (appendTo == null)
		{
			appendTo = new Array<String>();
		}
		
		logger.logInfo("Listing files from: " + directory);
		if (!FileSystem.exists(directory))
		{
			throw "Directory does not exist: " + directory;
		}
		
		var files = FileSystem.readDirectory(directory);
		for (file in files)
		{
			var path = directory + "/" + file;
			if (FileSystem.isDirectory(path))
			{
				listFiles(path, appendTo);
			}
			
			appendTo.push(path);
		}
		
		return appendTo;
	}
	
}

class CommandResult
{
	public var code(get, null):Int;
	
	public function new(code:Int)
	{
		this.code = code;
	}
	
	function get_code():Int
	{
		return this.code;
	}
	
	public function ok():Bool
	{
		return (this.code == 0);
	}
}