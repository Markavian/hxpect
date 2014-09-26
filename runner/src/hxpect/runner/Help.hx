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
		logger.log(TAB + "Usage: haxelib run hxpect [source folder, default: src] [test folder, default: src] [-excludeHxpectLib] [additional args] [working directory]");
		logger.logEmptyLine();
		logger.logWarning(TAB + "You are seeing this message because hxpect failed to find or run any tests.");
		logger.logInfo(TAB + "Test files should extend hxpect.core.BaseTest or hxpect.core.BaseSpec.");
		logger.logEmptyLine();
		logger.logInfo(TAB + "Options:");
		logger.logInfo(TAB + TAB + "[0: source folder]  : the root directory for all your source files");
		logger.logInfo(TAB + TAB + "                      default value: src"); 
		logger.logInfo(TAB + TAB + "[1: test folder]    : the root directory for all your test cases");
		logger.logInfo(TAB + TAB + "                      default value: src"); 
		logger.logInfo(TAB + TAB + "[-excludeHxpectLib] : prevent -lib hxpect from being added to HXML");
		logger.logInfo(TAB + TAB + "                      used to self-test the hxpect library"); 
		logger.logInfo(TAB + TAB + "[-regen]            : force the HXML file to be regenerated");
		logger.logInfo(TAB + TAB + "[additional args]   : any extra args to be added to the HXML file"); 
		logger.logInfo(TAB + TAB + "[working directory] : optional - the base path to run from");
		logger.logInfo(TAB + TAB + "                      defaults to the current working directory"); 
		logger.logEmptyLine();
	}
}