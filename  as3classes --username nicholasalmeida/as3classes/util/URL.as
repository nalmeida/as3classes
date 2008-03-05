package as3classes.util {
	
	import flash.display.Sprite;
	import flash.net.navigateToURL;
    import flash.net.URLRequest;
	import flash.utils.setTimeout;
	import flash.external.ExternalInterface;
	import com.adobe.serialization.json.JSON;
	
	import as3classes.util.LocationUtil;
	
    /**
		URL class. Calls an URL or a javascript using a queue interval every 300 miliseconds.
		
		@author Nicholas Almeida nicholasalmeida.com
		@version 5/3/2008 16:33
		@usage
			<code>
				URL.call("http://www.google.com", "_blank");
				URL.javascript("alert", 123);
				URL.analytics("/flash/");
			</code>
	 */
    public class URL extends Sprite{
		
		private static var _arrURLQueue:Array = [];
		private static var _hasStarted:Boolean = false;
		
		public static var verbose:Boolean = true;
		
		/**
			Calls a external URL using navigateToURL method.
			
			@param $url PAge URL.
			@param $target Page target. Default "_self"
		 */
        public static function call($url:String, $target:String = "_self") {
			_arrURLQueue.push( { url: $url, target: $target } );
			_start();
        }
		
		/**
			Calls a external javascript function using ExternalInterface.call method.
			
			@param $javascriptFunction Function name.
			@param ... statements Arguments to javascript. All arguments will be sent using JSON notation as Array
		 */
		public static function javascript($javascriptFunction:String, ... statements):void {
			var args:String = statements.length > 0 ? JSON.encode(statements) : "";
			_arrURLQueue.push( { js: $javascriptFunction, args: args } );
			_start();
		}
		
		/**
			Calls a external javascript function "urchinTracker" using ExternalInterface.call method.
			
			@param $analyticsString Arguments to "urchinTracker".
		 */
		public static function analytics($analyticsString:String):void {
			_arrURLQueue.push( { js: "urchinTracker", args: $analyticsString } );
			_start();
		}
		
		private static function _run():void {
			
			var j:String = _arrURLQueue[0].js;
			var a:String = _arrURLQueue[0].args;
			
			var u:String = _arrURLQueue[0].url;
			var t:String = _arrURLQueue[0].target;
			
			if (!LocationUtil.isIde() && !LocationUtil.isStandAlone()) {
				if (j) { // Javascript request
					if (ExternalInterface.available) {
						ExternalInterface.call(j, a);
					} else {
						_trace("* ERROR: ExternalInterface not avaliable. " + j + "(" + a + ")");
					}
				} else { // URL request
					try {            
						navigateToURL(new URLRequest(u), t);
					} catch (e:Error) {
						trace("* ERROR: URL._run(). URL: \"" + u + "\" TARGET: \"" + t + "\"");
					}
				}
			} else {
				if (j) {
					if (j === "urchinTracker") a = "\"" + a + "\"";
					_trace("! URL.javascript() 	running LOCAL. " + j + "(" + a + ")");
				} else {
					_trace("! URL.call() 		running LOCAL. URL: \"" + u + "\" TARGET: \"" + t + "\"");					
				}
			}
			_arrURLQueue.shift();
		}
		
		private static function _trace(str:String):void {
			if (verbose) trace(str);
		}
		
		private static function _start():void {
			setTimeout(_run, _arrURLQueue.length * 300);
		}
    }
}