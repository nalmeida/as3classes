package as3classes.loader{

	import flash.display.MovieClip;
	import flash.events.Event;
	
	import as3classes.loader.SelfPreloader;
	import as3classes.util.StageUtil;
	
	// @original: http://www.dreaminginflash.com/2007/11/13/actionscript-3-preloader/
	
	/**
		SelfPreloader class. Creates a self preloader in the "first frame".
		
		@author Nicholas Almeida nicholasalmeida.com
		@version 12/6/2008 12:22
		@usage
				Insert the line above at package of your Main class:
				[Frame(factoryClass="as3classes.loader.SelfPreloaderIcon")]
				
				IMPORTANT:
					Your main class MUST be named as "Main".
					
					You MUST add a MovieClip as your preloader icon:
					 * Create a SWC file with a MovieClip with linkage name "lib_standardLoader".
					 * I allways will be at center center of stage.
	 */	
	
	public class SelfPreloaderIcon extends SelfPreloader {
		
		public override function init():void {
			trace("SelfPreloaderIcon.init");
			super.useIcon = true;
			super.standardLoader = new lib_standardLoader as MovieClip;
			addChild(super.standardLoader);
			
			super.standardLoader.x = StageUtil.getWidth() * .5;
			super.standardLoader.y = StageUtil.getHeight() * .5;
			
            super.stage.addEventListener(Event.RESIZE, onResize, false, 0, true);
		}
		
		public override function onResize(evt:Event):void {
			super.standardLoader.x = super.stage.stageWidth * .5;
			super.standardLoader.y = super.stage.stageHeight * .5;
		}
		
	}
}

