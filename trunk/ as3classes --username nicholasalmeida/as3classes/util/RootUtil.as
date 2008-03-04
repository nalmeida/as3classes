package as3classes.util {
	
	import flash.display.Sprite;
	import com.adobe.serialization.json.JSON;
	
	/**
	 * Root class
	 * @author 		Nicholas Almeida nicholasalmeida.com
	 * @version 	4/3/2008 16:30
	 */
	public class RootUtil extends Sprite {
		
		private static var _documentClass:Sprite;
		
		/**
		 * Sets the RootUtil class to Document Class root property
		 * @param 	$documentClass:Sprite - Document Class
		 * @return 	none
		 */
		public static function setRoot($documentClass:Sprite):void {
			_documentClass = $documentClass;
		}
		
		/**
		 * Returns the Document Class root property.
		 * @return 	_documentClass:Sprite
		 */
		public static function getRoot():Sprite {
			return _documentClass;
		}
		
		/**
		 * 
		 * @param	$varName:String - Variable got from flashvars
		 * @param	$defaultValue:String - Default value if $varName is null
		 * @return	returnValue:* - Returns the object using strong type JSON notation. If is running on Flash IDE returns $defaultValue else $varName
		 */
		public static function getFlashvar($varName:String, $defaultValue:String):* {
			var returnValue:String;
			try {
				returnValue = getRoot().root.loaderInfo.parameters[$varName];
				if (!returnValue) returnValue = $defaultValue;
			} catch (e:Error) {
				returnValue = $defaultValue;
			}
			return JSON.decode(returnValue);
		}
	}
}