package hxpect.tests;

import hxpect.core.BaseTest;
import hxpect.core.Logger;

class LoggerTests extends BaseTest
{
	var logger:Logger;
	var actual:String;
	
	public function beforeEach()
	{
		logger = new Logger();
		logger.setLogger(function(message:String) {
			actual = message;
		});
	}
	
	public function test_log()
	{
		var expected = "Some message";
		
		logger.log(expected);
		
		expect(actual).to.be(expected);
	}
	
	public function test_logColor_onWindows()
	{
		var color = "RED";
		var message = "Another message";
		var expected = message;
		
		logger.setOperatingSystem("Windows");
		logger.logColor(message, color);
		
		expect(actual).to.be(expected);
	}
	
	public function test_logColor_onNonWindows()
	{
		var color = "RED";
		var reset = Logger.TEXT_RESET;
		var message = "Yet another message";
		var expected = color + message + reset;
		
		logger.setOperatingSystem("Mac OSX");
		logger.logColor(message, color);
		
		expect(actual).to.be(expected);
	}
	
	public function test_shouldFail()
	{
		// temporary test to check that CI correctly fails
		expect(true).to.be(false);
	}
}