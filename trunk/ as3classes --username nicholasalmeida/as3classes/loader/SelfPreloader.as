

package as3classes.loader {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class SelfPreloader extends MovieClip {
		
		private var _root:MovieClip;
		private var _hasInit:Boolean = false;
		
		public var onStart:Function;
		public var onUpdate:Function;
		public var onComplete:Function;
		public var verbose:Boolean = false;
		
		public function SelfPreloader($root:MovieClip) {
			
			_root = $root;
			_root.stop();
			_root.stage.addEventListener(Event.ENTER_FRAME, _onUpdate, false, 0, true);
		}
		
		private function _onUpdate(e:Event):void {
			var total:int = Math.floor(_root.stage.loaderInfo.bytesTotal / 1000);
			var loaded:int = Math.floor(_root.stage.loaderInfo.bytesLoaded / 1000);
			var percent:int = (loaded / total) * 100;
			
			if (!_hasInit) {
				_trace("% Loading _root started");
				if (onStart != null) {
					onStart(percent, _root);
				}
				_hasInit = true;
			}
			
			_trace("% Percent _root loaded: " + percent);
			
			if (onUpdate != null) {
				onUpdate(percent, _root);
			}
			
			if (percent >= 100) {
				_root.stage.removeEventListener(Event.ENTER_FRAME, _onUpdate);
				_trace("% Loading _root complete");
				if (onComplete != null) {
					onComplete(percent, _root);
				}
			}
		}
		
		private function _trace(str:*):void {
			if (verbose) trace(str);
		}

	}
}