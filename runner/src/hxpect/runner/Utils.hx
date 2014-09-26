package hxpect.runner;

class Utils
{
	public static function shiftArg(args:Array<String>, defaultValue:String):String
	{
		if (args != null && args.length > 0)
		{
			return args.shift();
		}
		
		return defaultValue;
	}
}