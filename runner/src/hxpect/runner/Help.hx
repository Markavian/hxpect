package hxpect.runner;
import hxpect.core.Logger;

class Help
{
	var logger:Logger;

	public function new(logger:Logger) 
	{
		this.logger = logger;
	}
	
	public function displayHelp()
	{
		var TAB = "  ";
		
		logger.log("Hxpect Test Harness - Help - https://github.com/Markavian/hxpect");
		logger.log(TAB + "Usage: haxelib run hxpect [source folder, default: src] [test folder, default: src] [additional args]");
		logger.logEmptyLine();
		logger.logWarning(TAB + "You are seeing this message because hxpect failed to find or run any tests.");
		logger.logInfo(TAB + "Test files should extend hxpect.core.BaseTest or hxpect.core.BaseSpec.");
		logger.logEmptyLine();
		logger.logInfo(TAB + "Options:");
		logger.logInfo(TAB + TAB + "[test folder] : the root directory for all your test cases");
		logger.logInfo(TAB + TAB + "                default value is the current directory"); 
		logger.logEmptyLine();
	}
}