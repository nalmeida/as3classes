package as3classes.util {
	import flash.events.DataEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
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
		
		private var _variablesToSend:URLVariables;
		private var _request:URLRequest;
		private var _loader:URLLoader;
		
		function SendAndLoad() {
			_variablesToSend = new URLVariables();
			_request = new URLRequest();
			_loader = new URLLoader();
		}
		
		public function send($URL:String, $data:*):* {
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
				trace("* ERROR: SendAndLoad.send is already sending data.");
				return;
			}
			
			
			url = $URL as String;
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
				//_request.contentType = "text/xml"; // TODO: Ver por que não estã pegando pelo log post.
			}
			
			/**
			 * Creating URLLoader object.
			 */
			_loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			_loader.addEventListener(Event.COMPLETE, _onComplete);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, _onIOError);
			
			sending = true;
			
			_trace("! Sending to: " + url);
			_trace("! Sending data: " + _request.data);
			
			try {
				_loader.load(_request);				
			} catch (e:Error) {
				trace("* ERROR: " + e.message);
			}

		}
		
		private function _onComplete(evt:Event):void {
			if(type == "xml" ){
				try {
					var success:XML = new XML(unescape(evt.target.data));
					dispatchEvent(new SendAndLoadEvent(SendAndLoadEvent.COMPLETE, success, type));
				} catch (e:Error) {
					trace("* ERROR: " + e.message);
					dispatchEvent(new SendAndLoadEvent(SendAndLoadEvent.ERROR, "* ERROR: " + e.message, "error"));
				}
			}
			sending = false;
		}
		
		private function _onIOError(evt:IOErrorEvent):void {
			dispatchEvent(new SendAndLoadEvent(SendAndLoadEvent.ERROR, "* ERROR: Unable to load data from: " + url, "error"));
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