package as3classes.ui {
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import redneck.events.SliderEvent;
	
	import redneck.ui.Slider;
	import redneck.ui.Drag;

	
	/**
	 @see
	 <code>
		scroll = new ScrollbarComponent(mcScroll);
		scroll.addEventListener(ScrollbarComponent.EVENT_CHANGE, _onScroll, false, 0, true);
		
		.......
		
		private function _onScroll(evt:Event ):void {
			trace(scroll.percent);
		}
	 </code>
	 */
	
	public class ScrollbarComponent extends EventDispatcher {
		
		public static const EVENT_CHANGE:String = Event.CHANGE;
		
		public var mc:DisplayObjectContainer;
			public var mcUp:Sprite;
			public var mcDown:Sprite;
			public var mcHolder:DisplayObjectContainer;
				public var mcTrack:Sprite;
				public var mcSlider:Sprite;
		
		public var slider:Slider;
		public var _horizontal:Boolean = false;
		
		public function ScrollbarComponent($mc:*) {
			mc = $mc as DisplayObjectContainer;
				mcUp = mc.getChildByName("mcUp") as Sprite;
				mcDown = mc.getChildByName("mcDown") as Sprite;
				mcHolder = mc.getChildByName("mcHolder") as Sprite;
					mcTrack = mcHolder.getChildByName("mcTrack") as Sprite;
					mcSlider = mcHolder.getChildByName("mcSlider") as Sprite;
			
			adjustSizes();
					
			/**
			 * Slider
			 */
			
			slider = new Slider(mcSlider, mcTrack, false);
			slider.addEventListener(SliderEvent.ON_CHANGE, _onScrollChange, false, 0, true);
			
			/**
			 * Arrows
			 */
			mc.addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage, false, 0, true);		
		}
		
		private function _onAddedToStage(e:Event):void {
			mc.removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			/**
			 * Arrows
			 */
			if(!mcUp.hasEventListener(MouseEvent.MOUSE_DOWN)) {
				mcUp.addEventListener(MouseEvent.MOUSE_DOWN, _startEnterframe, false, 0, true);
				mcDown.addEventListener(MouseEvent.MOUSE_DOWN, _startEnterframe, false, 0, true);
			}
			if(!mcUp.stage.hasEventListener(MouseEvent.MOUSE_UP)) {
				mcUp.stage.addEventListener(MouseEvent.MOUSE_UP, _stopEnterframe, false, 0, true);
				mcDown.stage.addEventListener(MouseEvent.MOUSE_UP, _stopEnterframe, false, 0, true);
			}
		}
		
		public function adjustSizes():void {
			
			var objSize:Object = { };
				objSize.w = mc.width - mcUp.width - mcDown.width;
				objSize.h = mc.height - mcUp.height - mcDown.height;
		
			mc.scaleX = 1;
			mc.scaleY = 1;
			
			if (!_horizontal) {
				mcHolder.y = mcUp.y + mcUp.height;
				mcTrack.height = objSize.h;
				mcDown.y = mcHolder.y + mcHolder.height;
			} else {
				//TODO: Horizontal Scrollbar?
				//mcHolder.x = mcUp.x + mcUp.width;
				//mcTrack.width = objSize.w;
				//mcDown.x = mcHolder.x + mcHolder.width;
			}
		}
		
		public function disable():void {
			slider.disable();
			mc.mouseEnabled = 
			mc.mouseChildren = false;
		}
		
		public function enable():void {
			slider.enable();
			mc.mouseEnabled = 
			mc.mouseChildren = true;
		}
		
		public function destroy():void {
			
			mcUp.removeEventListener(MouseEvent.MOUSE_DOWN, _startEnterframe);
			mcDown.removeEventListener(MouseEvent.MOUSE_DOWN, _startEnterframe);
			
			mcUp.stage.removeEventListener(MouseEvent.MOUSE_UP, _stopEnterframe);
			mcDown.stage.removeEventListener(MouseEvent.MOUSE_UP, _stopEnterframe);
			
			_stopEnterframe(null);
			
			slider.removeEventListener(SliderEvent.ON_CHANGE, _onScrollChange);
			slider.destroy();
			
			mc = null;
			mcHolder = null;
			mcTrack = null;
			mcSlider = null;
			mcUp = null;
			mcDown = null;
		}
		
		public function set percent($percent:Number):void {
			slider.percent = $percent;
		}
		
		public function get percent():Number {
			return slider.percent;
		}
		
		private function _stopEnterframe(evt:*):void {
			mc.removeEventListener(Event.ENTER_FRAME, _next);
			mc.removeEventListener(Event.ENTER_FRAME, _prev);
		}
		
		private function _startEnterframe(evt:MouseEvent):void {
			if (evt.currentTarget == mcUp) {	// mcUp
				mc.addEventListener(Event.ENTER_FRAME, _prev, false, 0, true);
			} else { 					// mcDown
				mc.addEventListener(Event.ENTER_FRAME, _next, false, 0, true);
			}
		}
		
		private function _prev(evt:Event):void {
			slider.move(-3);
		}
		
		private function _next(evt:Event):void {
			slider.move(3);
		}
		
		private function _onScrollChange(evt:Event):void {
			dispatchEvent(new Event(ScrollbarComponent.EVENT_CHANGE));
		}

	}
}