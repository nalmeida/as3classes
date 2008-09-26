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
		
		private static var _arrFlashVars:Array = [];
		private static var _documentClass:Sprite;
		
		/**
			Sets the RootUtil class to Document Class root property.
			
			@param $documentClass Document Class
			@return none
		 */
		public static function init($documentClass:Sprite):void {
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
		public static function getFlashvar($varName:String, $defaultValue:String = null):* {
			var returnValue:String;
			try {
				returnValue = getRoot().root.loaderInfo.parameters[$varName];
				if (!returnValue) {
					if ($defaultValue == null) $defaultValue = $varName;
					returnValue = $defaultValue;
				}
			} catch (e:Error) {
				returnValue = $defaultValue;
			}
			
			_arrFlashVars.push( {variable:$varName, value:$defaultValue } );
			
			return returnValue;
		}
		
		/**
		 * Lists all variagles got by Flashvars or if it's running inside flash the defaultValues.
		 */
		public static function listFlashvar():void {
			trace(" Flashvar list ---------------------------------------- ");
			for (var i:int = 0; i < _arrFlashVars.length; i++) {
				trace(" " + _arrFlashVars[i].variable + ":\"" + _arrFlashVars[i].value + "\"");
			}
			trace(" ------------------------------------------------------ ");
		}
	}
}