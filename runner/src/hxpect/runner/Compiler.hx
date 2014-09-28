package hxpect.runner;

import hxpect.core.Logger;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;

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
		
		var openflNativeBackendsLib = "-cp " + readHaxelibPathFor("openfl") + "/backends/native";
		
		var fileContents = ""
			+ "-cp " + binarySourcePath + NL
			+ "-cp " + sourcePath + " " + NL
			+ "-cp " + testPath + " " + NL
			+ NL
			+ "-main hxpect.TempTestRunner " + NL
			+ "-neko " + outputFilePath + NL
			+ NL
			+ hxpectLib
			+ "-lib openfl " + NL
			+ "-lib lime " + NL
			+ "-lib actuate " + NL
			+ openflNativeBackendsLib + NL
			+ NL
			+ "--remap flash:openfl " + NL;
			
		logger.logInfo("HXML File Contents:");
		logger.logInfo(fileContents);
		logger.logEmptyLine();
			
		writeStringToFile(fileContents, hxmlFilePath);
	}
	
	function readHaxelibPathFor(libraryName:String):String
	{
		var commandResult = runCommand("haxelib config");
		
		var haxelibPath = commandResult.result;
		var libraryDevPath = readFileContents(haxelibPath + libraryName + "/.dev");
		
		if (libraryDevPath != null)
		{
			return libraryDevPath;
		}
		else
		{
			var libraryCurrent = readFileContents(haxelibPath + libraryName + "/.current");
			var libraryFolder = StringTools.replace(libraryCurrent, ".", ",");
			var librayPath = haxelibPath + libraryName + "/" + libraryFolder;
			
			return librayPath;
		}
	}
	
	function readFileContents(filePath:String):String
	{
		if (FileSystem.exists(filePath))
		{
			var file = File.read(filePath);
			var contents = file.readAll().toString();
			file.close();
			
			return contents;
		}
		return null;
	}
	
	function compile():Void
	{
		logger.log("Compiling test runner: " + outputFilePath);
		
		var compileResult = runCommand("haxe " + hxmlFilePath);
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
		var sanitizedCommand = command;
		var sanitizedArgs = new Array<String>();
		
		// move args that exist in the command string into an args array
		var commandArgs = command.split(" ");
		if (commandArgs.length > 0)
		{
			sanitizedCommand = commandArgs[0];
			for (i in 1...commandArgs.length)
			{
				var commandArg = commandArgs[i];
				sanitizedArgs.push(commandArg);
			}
		}
		
		// stitch additional arts onto the end of the command args
		if (args != null)
		{
			for (arg in args)
			{
				sanitizedArgs.push(arg);
			}
		}
		
		// report about this action
		logger.logInfo(sanitizedCommand + " " + sanitizedArgs.join(" "));
		
		// do the thing, record the results
		var process = new Process(sanitizedCommand, sanitizedArgs);
		var exitCode = process.exitCode();
		var result = prettify(process.stdout.readAll().toString());
		var error = prettify(process.stderr.readAll().toString());
		process.close();
		
		// report about the result
		if (result.length > 0)
		{
			logger.log(result);
		}
		
		// report about any errors
		if (error.length > 0)
		{
			logger.logFail(error);
		}
		
		return new CommandResult(exitCode, result, error);
	}
	
	function prettify(string:String):String
	{
		string = StringTools.trim(string);
		string = StringTools.replace(string, "\r", "");
		
		return string;
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
	public var result(get, null):String;
	public var error(get, null):String;
	
	public function new(code:Int, result:String, error:String)
	{
		this.code = code;
		this.result = result;
		this.error = error;
	}
	
	function get_code():Int
	{
		return this.code;
	}
	
	function get_result():String
	{
		return this.result;
	}
	
	function get_error():String
	{
		return this.error;
	}
	
	public function ok():Bool
	{
		return (this.code == 0);
	}
}