package {
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ErrorEvent;
	
	
	public class MainPreloader extends MovieClip {
		
		public static const ENTRY_FRAME:int = 2;
		public static const DOCUMENT_CLASS:String = 'Main'; // Your main class name
		
		private static var _progressBar:Sprite; // If you want to use an icon as a preloader.
		
		private var _loaded:uint;
		private var _total:uint ;
		private var _percent:Number
		
		public function MainPreloader() {
			super();
			stop();
			
			if (loaderInfo.bytesLoaded == loaderInfo.bytesTotal) {
				completeHandler();
			}else{
				loaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
				loaderInfo.addEventListener(Event.COMPLETE, completeHandler);
				loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				loaderInfo.addEventListener(ErrorEvent.ERROR, onError);
			}
		}
		
		private function onError(e:ErrorEvent):void {
			trace(this + " ErrorEvent" + e);
		}
		
		
		private function onIOError(e:IOErrorEvent):void {
			trace(this + " IOErrorEvent" + e);
		}
		
		private function progressHandler(e:ProgressEvent):void {
			_loaded = e.bytesLoaded;
			_total = e.bytesTotal;
			_percent = _loaded / _total;
			trace(_percent);
		}
		
		private function completeHandler(e:Event = null):void {
			try {
				loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
				loaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
				loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
				loaderInfo.removeEventListener(ErrorEvent.ERROR, onError);
			} catch (e:Error) {
				
			}
			main();
		}
		
		private function main():void {
			gotoAndStop(ENTRY_FRAME);
			var programClass:Class = loaderInfo.applicationDomain.getDefinition(DOCUMENT_CLASS) as Class;
			var program:Sprite = new programClass() as Sprite;
			addChild(program);
		}
		
		public override function toString():String {
			return "[MainPreloader]";
		}
	}
}