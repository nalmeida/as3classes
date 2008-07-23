package  as3classes.util {
	
	/**
	* DevUtil. Some utilities for development
	* @author Marcelo Miranda Carneiro
	*/
	public class DevUtil {
		
		public static function testRequiredParams($arguments:Object, $requiredArguments:Array, $errorMessage:String = null):void {
			
			$arguments = ($arguments == null) ? { } : $arguments;
			
			var i:int;
			var errorMessage:String = ($errorMessage != null) ? $errorMessage : "The parameter \"{param}\" is required!";
			for (i = 0; i < $requiredArguments.length; i++) {
				if ($arguments[$requiredArguments[i]] == null) {
					throw new Error(errorMessage.replace(/{param}/, $requiredArguments[i]));
				}
			}
		}
		public static function testAvailableParams($arguments:Object, $availableArguments:Array, $errorMessage:String = null):void {
			
			$arguments = ($arguments == null) ? { } : $arguments;
			
			var i:String;
			var errorMessage:String = ($errorMessage != null) ? $errorMessage : "The parameter \"{param}\" is not listed in the available parameters!";
			for (i in $arguments) {
				if ($availableArguments.indexOf(i) < 0) {
					throw new Error(errorMessage.replace(/{param}/, i));
				}
			}
		}

		public static function addParams($arguments:Object, $objectToAdd:Object = null, $availableArguments:Array = null, $requiredArguments:Array = null, $errorMessage:String = null):void {
			
			if ($objectToAdd == null || ($availableArguments == null && $requiredArguments == null)){
				throw new Error(DevUtil + ": Missing arguments. $objectToAdd is required; $availableArguments OR $requiredArguments is required.");
			}
			
			if($availableArguments != null)
				testAvailableParams($arguments, $availableArguments, $errorMessage);
			if($requiredArguments != null)
				testRequiredParams($arguments, $requiredArguments, $errorMessage);
			
			var i:String;
			for (i in $arguments) {
				$objectToAdd[i] = $arguments[i];
			}
		}
		
		/**
		 * Generate dots or any other letter pattenr based on a number that substract the string length.
		 * DevUtil.generateDots('carneiro', 30) will generate:
		 * DevUtil.generateDots('teste', 30) will generate:
		 * carneiro...................... (22 dots)
		 * teste......................... (25 dots)
		 */
		public static function generateDots($str:String, $num:int = 30, $dot:String = "."):String {
			var dotsNum:int = $num - $str.length;
			var dots:String = "";
			for (var i:int = 0; i < dotsNum; i++) {
				dots += $dot;
			}
			return $str+dots;
		}

	}
}