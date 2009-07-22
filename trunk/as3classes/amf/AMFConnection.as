package as3classes.amf {
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	
	import as3classes.amf.AMFConnectionEvent;
	
	/**
	* AMF connection class.
	* @author Nicholas Almeida. nicholasalmeida.com
	* @since 15/8/2008 15:44
	* @usage
	
		AMFConnection.verbose = true;
		AMFConnection.init("http://localhost/app/Gateway.aspx");
		AMFConnection.service = "Service.Class";
		
		var amfGet:AMFConnection = new AMFConnection("SOME_ID");
		amfGet.addEventListener(AMFConnectionEvent.COMPLETE, _onCompleteAMF);
		amfGet.addEventListener(AMFConnectionEvent.ERROR, _onErrorAMF);
		
		amfGet.call("myMethod", 123);
		
		...
		
		private function _onErrorAMF(e:AMFConnectionEvent):void {
			trace("ERROR: " + e.answer);
		}
		
		private function _onCompleteAMF(e:AMFConnectionEvent):void {
			trace("answer = " + e.answer);
		}

	*/
	
	public class AMFConnection extends EventDispatcher{
		
		// STATIC METHODS
		
		protected static var disp:EventDispatcher;
		private static var _verbose:Boolean = false;
		private static var _connected:Boolean = false;
		private static var _gateway:NetConnection;
		private static var _gatewayAddress:String;

		private static var _service:String = "";
		private static var _allInstances:Array = [];
		
		/**
		 * Init the AMFConnection
		 * @param	$gatewayAddress		gateway server address.
		 */
		public static function init($gatewayAddress:String):void {
			_gatewayAddress = $gatewayAddress;
			_gateway = new NetConnection();
			_gateway.addEventListener(NetStatusEvent.NET_STATUS, _onNetStatus);
			_gateway.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _securityError);
			_gateway.addEventListener(IOErrorEvent.IO_ERROR, _IOError);
			_trace(AMFConnection + " connecting at: \"" + _gatewayAddress + "\"");
			connect();
		}

		public static function getById($id:String):AMFConnection {
			var i:int;
			for (i = 0; i < _allInstances.length; i++) {
				if (_allInstances[i].id == $id) {
					return _allInstances[i];
				}
			}
			return null;
		}
		
		/**
		 * Opens the server connection.
		 */
		public static function connect():void {
			try {
				_gateway.connect(_gatewayAddress);
				_connected = true;
				_trace(AMFConnection + " connected.");
			} catch (e:*) {
				_trace("[ERROR] AMFConnection.connect: " + e);
			}
		}
		
		/**
		 * Closes the server connection.
		 */
		public static function close():void {
			if (_connected === true){
				_gateway.close();
				_trace(AMFConnection + " close.");
			}else {
				_trace(AMFConnection + " was already closed.");
			}
		}
		
		/**
		 * Closes the server connection, remove the listeners and clear the objects.
		 */
		public static function destroy():void {
			close();
			_gateway.removeEventListener(NetStatusEvent.NET_STATUS, _onNetStatus);
			_gateway.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _securityError);
			_gateway.removeEventListener(IOErrorEvent.IO_ERROR, _IOError);
			
			_connected = false;
			_gateway = null;
			_trace(AMFConnection + " destroy.");
		}
		
		private static function _IOError(e:IOErrorEvent):void {
			_trace(AMFConnection + " IO ERROR. " + e.text)
			dispatchEvent(new AMFConnectionEvent(AMFConnectionEvent.ERROR, { description: AMFConnection + " IO ERROR. " + e.text }));
		}
		
		private static function _securityError(e:SecurityErrorEvent):void {
			_trace(AMFConnection + " SECURITY ERROR. " + e.text)
			dispatchEvent(new AMFConnectionEvent(AMFConnectionEvent.ERROR, { description: AMFConnection + " SECURITY ERROR. " + e.text }));
		}
		
		private static function _onNetStatus(e:NetStatusEvent):void {
			//for (var name:String in e.info) {
				//trace(name + " = " + e.info[name]);
			//}
			_trace(AMFConnection + " Status: " + e.info.code);
			if (e.info.level == "error") {
				_connected = false;
				dispatchEvent(new AMFConnectionEvent(AMFConnectionEvent.ERROR, {description: AMFConnection + " ERROR. " + e.info.description + ". " + e.info.details}));
			} else if (e.info.level == "status") {
				if (e.info.code == "NetConnection.Connect.Closed") {
					_connected = false;
				}
			}
			
		}

		
		// getters and setters
		static public function get service():String { return _service; }
		static public function set service(value:String):void {
			if (value.slice(-1) != ".") value += ".";
			_service = value;
		}
		static public function get gatewayAddress():String { return _gatewayAddress; }
		
		
		// debug stuff
		protected static function _trace(msg:String):void {
			if (_verbose) trace(msg);
		}
		static public function get verbose():Boolean { return _verbose; }
		static public function set verbose(value:Boolean):void {
			_verbose = value;
		}

		// dispatcher
  		public static function addEventListener(...p_args:Array):void {
   			if (disp == null) { disp = new EventDispatcher(); }
   			disp.addEventListener.apply(null, p_args);
   		}
  		public static function removeEventListener(...p_args:Array):void {
   			if (disp == null) { return; }
   			disp.removeEventListener.apply(null, p_args);
   		}
  		public static function dispatchEvent(...p_args:Array):void {
   			if (disp == null) { return; }
   			disp.dispatchEvent.apply(null, p_args);
   		}
		
		
		
		
		// DYNAMIC METHODS
		
		private var _responder:Responder;
	
		private var _id:String = "";
		
		public function AMFConnection($id:String = "") { //$timeout:
			_allInstances[_allInstances.length] = this;
			_responder = new Responder(_onComplete, _onError);
			_id = $id;
		}
		
		
		/**
		 * Calls a method on server.
		 * @param	$method			method name. It will be concat the "service" variable.
		 * @param	... $arguments	arguments to server.	
		 */
		public function call($method:String, ... $arguments):void {
			var tmpArr:Array = [service + $method, _responder];
			for (var i:int = 0; i < $arguments.length; i++) {
				tmpArr.push($arguments[i]);
			}
			
			if (_connected) {
				if (_verbose) {
					_trace("\n"+this+" call: "  + service + $method);
					for (var k:String in $arguments) {
						_trace(k + ": " + $arguments[k] + " - type: " + typeof($arguments[k]));
						if(typeof($arguments[k]) == "object"){
							for (var m:String in $arguments[k]) {
								_trace("\t" + m + ": " + $arguments[k][m]);
							}
						}
					}
					_trace("------------------------------------------\n");
				}
				_gateway.call.apply(null, tmpArr);
			} else {
				_onError( { description:"Connection: \"" + _gatewayAddress + "\" closed." } );
			}
			tmpArr = null;
			
		}
		

		
		// PRIVATE
		
		private function _onError($answer:Object):void {
			dispatchEvent(new AMFConnectionEvent(AMFConnectionEvent.ERROR, $answer));
		}
		
		private function _onComplete($answer:*):void {
			dispatchEvent(new AMFConnectionEvent(AMFConnectionEvent.COMPLETE, $answer));
		}
		
		// getters and setters
		public function get id():String { return _id; }
		public function get connected():Boolean { return _connected; }
		
		public override function toString():String {
			return "[AMFConnection]";
		}
		
	}
}