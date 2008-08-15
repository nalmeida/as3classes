package as3classes.util {
	
	import flash.display.Sprite;
	import flash.net.navigateToURL;
    import flash.net.URLRequest;
	import flash.utils.setTimeout;
	import flash.external.ExternalInterface;
	import as3classes.util.RootUtil;
	
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
		private static var _analyticsPrefix:String = "";
		
		public static var verbose:Boolean = true;
		public static var trackerFunction:String = "pageTracker._trackPageview";
		
		/**
			Calls a external URL using navigateToURL method.
			
			@param $url PAge URL.
			@param $target Page target. Default "_self"
		 */
        public static function call($url:String, $target:String = "_self"):void {
			_arrURLQueue.push( { url: $url, target: $target } );
			_start();
        }
		
		/**
			Calls a external javascript function using ExternalInterface.call method.
			
			@param $javascriptFunction Function name.
			@param ... statements Arguments to javascript. All arguments will be sent as parameters
		 */
		public static function javascript($javascriptFunction:String, ... statements):void {
			trace("\n******************\n" + URL + " WARNING: Statements are not passed as JSON array anymore. They go as native parameters.\n Modification made at: 14/8/2008 11:31 \n******************");
			_arrURLQueue.push( { js: $javascriptFunction, args: statements } );
			_start();
		}
		
		/**
			Calls a external javascript function "urchinTracker" using ExternalInterface.call method.
			
			@param $analyticsString Arguments to "urchinTracker".
		 */
		public static function analytics($analyticsString:String):void {
			javascript(trackerFunction, (_analyticsPrefix + $analyticsString));
		}
		
		private static function _run():void {
			
			var j:String = _arrURLQueue[0].js;
			var a:Array = _arrURLQueue[0].args;
			
			var u:String = _arrURLQueue[0].url;
			var t:String = _arrURLQueue[0].target;
			
			var args:Array = [];
			
			if (LocationUtil.isWeb(RootUtil.getRoot())) {
				if (j) { // Javascript request
					if (ExternalInterface.available) {
						args[args.length] = j;
						var i:int;
						for (i = 0; i < a.length; i++) {
							args[args.length] = a[i];
						}
						//trace("args: " + args.join(" ||| ") + " args.length: " + args.length);
						ExternalInterface.call.apply(null, args);
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
					if (j === trackerFunction) {
						a.splice(0, 0, "\"");
						a[a.length] = "\"";
						a = [a.join("")];
					}
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
		
		public static function set analyticsPrefix($value:String):void {
			if ($value.slice(0, 1) != "/") {
				$value = "/" + $value;
			}
			_analyticsPrefix = $value;
		}
    }
}