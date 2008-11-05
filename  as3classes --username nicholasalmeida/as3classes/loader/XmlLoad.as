package as3classes.loader {
	import flash.events.DataEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoaderDataFormat;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.system.System;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import as3classes.loader.XmlLoadEvent;
	import com.adobe.utils.StringUtil;
	import flash.utils.setTimeout;
	
	/**
	 @see
	 <code>
		var firstname:String = "Nicholas";
		var lastname:String = "Almeida";
		var xmlToSend:XML = <root>
								<firstname>{firstname}</firstname>
								<lastname>{lastname}</lastname>
							</root>;
	
		var getXml:XmlLoad = new XmlLoad();
		
		getXml.addEventListener(XmlLoadEvent.COMPLETE, _onComplete, false, 0, true);
		getXml.addEventListener(XmlLoadEvent.ERROR, _onError, false, 0, true);
		getXml.verbose = true;
		getXml.send("http://localhost/log_post.asp", xmlToSend);
	 </code>
	 */
	public class XmlLoad extends EventDispatcher{
		
		public var url:String;
		public var type:String = "";
		public var verbose:Boolean = false;
		public var loading:Boolean = false;
		public var preventCache:Boolean;
		
		private var _request:URLRequest;
		private var _loader:URLLoader;
		private var _successXML:XML;
		private var _lastNode:String = "</root>";
		
		function XmlLoad() {
			_request = new URLRequest();
			_loader = new URLLoader();
		}
		
		/**
		 * Sends the request to server
		 * @param	$URL Path to server side page.
		 * @param	$data data to send.
		 * @param	$preventCache If true, add a querystring at the end of url name with ? (or &) and a random number. Default false.
		 * @param	$useCodePage If you want to use System.useCodePage. Default true.
		 * @return
		 */
		public function load($URL:String, $type:String = "xml", $preventCache:Boolean = false , $useCodePage:Boolean = false):* {
			
			System.useCodePage = $useCodePage;
			type = $type;
			
			/**
			 * Basic verification and feedback
			 */
			if ($URL == null || $URL == "") {
				trace("* ERROR: "+this+".send $URL undefined.");
				return;
			}
			if (loading) {
				dispatchEvent(new LoadEvent(LoadEvent.ERROR, "* ERROR: "+this+".load is already loading data.", "error"));
				return;
			}
			
			preventCache = $preventCache;
			url = $URL as String;
			
			if (preventCache) {
				var d:Date = new Date();
                var cacheString:String = "Load=" + String(Math.round(Math.random()  * 100 * d.getTime()));
                if(url.indexOf("?") == -1){
                    url += "?" + cacheString;
                }else{
                    url += "&" + cacheString;
                }
            }
			
			/**
			 * Creating URLRequest object.
			 */
			_request.url = url;
			
			/**
			 * Creating URLLoader object.
			 */
			_loader.dataFormat = URLLoaderDataFormat.TEXT;
			_loader.addEventListener(Event.COMPLETE, _onComplete, false, 0, true);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _onSecurityError, false, 0, true);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, _onIOError, false, 0, true);
			
			loading = true;
			
			setTimeout(_start, 10);
		}
		
		private function _onSecurityError(evt:SecurityErrorEvent):void {
			trace(this+" _onSecurityError");
			trace(evt);
		}
		
		private function _start():void{
			_trace("----------------------------------------------\n" + this + " Loading data from: " + url);
			
			try {
				_loader.load(_request);				
			} catch (e:Error) {
				throw new Error("* ERROR "+this+" send method: " + e.message + "\n----------------------------------------------\n");
			}
		}
		
		private function _onComplete(evt:Event):void {
			var data:String = evt.target.data.toString();
			
			if (type == "xml" ) {
				try {
					//TODO: Ver pq não funciona quando recebe um XML sem o XML declaration.
					_trace(this + " original data >> " + data + "\n\n\n");
					_successXML = new XML(data);
					_trace(this+" Received data: " + _successXML + "\n----------------------------------------------\n");
					dispatchEvent(new LoadEvent(LoadEvent.COMPLETE, _successXML, type));
				} catch (e:Error) {
					dispatchEvent(new LoadEvent(LoadEvent.ERROR, "* ERROR #1 : " + e.message, "error"));
					trace(" ---------------------------------------------- ");
					trace(evt.target.data);
					trace(" ---------------------------------------------- ");
					trace("* "+this+" ERROR _onComplete method: " + e.message + "\n----------------------------------------------\n");
				}
			}
			//regex = null;
			data = null;
			destroy();
		}
		
		private function _onIOError(evt:IOErrorEvent):void {
			dispatchEvent(new LoadEvent(LoadEvent.ERROR, "* ERROR #404 : Unable to load data from: " + url, "error"));
			destroy();
		}
		
		public function destroy():void {
			if (_loader) {
				_loader.removeEventListener(Event.COMPLETE, _onComplete);
				_loader.removeEventListener(IOErrorEvent.IO_ERROR, _onIOError);
				_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _onSecurityError);
				_loader = null;
				_request = null;
			}
			_successXML = null;
			loading = false;
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
		
		
		/**
		 * Set the last node to avoid corrupted end-of xml data.
		 * @param	$value. Value of the node. By default it's "</root>"
		 */
		public function set lastNode($value:String):void {
			_lastNode = $value;
		}
		public function get lastNode():String {
			return _lastNode;
		}
		
		public override function toString():String {
			return "[Load]";
		}

	}
}