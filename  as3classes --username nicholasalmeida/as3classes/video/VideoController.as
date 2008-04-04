package as3classes.video {
	
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.net.NetStream;
	import flash.events.NetStatusEvent;
	import flash.events.Event;

	public class VideoController extends EventDispatcher{
		
		public var _netStream:NetStream;
		public var isPlaying:Boolean;
		public var verbose:Boolean = true;
		public var _duration:Number;
		
		public var autoPlay:Boolean;
		public var loop:Boolean;
		
		
		public function VideoController($duration:Number, $autoplay:Boolean = false, $loop:Boolean = false):void {
			try{
				_duration = Math.round(int($duration * 1000)) / 1000;
			} catch (e:Error) {
				throw new Error("* ERROR [VideoController]: you MUST define $duration time.");
			}
			autoPlay = $autoplay;
			loop = $loop;
			isPlaying = false;
		}
		
		public function destroy():void {
			stop();
			_netStream.removeEventListener(NetStatusEvent.NET_STATUS, _onNetStatus);
			netStream = null;
		}
		
		public function set netStream($netStream:NetStream):void {
			if (_netStream == null) {
				_netStream = $netStream;
				_connect();
				_netStream.addEventListener(NetStatusEvent.NET_STATUS, _onNetStatus, false, 0, true);
			}
		}
		
		public function get netStream():NetStream {
			return _netStream;
		}
		
		public function get percentPlayed():Number {
			return time / _duration;
		}
		public function get duration():Number {
			return _duration;
		}
		public function get remainingTime():Number {
			return (duration - time);
		}
		public function get time():Number {
			return Math.round(int(netStream.time * 1000))/1000;;
		}
		
		public function playPause():Boolean {
			if (isPlaying) {
				pause();
			} else {
				play();
			}
			return isPlaying;
		}
		
		public function play():void {
			try {
				if (time >= duration) {
					netStream.seek(0);
					netStream.resume();
				} else {
					netStream.resume();
				}
				isPlaying = true;
				_trace("! VideoController.play called at: " + time);
				
			} catch (e:Error) {
				throw new Error("* ERROR [VideoController] play method : " + e.message);
			}
		}
		
		public function pause():void {
			try {
				netStream.pause();
				isPlaying = false;
				_trace("! VideoController.pause called at: " + time);
			} catch (e:Error) {
				throw new Error("* ERROR [VideoController] pause method : " + e.message);
			}
		}
		
		public function rewind():void {
			stop();
			play();
		}
		
		public function stop():void {
			try {
				netStream.seek(0);
				netStream.pause();
				_trace("! VideoController.stop called at: " + netStream.time);
			} catch (e:Error) {
				throw new Error("* ERROR [VideoController] stop method : " + e.message);
			}
		}
		
		/**
		 * Private
		 */
		
		private function _connect():void {
			if (!autoPlay) {
				stop();
			} else {
				isPlaying = true;
			}
		}
		 
		private function _onNetStatus(event:Object):void {
			
			switch (event.info.code) {
				case "NetConnection.Connect.Success":
					//_connect();
					//_trace("! VideoController status: " + event.info.code);
					break;
				case "NetStream.Buffer.Full":
					//_connect();
					//_trace("! VideoController status: " + event.info.code);
					break;
				case "NetStream.Play.StreamNotFound":
					_trace("* ERROR VideoController Stream not found.");
					break;
				case "NetStream.Play.Stop":
					dispatchEvent(new Event(Event.COMPLETE));
					_trace("! VideoController complete.");
					if (loop) rewind();
					else pause();
					break;
			}
		}
		 
		/**
		 * Private function to trace if verbose is true.
		 * @param	str
		 */
		private function _trace(str:*):void {
			if (verbose) {
				trace(str);
			}
		}
	}
}