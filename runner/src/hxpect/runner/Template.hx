package hxpect.runner;

class Template
{
	
	public static function defineMain(directory:String, sourceFiles:Array<String>):String
	{
		var TAB = "\t";
		var NL = "\n";
		
		var importStatements:String = "";
		var registeredSpecFiles:String = "";
		var registeredTestFiles:String = "";
		
		for (file in sourceFiles)
		{
			if (file.indexOf("hxpect/core") != -1)
			{
				continue;
			}
			
			var className = getClassNameFor(file);
			if (className != null)
			{
				var addImport:Bool = false;
				if (className.toLowerCase().indexOf("spec") != -1)
				{
					registeredSpecFiles += TAB +TAB + 'specRunner.registerSpecClass(' + className + ');' + NL;
					addImport = true;
				}
				
				if (className.toLowerCase().indexOf("test") != -1)
				{
					registeredTestFiles += TAB +TAB + 'testRunner.registerTestClass(' + className + ');' + NL;
					addImport = true;
				}
				
				if (addImport)
				{
					var classPackage = getClassPackageFor(directory, file);
					if (classPackage != null)
					{
						importStatements += "import " +  classPackage + ";" + NL;
					}
				}
			}
		}
		
		var template:String = 'package hxpect;

import hxpect.core.SpecRunner;
import hxpect.core.TestRunner;

' + importStatements + '

class TempTestRunner 
{
	public static function main() 
	{
		var testRunner = new TestRunner();
		' + NL + registeredTestFiles + '
		testRunner.run();
		
		if (!testRunner.successful())
		{
			Sys.exit(1);
		}
		
		var specRunner = new SpecRunner();
		' + NL + registeredSpecFiles + '
		specRunner.run();
		
		if (!specRunner.successful())
		{
			Sys.exit(1);
		}
		
		Sys.exit(0);
	}
}
	';
	
		return template;
	
	}
	
	public static function getClassNameFor(file:String):Null<String>
	{
		var EXT = ".hx";
		
		try
		{
			if (StringTools.endsWith(file, EXT))
			{
				var splits = file.split("/");
				var file = splits[splits.length - 1];
				return StringTools.replace(file, EXT, "");
			}
		}
		catch (exception:Dynamic)
		{
			return null;
		}
		
		return null;
	}
	
	public static function getClassPackageFor(directory:String, file:String):Null<String>
	{
		var EXT = ".hx";
		
		file = StringTools.replace(file, directory + "/", "");
		
		try
		{
			if (StringTools.endsWith(file, EXT))
			{
				var splits = file.split("/");
				var file = splits[splits.length - 1];
				var packageString = splits.join(".");
				return StringTools.replace(packageString, EXT, "");
			}
		}
		catch (exception:Dynamic)
		{
			return null;
		}
		
		return null;
	}
	
}