package as3classes.loader{

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.utils.getDefinitionByName;
	import as3classes.util.RootUtil;
	import as3classes.util.StageUtil;

	// @original: http://www.dreaminginflash.com/2007/11/13/actionscript-3-preloader/
	
	/**
		SelfPreloader class. Creates a self preloader in the "first frame".
		
		@author Nicholas Almeida nicholasalmeida.com
		@version 11/6/2008 19:20
		@usage
				Insert the line above at package of your Main class:
				[Frame(factoryClass="as3classes.loader.SelfPreloader")]
				
				IMPORTANT:
					Your main class MUST be named as "Main".
					
					If you want to add a MovieClip as your preloader icon:
					 * Create a SWC file with a MovieClip with linkage name "lib_standardLoader".
					 * I allways will be at center center of stage.
	 */
	
	public class SelfPreloader extends MovieClip {
		
		public var standardLoader:MovieClip;
		
		public function SelfPreloader() {
			stop();
			
			RootUtil.setRoot(this);
			StageUtil.init(RootUtil.getRoot());
			
			try {
				standardLoader = new (getChildByName("lib_standardLoader") as Class)() as MovieClip;
				addChild(standardLoader);
				
				standardLoader.x = StageUtil.getWidth() * .5;
				standardLoader.y = StageUtil.getHeight() * .5;
				
			} catch (e:Error) {
				trace("WARNING: lib_standardLoader not defined.");
			}
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0, true);
		}
		
		public function onIOError(event:IOErrorEvent):void {
			try {
				standardLoader.stop();
			} catch (e:Error) {}
			
			stop();
			removeListeners();
			trace(event.toString());
			trace("--------------------------------------------");
		}
		
		public function removeListeners():void {
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}
		
		public function onEnterFrame(event:Event):void {
			var percent:Number;
			if (framesLoaded == totalFrames) {
				percent = 1;
				removeListeners();
				nextFrame();
				onComplete();
			} else {
				percent = RootUtil.getRoot().loaderInfo.bytesLoaded / RootUtil.getRoot().loaderInfo.bytesTotal;
			}
			trace(percent);
		}
		
		private function onComplete():void {
			try {
				removeChild(standardLoader);
				standardLoader = null;
			} catch (e:Error) {}
			var mainClass:Class = Class(getDefinitionByName("Main"));
			
			if(mainClass) {
				var app:Object = new mainClass();
				addChild(app as DisplayObject);
			}
		}
	}
}

