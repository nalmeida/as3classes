package as3classes.util {
	
	public class Server{
		
		import as3classes.util.LocationUtil;
		import flash.display.DisplayObjectContainer;
		
		public static var verbose:Boolean = false;
		
		/**
			Returns a variable depending if it's running at Flex IDE ou http website.
			
			@param $documentClass Root document class.
			@param $UrlId URL indetifier.
			@param $obj Object with local, web, and extra values;
			
			@author Nicholas Almeida nicholasalmeida.com
			@version 11/3/2008 19:56
			@usage
					<code>
						Server.setAddress(this, "getMP3", {
							local: "http://locahost/return_mp3_list.php", 
							web: "http://mysite.com/return_mp3_list.php",
							extra: "http://test.mysite.com/return_mp3_list.php"
						});
						
						trace(Server.getAddress("getMP3"));
						// If extra exists, return the extra value
						// else if is running over http protocol, returns the web value
						// else if is locally, returns the local value.
					</code>
		 */
		
		private static var obj:Object = {};
		private static var local:Boolean;
		private static var documentClass:DisplayObjectContainer;
		
		/**
		 * Sets the documentClass URL identifier and object with local, web / extra data.
		 * @param	$documentClass Root class
		 * @param	$UrlId URL identifier
		 * @param	$obj Object with local, web and/or extra values
		 */
        public static function setAddress($documentClass:DisplayObjectContainer, $UrlId:String, $obj:Object):void {
			documentClass = $documentClass;
			obj[$UrlId] = $obj;
		}
		
		/**
		 * Returns the URL value. If it's have the value "extra", returns the "extra" value, else if it's runnind on "http" server returns the "web" valeu else returns the "local" value.
		 * @param	$UrlId URL identifier
		 * @return  extra (priority), web (running on http) or local (Flex IDE)
		 */
		public static function getAddress($UrlId:String):String {
			var u:String = "";
			var o:Object = obj[$UrlId];
			
			if (o == null) {
				trace("* ERROR: Server.getAddress method $UrlId undefined: " + $UrlId);
				return "";
			}
			
			if (o.extra != null) {
				u = o.extra;
				_trace("! Using \"extra\" value: " + u);
			} else {
				if (LocationUtil.isWeb(documentClass)) {
					u = o.web;
					if (u == null) {
						trace("* ERROR: Server.getAddress method \"web\" undefined.");
						u = "";
					}
					_trace("! Using \"web\" value: \"" + u + "\"");
				} else {
					u = o.local;
					if (u == null) {
						trace("* ERROR: Server.getAddress method \"local\" undefined.");
						u = "";
					}
					_trace("! Using \"local\" value: \"" + u+ "\"");
				}
			}
			return u;
		}
		
		/**
		 * Private function to trace if verbose is true.
		 * @param	str
		 */
		private static function _trace(str:*):void {
			if (verbose) {
				trace(str);
			}
		}
		
    }
}