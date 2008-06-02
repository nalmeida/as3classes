package as3classes.util {
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;

    /**
		StageUtil class. Init main stage class, sets the align type and creates a handler event for resize.
		
		@author Nicholas Almeida nicholasalmeida.com
		@version 4/3/2008 17:57
		@usage
				<code>
					StageUtil.init(this);
					StageUtil.onResize = function(w, h) {
						trace(w + " x " + h);
					}
				</code>
	 */
	public class StageUtil extends Sprite {
		
		private static var _documentClass:DisplayObject;
		public static var onResize:Function;
		
		/**
			Inits the StageUtil class
			
			@param $documentClass Document Class.
			@param $aling Same values of flash.display.StageAlign class. Default "TOP_LEFT"
		 */
        public static function init($documentClass:DisplayObject, $aling:String = "TOP_LEFT"):void {
			
			_documentClass = $documentClass;
            
			getStage().stage.scaleMode = StageScaleMode.NO_SCALE;
			getStage().stage.align = StageAlign[$aling];
            
            getStage().stage.addEventListener(Event.ACTIVATE, _activateHandler);
            getStage().stage.addEventListener(Event.RESIZE, _resizeHandler);
			
			_onResize();
        }
		
		public static function setDocumentClass($documentClass:*):void {
			_documentClass = $documentClass;
			_onResize();
		}
		
		/**
			Returns the Document Class root property.
			
			@return _documentClass
		 */
		public static function getStage():DisplayObject {
			return _documentClass;
		}

        private static function _activateHandler(event:Event):void {
            //_onResize();
        }

		
        private static function _resizeHandler(event:Event):void {
            _onResize();
        }
		
		public static function getWidth():Number {
			return getStage().stage.stageWidth;
		}
		
		public static function getHeight():Number {
			return getStage().stage.stageHeight;
		}		
		
		/**
			Fires the onResize method passing the new stage Width and Height.
			
			@return none;
		 */
		private static function _onResize():void {
			if (onResize != null ) onResize(getWidth(), getHeight());
		}
    }
}