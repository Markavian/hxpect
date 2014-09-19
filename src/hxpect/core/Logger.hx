package hxpect.core;

class Logger
{
	static inline var TEXT_PASS:String = "\033[32m";
	static inline var TEXT_INFO:String = "\033[36m";
	static inline var TEXT_WARNING:String = "\033[33m";
	static inline var TEXT_FAIL:String = "\033[31m";
	static inline var TEXT_RESET:String = "\033[0m";
	
	public function new()
	{
		
	}
	
	public function logPass(message:String):Void
	{
		logColor(message, TEXT_PASS);
	}
	
	public function logFail(message:String):Void
	{
		logColor(message, TEXT_FAIL);
	}
	
	public function logWarning(message:String):Void
	{
		logColor(message, TEXT_WARNING);
	}
	
	public function logInfo(message:String):Void
	{
		logColor(message, TEXT_INFO);
	}
	
	public function logColor(message:String, textColor:String):Void
	{
		if (Sys.systemName() == "Windows")
		{
			log(message);
		}
		else
		{
			log(textColor + message + TEXT_RESET);
		}
	}
	
	public function logEmptyLine():Void
	{
		log("");
	}
	
	public function log(message:String)
	{
		Sys.println(message);
	}
	
}