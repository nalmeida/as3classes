package as3classes.util {
	
	import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
	import flash.events.EventDispatcher;

    /**
		StageUtil class. Init main stage class, sets the align type and creates a handler event for resize.
		
		@author Nicholas Almeida nicholasalmeida.com
		@version 1.0 - 26/9/2008 13:57
		@usage
				<code>
					StageUtil.init(this);
					StageUtil.addEventListener(Event.RESIZE, _onResize);
					
					...
					
					private function _onResize(e:Event = null):void {
						trace("StageUtil.width: " + StageUtil.width);
						trace("StageUtil.halfWidth: " + StageUtil.halfWidth);
						trace("StageUtil.height: " + StageUtil.height);
						trace("StageUtil.halfHeight: " + StageUtil.halfHeight);
					}
				</code>
	 */
	public class StageUtil extends Sprite {
		
		private static var _documentClass:DisplayObject;
		
		public static var minWidth:Number = -1;
		public static var maxWidth:Number = -1;
		
		public static var minHeight:Number = -1;
		public static var maxHeight:Number = -1;
		
		/**
			Inits the StageUtil class
			
			@param $documentClass Document Class.
			@param $aling Same values of flash.display.StageAlign class. Default "TOP_LEFT"
		 */
        public static function init($documentClass:DisplayObject, $aling:String = "TOP_LEFT"):void {
			
			_documentClass = $documentClass;
            
			getStage().stage.scaleMode = StageScaleMode.NO_SCALE;
			getStage().stage.align = StageAlign[$aling];
            
            getStage().stage.addEventListener(Event.RESIZE, _resizeHandler);
        }
		
		/**
			Returns the Document Class root property.
			
			@return _documentClass
		 */
		public static function getStage():DisplayObject {
			return _documentClass.stage;
		}
		
		/**
		 * Returns the stage width
		 * 
		 * @return Number
		 */
		public static function get width():Number {
			var n:Number = getStage().stage.stageWidth;
			if (maxWidth != -1) {
				if (n > maxWidth) n = maxWidth;
			}
			if (minWidth != -1) {
				if (n < minWidth) n = minWidth;
			}
			return n;
		}
		
		/**
		 * Returns the stage width/2
		 * 
		 * @return Number
		 */
		public static function get halfWidth():Number {
			return width * .5;
		}
		
		/**
		 * Returns the stage height
		 * 
		 * @return Number
		 */
		public static function get height():Number {
			var n:Number = getStage().stage.stageHeight;
			if (maxHeight != -1) {
				if (n > maxHeight) n = maxHeight;
			}
			if (minHeight != -1) {
				if (n < minHeight) n = minHeight;
			}
			return n;
		}	
		
		/**
		 * Returns the stage height/2
		 * 
		 * @return Number
		 */
		public static function get halfHeight():Number {
			return height * .5;
		}
		
		public static function destroy():void {
			getStage().stage.removeEventListener(Event.RESIZE, _resizeHandler);
			_documentClass = null;
		}
		
		private static function _resizeHandler(event:Event = null):void {
			disp.dispatchEvent(new Event(Event.RESIZE));
		}
		
		//{ region 
		
		protected static var disp:EventDispatcher;
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
		
		//} endregion
		
    }
}