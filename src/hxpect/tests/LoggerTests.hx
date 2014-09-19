package hxpect.tests;

import hxpect.core.BaseTest;
import hxpect.core.Logger;

class LoggerTests extends BaseTest
{
	public function test_log()
	{
		var logger = new Logger();
		
		var expected = "Some message";
		var actual:String;
		logger.setLogger(function(message:String) {
			actual = message;
		});
		
		logger.log(expected);
		expect(actual).to.be(expected);
	}
	
	public function test_logColor_onWindows()
	{
		var logger = new Logger();
		
		var color = "RED";
		var message = "Another message";
		var expected = message;
		var actual:String;
		
		logger.setOperatingSystem("Windows");
		logger.setLogger(function(message:String) {
			actual = message;
		});
		
		logger.logColor(message, color);
		expect(actual).to.be(expected);
	}
	
	public function test_logColor_onNonWindows()
	{
		var logger = new Logger();
		
		var color = "RED";
		var reset = Logger.TEXT_RESET;
		var message = "Another message";
		var expected = color + message + reset;
		var actual:String;
		
		logger.setOperatingSystem("Mac OSX");
		logger.setLogger(function(message:String) {
			actual = message;
		});
		
		logger.logColor(message, color);
		expect(actual).to.be(expected);
	}
}