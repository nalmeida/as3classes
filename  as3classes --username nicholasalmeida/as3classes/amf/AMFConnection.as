package as3classes.amf {
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
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
	
		AMFConnection.init("http://localhost/app/Gateway.aspx");
		AMFConnection.service = "Service.Class";
		
		AMFConnection.call("myMethod", 123);
		AMFConnection.addEventListener(AMFConnectionEvent.COMPLETE, _onCompleteAMF);
		AMFConnection.addEventListener(AMFConnectionEvent.ERROR, _onErrorAMF);
		
		...
		
		private function _onErrorAMF(e:AMFConnectionEvent):void {
			trace("ERROR: " + e.answer);
		}
		
		private function _onCompleteAMF(e:AMFConnectionEvent):void {
			trace("answer = " + e.answer);
		}

	*/
	
	public class AMFConnection extends EventDispatcher{
		
		public static var gateway:NetConnection;
		public static var responder:Responder;
		public static var verbose:Boolean = false;
		public static var gatewayAddress:String;
	
		private static var _service:String = "";
		private static var _connected:Boolean = false;
		
		private static var _scope:AMFConnection;
		private var _id:String = "";
		
		protected static var disp:EventDispatcher;
		
		public function AMFConnection($id:String = "") {
			responder = new Responder(_onComplete, _onError);
			_id = $id;
		}
		
		/**
		 * Init the AMFConnection
		 * @param	$gatewayAddress		gateway server address.
		 */
		public static function init($gatewayAddress:String):void {
			gatewayAddress = $gatewayAddress;
			gateway = new NetConnection();
			gateway.addEventListener(NetStatusEvent.NET_STATUS, _onNetStatus, false, 0, true);
			gateway.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _securityError, false, 0, true);
			
			try {
				gateway.connect(gatewayAddress);
				_connected = true;
				_trace("[AMFConnection] connected.");
			} catch (e:*) {
				trace(e);
			}
			
		}
		
		/**
		 * Calls a method on server.
		 * @param	$method			method name. It will be concat the "service" variable.
		 * @param	... $arguments	arguments to server.	
		 */
		public function call($method:String, ... $arguments):void {
			_scope = this;
			
			var tmpArr:Array = [service + $method, responder];
			for (var i:int = 0; i < $arguments.length; i++) {
				tmpArr.push($arguments[i]);
			}
			
			if (connected) {
				if(verbose){
					_trace("\n[AMFConnection] call: "  + service + $method);
					for (var k:String in $arguments) {
						trace(k + ": " + $arguments[k] + " - type: " + typeof($arguments[k]));
						if(typeof($arguments[k]) == "object"){
							for (var m:String in $arguments[k]) {
								trace("\t" + m + ": " + $arguments[k][m]);
							}
						}
					}
					_trace("------------------------------------------\n");
				}
				gateway.call.apply(null, tmpArr);
			} else {
				_onError( { description:"Connection: \"" + gatewayAddress + "\" closed." } );
			}
			tmpArr = null;
		}
		
		/**
		 * Closes the server connection.
		 */
		public static function close():void {
			gateway.close();
			_trace("[AMFConnection] close.");
		}
		
		/**
		 * Closes the server connection, remove the listeners and clear the objects.
		 */
		public static function destroy():void {
			close();
			gateway.removeEventListener(NetStatusEvent.NET_STATUS, _onNetStatus);
			
			_connected = false;
			gateway = null;
			responder = null;
			disp = null;
			_trace("[AMFConnection] destroy.");
		}
		
		
		
		// Private
		static private function _securityError(e:SecurityErrorEvent):void {
			_trace("[AMFConnection] SECURITY ERROR. " + e.text)
			_scope._onError( {description: "[AMFConnection] SECURITY ERROR. " + e.text} );
		}
		
		static private function _onNetStatus(e:NetStatusEvent):void {
			//for (var name:String in e.info) {
				//trace(name + " = " + e.info[name]);
			//}
			_trace("[AMFConnection] Status: " + e.info.code);
			if (e.info.level == "error") {
				_connected = false;
				_scope._onError( {description: "[AMFConnection] ERROR. " + e.info.description + ". " + e.info.details} );
			} else if (e.info.level == "status") {
				if (e.info.code == "NetConnection.Connect.Closed") {
					_connected = false;
				}
			}
			
		}
		
		private function _onError($answer:Object):void {
			_scope.dispatchEvent(new AMFConnectionEvent(AMFConnectionEvent.ERROR, $answer));
		}
		
		private function _onComplete($answer:*):void {
			_scope.dispatchEvent(new AMFConnectionEvent(AMFConnectionEvent.COMPLETE, $answer));
		}
		
		// SET/GET
		static public function get service():String { return _service; }
		
		static public function set service(value:String):void {
			if (value.slice( -1) != ".") value += ".";
			_service = value;
		}
		
		static public function get connected():Boolean { return _connected; }
		
		
		
		// Dispatcher
		/*
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
		*/

		protected static function _trace(msg:String):void {
			if (verbose) trace(msg);
		}
		
	}
}