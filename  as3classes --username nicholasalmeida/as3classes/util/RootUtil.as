package as3classes.util {
	
	import flash.display.Sprite;
	import com.adobe.serialization.json.*;
	
	/**
		Root class. Create a global class to access the main root sprite.
		
		@author Nicholas Almeida nicholasalmeida.com
		@version 4/3/2008 16:30
		@usage
				<code>
					RootUtil.setRoot(this);
				</code>
	 */
	public class RootUtil extends Sprite {
		
		private static var _documentClass:Sprite;
		
		/**
			Sets the RootUtil class to Document Class root property.
			
			@param $documentClass Document Class
			@return none
		 */
		public static function setRoot($documentClass:Sprite):void {
			_documentClass = $documentClass;
		}
		
		/**
			Returns the Document Class root property.
			
			@return _documentClass
		 */
		public static function getRoot():Sprite {
			return _documentClass;
		}
		
		/**
			Get the flashvars strong type JSON notation. If is running on Flash IDE returns $defaultValue else $varName.
			
			@param $varName Variable got from flashvars.
			@param $defaultValue Default value if $varName is null.
			@return	returnValue The Flashvars variable. If is running on Flash IDE returns $defaultValue else $varName value.
		 */
		public static function getFlashvar($varName:String, $defaultValue:String):* {
			var returnValue:String;
			try {
				returnValue = getRoot().root.loaderInfo.parameters[$varName];
				if (!returnValue) returnValue = $defaultValue;
			} catch (e:Error) {
				returnValue = $defaultValue;
			}
			return returnValue;
		}
	}
}