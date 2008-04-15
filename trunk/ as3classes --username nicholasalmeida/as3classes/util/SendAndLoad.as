package as3classes.util {
	import flash.events.DataEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoaderDataFormat;
	import flash.events.IOErrorEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import as3classes.util.SendAndLoadEvent;
	
	/**
	 @see
	 <code>
		var firstname:String = "Nicholas";
		var lastname:String = "Almeida";
		var xmlToSend:XML = <root>
								<firstname>{name}</firstname>
								<lastname>{lastname}</lastname>
							</root>;
	
		getXml = new SendAndLoad();
		
		getXml.addEventListener(SendAndLoadEvent.COMPLETE, onComplete);
		getXml.addEventListener(SendAndLoadEvent.ERROR, onError);
		getXml.verbose = true;
		getXml.send("http://localhost/log_post.asp", xmlToSend);
	 </code>
	 */
	public class SendAndLoad extends EventDispatcher{
		
		public var url:String;
		public var type:String = "";
		public var verbose:Boolean = false;
		public var sending:Boolean = false;
		public var preventCache:Boolean;
		
		private var _request:URLRequest;
		private var _loader:URLLoader;
		
		function SendAndLoad() {
			_request = new URLRequest();
			_loader = new URLLoader();
		}
		
		public function send($URL:String, $data:*, $preventCache:Boolean = false ):* {
			/**
			 * Basic verification and feedback
			 */
			if ($URL == null || $URL == "") {
				trace("* ERROR: SendAndLoad.send $URL undefined.");
				return;
			}
			if ($data == null) {
				trace("* ERROR: SendAndLoad.send $data undefined.");
				return;
			}
			if (sending) {
				dispatchEvent(new SendAndLoadEvent(SendAndLoadEvent.ERROR, "* ERROR: SendAndLoad.send is already sending data.", "error"));
				return;
			}
			
			preventCache = $preventCache;
			url = $URL as String;
			
			if (preventCache) {
				var d:Date = new Date();
                var cacheString:String = "SendAndLoad=" + String(Math.round(Math.random()  * 100 * d.getTime()));
                if(url.indexOf("?") == -1){
                    url += "?" + cacheString;
                }else{
                    url += "&" + cacheString;
                }
            }
			
			if (typeof $data) {
				type = "xml";
			}
			
			/**
			 * Creating URLRequest object.
			 */
			_request.url = url;
			_request.method = URLRequestMethod.POST;
			
			if (type == "xml") {	
				_request.data = $data.toXMLString();
				//_request.contentType = "text/xml"; // TODO: Ver por que não funciona o contentType de XML
			}
			
			/**
			 * Creating URLLoader object.
			 */
			_loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			_loader.addEventListener(Event.COMPLETE, _onComplete, false, 0, true);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, _onIOError, false, 0, true);
			
			sending = true;
			
			_trace("[SendAndLoad]  Sending to: " + url);
			_trace("[SendAndLoad]  Sending data: " + _request.data);
			
			try {
				_loader.load(_request);				
			} catch (e:Error) {
				throw new Error("* ERROR [SendAndLoad] send method: " + e.message);
			}

		}
		
		private function _onComplete(evt:Event):void {
			if (type == "xml" ) {
				try {
					//TODO: Ver pq não funciona quando recebe um XML sem  o XML declaration.
					var success:XML = new XML(unescape(evt.target.data));
					_trace("[SendAndLoad] Received data: " + success);
					dispatchEvent(new SendAndLoadEvent(SendAndLoadEvent.COMPLETE, success, type));
				} catch (e:Error) {
					dispatchEvent(new SendAndLoadEvent(SendAndLoadEvent.ERROR, "* ERROR #1 : " + e.message, "error"));
					throw new Error("* ERROR [SendAndLoad] _onComplete method: " + e.message);
				}
			}
			destroy();
		}
		
		private function _onIOError(evt:IOErrorEvent):void {
			dispatchEvent(new SendAndLoadEvent(SendAndLoadEvent.ERROR, "* ERROR #404 : Unable to load data from: " + url, "error"));
			destroy();
		}
		
		private function destroy():void {
			if (_loader) {
				_loader.removeEventListener(Event.COMPLETE, _onComplete);
				_loader.addEventListener(IOErrorEvent.IO_ERROR, _onIOError);
				_loader = null;
				_request = null;
			}
			
			sending = false;
		}
		
		/**
		 * Private function to trace if verbose is true.
		 * @param	str
		 */
		private  function _trace(str:*):void {
			if (verbose) {
				trace(str);
			}
		}
	}
}