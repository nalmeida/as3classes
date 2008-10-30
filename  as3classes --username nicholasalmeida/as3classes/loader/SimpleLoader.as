package as3classes.loader {
	
	/**
	 * Very Simple Content Loader
	 * @author Nicholas Almeida nicholasalmeida.com
	 * @since 28/10/2008 15:39
	 * @usage 
	 
		loader = new SimpleLoader();
			loader.addEventListener(Event.COMPLETE, onLoadComplete);
			loader.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			loader.addEventListener(ErrorEvent.ERROR, onLoadError);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			
		loader.load("your_swf.swf");
	 
	 
		public static function onLoadError(e:*):void { // ErrorEvent or IOErrorEvent
			trace("ERROR" + e);
		}

		public static function onLoadProgress(e:ProgressEvent):void {
			trace("% loaded: " + loader.percentLoaded);
		}

		public static function onLoadComplete(e:Event):void {
			holder.addChild(loader.content as MovieClip);
		}
		
	 */
	
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
		
	public class SimpleLoader extends EventDispatcher{
		
		public var loader:Loader;
		public var whatToLoad:String;
		public var percentLoaded:Number;
		public var content:*;
		
		public function SimpleLoader() {}
		
		private function _addListeners():void {
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _onLoadComplete, false, 0, true);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, _onLoadProgress, false, 0, true);
			loader.contentLoaderInfo.addEventListener(ErrorEvent.ERROR, _onLoadError, false, 0, true);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _onLoadError, false, 0, true);
		}
		
		
		private function _removeListeners():void {
			try {
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, _onLoadComplete);
				loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, _onLoadProgress);
				loader.contentLoaderInfo.removeEventListener(ErrorEvent.ERROR, _onLoadError);
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, _onLoadError);
			} catch (e:Error) {}
		}
		
		private function _onLoadError(e:*):void {
			dispatchEvent(e);
			stop();
		}
		
		private function _onLoadProgress(e:Event):void {
			dispatchEvent(e);
			percentLoaded = loader.contentLoaderInfo.bytesTotal / loader.contentLoaderInfo.bytesTotal;
		}
		
		private function _onLoadComplete(e:Event):void {
			content = loader.content;
			dispatchEvent(e);
			_removeListeners();
		}
		
		public function destroy():void {
			_removeListeners();
			loader = null;
		}
		
		public function stop():void {
			try {
				loader.close();
			} catch(e:Error){}
		}
		
		public function load($whatToLoad:String):void {
			whatToLoad = $whatToLoad;
			percentLoaded = 0;
			content = null;
			
			stop();
			destroy();
			
			loader = new Loader();
			_addListeners();
			
			try {
				loader.load(new URLRequest(whatToLoad));
			} catch (e:Error) {
				trace(this + " ERROR : " + e);
			}
		}
		
		public override function toString():String {
			return "[SimpleLoader]";
		}
	}
	
}