package as3classes.util {
	
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;

    public class StageUtil extends Sprite {
		
		private static var _documentClass:Sprite;
		public static var onResize:Function;
		
		/**
		 * Inits the StageUtil class
		 * @version	4/3/2008 17:57
		 * @param	$documentClass:Sprite - Document Class
		 * @param	$aling:String - Same values of flash.display.StageAlign class. Default "TOP_LEFT"
		 * @see
		 * <code>
			StageUtil.init(this);
			StageUtil.onResize = function(w, h) {
				trace(w + " x " + h);
			}
		 * </code>
		 */
        public static function init($documentClass:Sprite, $aling:String = "TOP_LEFT") {
			
			_documentClass = $documentClass;
            
			getStage().stage.scaleMode = StageScaleMode.NO_SCALE;
			getStage().stage.align = StageAlign[$aling];
            
            getStage().stage.addEventListener(Event.ACTIVATE, _activateHandler);
            getStage().stage.addEventListener(Event.RESIZE, _resizeHandler);
			
			_onResize();
        }
		
		/**
		 * Returns the Document Class root property.
		 * @return 	_documentClass:Sprite
		 */
		public static function getStage():Sprite {
			return _documentClass;
		}

        private static function _activateHandler(event:Event):void {
            _onResize();
        }

        private static function _resizeHandler(event:Event):void {
            _onResize();
        }
		
		/**
		 * Fires the onResize method passing the new stage Width and Height.
		 * @return 	none;
		 */
		private static function _onResize():void {
			if (onResize != null ) onResize(getStage().stage.stageWidth, getStage().stage.stageHeight);
		}
    }
}