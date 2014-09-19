package hxpect.core;

class Logger
{
	public static inline var TEXT_PASS:String = "\033[32m";
	public static inline var TEXT_INFO:String = "\033[36m";
	public static inline var TEXT_WARNING:String = "\033[33m";
	public static inline var TEXT_FAIL:String = "\033[31m";
	public static inline var TEXT_RESET:String = "\033[0m";
	
	var logFunction:String->Void;
	var operatingSystem:String;
	
	public function new()
	{
		logFunction = Sys.println;
		operatingSystem = Sys.systemName();
	}
	
	public function setLogger(logFunction:String->Void):Void
	{
		this.logFunction = logFunction;
	}
	
	public function setOperatingSystem(operatingSystem:String):Void
	{
		this.operatingSystem = operatingSystem;
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
		if (this.operatingSystem == "Windows")
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
		logFunction(message);
	}
	
}