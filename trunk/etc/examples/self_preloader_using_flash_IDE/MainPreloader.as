package {
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	
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
			
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			loaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}
		
		private function onIOError(event:IOErrorEvent):void {
			trace("IOErrorEvent");
		}
		
		private function progressHandler(event:ProgressEvent):void {
			_loaded = event.bytesLoaded;
			_total = event.bytesTotal;
			_percent = _loaded / _total;
			trace(_percent);
		}
		
		private function completeHandler(event:Event):void {
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			loaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
			main();
		}
		
		private function main():void {
			gotoAndStop(ENTRY_FRAME);
			var programClass:Class = loaderInfo.applicationDomain.getDefinition(DOCUMENT_CLASS) as Class;
			var program:Sprite = new programClass() as Sprite;
			addChild(program);
		}
	}
}