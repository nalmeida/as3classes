package as3classes.ui {
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	import redneck.ui.Slider;
	import redneck.ui.Drag;

	public class Scrollbar extends EventDispatcher {
		
		public static const EVENT_CHANGE:String = Event.CHANGE;
		
		public var mc:DisplayObjectContainer;
			public var mcUp:Sprite;
			public var mcDown:Sprite;
			public var mcHolder:DisplayObjectContainer;
				public var mcTrack:Sprite;
					public var mcTrackSprite:Sprite;
				public var mcSlider:Sprite;
		
		public var slider:Slider;
		public var _horizontal:Boolean = false;
		
		public function Scrollbar($mc:*) {
			mc = $mc as DisplayObjectContainer;
				mcUp = mc.getChildByName("mcUp") as Sprite;
				mcDown = mc.getChildByName("mcDown") as Sprite;
				mcHolder = mc.getChildByName("mcHolder") as Sprite;
					mcTrack = mcHolder.getChildByName("mcTrack") as Sprite;
						mcTrackSprite = mcTrack.getChildByName("mcTrackSprite") as Sprite;
					mcSlider = mcHolder.getChildByName("mcSlider") as Sprite;
			
			adjustSizes();
					
			/**
			 * Slider
			 */
			slider = new Slider(mcSlider, mcTrack);
			slider.addEventListener(Slider.EVENT_CHANGE, _onScrollChange, false, 0, true);
			
			/**
			 * Arrows
			 */
			mcUp.addEventListener(MouseEvent.MOUSE_DOWN, _startEnterframe, false, 0, true);
			mcDown.addEventListener(MouseEvent.MOUSE_DOWN, _startEnterframe, false, 0, true);
			
			mcUp.stage.addEventListener(MouseEvent.MOUSE_UP, _stopEnterframe, false, 0, true);
			mcDown.stage.addEventListener(MouseEvent.MOUSE_UP, _stopEnterframe, false, 0, true);
			
			mcUp.buttonMode = true;
			mcDown.buttonMode = true;
		}
		
		public function adjustSizes():void {
			
			var objSize:Object = { };
				objSize.w = mcTrack.width;
				objSize.h = mc.height - mcUp.height - mcDown.height;
		
			mc.scaleX = 1;
			mc.scaleY = 1;
			
			if (!_horizontal) {
				mcHolder.y = mcUp.y + mcUp.height;
				mcTrackSprite.height = objSize.h;
				mcDown.y = mcHolder.y + mcHolder.height;
			} else {
				
			}
		}
		
		public function destroy():void {
			
			mcUp.removeEventListener(MouseEvent.MOUSE_DOWN, _startEnterframe);
			mcDown.removeEventListener(MouseEvent.MOUSE_DOWN, _startEnterframe);
			
			mcUp.stage.removeEventListener(MouseEvent.MOUSE_UP, _stopEnterframe);
			mcDown.stage.removeEventListener(MouseEvent.MOUSE_UP, _stopEnterframe);
			
			_stopEnterframe(null);
			
			slider.removeEventListener(Slider.EVENT_CHANGE, _onScrollChange);
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
			slider.prev(3);
		}
		
		private function _next(evt:Event):void {
			slider.next(3);
		}
		
		private function _onScrollChange(evt:Event):void {
			dispatchEvent(new Event(Scrollbar.EVENT_CHANGE));
		}

	}
}




/*
import redneck.ui.Slider;
import redneck.ui.Drag;

var slider:Slider = new Slider(slider1.bt,slider1.bar,.5,true);
slider.addEventListener(Slider.EVENT_CHANGE, show, false, 0,true);
slider.addEventListener(Slider.EVENT_PRESS, show, false, 0,true);
slider.addEventListener(Slider.EVENT_RELEASE, show, false, 0,true);


var slider2:Slider = new Slider(bt2,bar2,0,true);
slider2.addEventListener(Slider.EVENT_CHANGE, show, false, 0,true);
slider2.addEventListener(Slider.EVENT_PRESS, show, false, 0,true);
slider2.addEventListener(Slider.EVENT_RELEASE, show, false, 0,true);

function show(e:Event):void{
	result2.text = slider2.percent + "%" 
	result.text = slider.percent + "%" 
}

show(null);

*/