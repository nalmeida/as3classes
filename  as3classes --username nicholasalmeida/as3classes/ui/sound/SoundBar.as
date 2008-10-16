package as3classes.ui.sound {
	
	/**
    * @author Marcelo Miranda Carneiro
	*/
	
	import as3classes.util.DevUtil;
	import caurina.transitions.Tweener;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	import redneck.ui.Slider;
	
	public class SoundBar extends EventDispatcher{
		
		public static const EVENT_REFRESH:String = "refresh";
		
		private var _volumeBt:Sprite;
		private var _volumeTrackSlider:DisplayObjectContainer;
		private var _volumeBackground:DisplayObject;
		private var _volumeSlider:Sprite;
		private var _volumeTrack:Sprite;
		
		private var _sliderVolume:Slider;
		private var _volume:Number = 1;
		
		public function SoundBar($container:Sprite):void {
			_volumeBt = $container;
				_volumeTrackSlider = _volumeBt.getChildByName("volumeTrackSlider") as DisplayObjectContainer;
					_volumeBackground = _volumeTrackSlider.getChildByName("background") as DisplayObject;
					_volumeTrack = _volumeTrackSlider.getChildByName("track") as Sprite;
					_volumeSlider = _volumeTrackSlider.getChildByName("slider") as Sprite;

			_outBt();
			//_volumeBt.addEventListener(MouseEvent.CLICK, _overBt);
			_volumeBt.addEventListener(MouseEvent.MOUSE_OVER, _overBt);
			_volumeTrackSlider.visible = false;
		}
		
		
		//{ LISTENERS
		private function _overBt(evt:MouseEvent = null):void {
			
			_volumeBt.addEventListener(MouseEvent.MOUSE_OUT, _outBt);
			_volumeBt.removeEventListener(MouseEvent.MOUSE_OVER, _overBt);
			
			_volumeTrackSlider.visible = true;
			Tweener.pauseTweens(_volumeTrackSlider, "alpha");
			Tweener.addTween(_volumeTrackSlider, { 
				alpha:1, 
				time: .3, 
				transition: "linear"
			});
			
			resetSlider();
			_sliderVolume = new Slider(_volumeSlider, _volumeTrack, (1 - _volume), true, true);
				_sliderVolume.addEventListener(Slider.EVENT_CHANGE, _onVolumeChange);
				_sliderVolume.addEventListener(Slider.EVENT_PRESS, _disableOut);
				_sliderVolume.addEventListener(Slider.EVENT_RELEASE, _enableOut);
			
			_volumeBt.alpha = 1;
		}
		private function _outBt(evt:MouseEvent = null):void {
			
			_volumeBt.removeEventListener(MouseEvent.MOUSE_OUT, _outBt);
			_volumeBt.addEventListener(MouseEvent.MOUSE_OVER, _overBt);
			
			Tweener.pauseTweens(_volumeTrackSlider, "alpha");
			Tweener.addTween(_volumeTrackSlider, { 
				alpha:0,
				time: .3,
				transition: "linear",
				onComplete: function():void {
					resetSlider();
					_volumeTrackSlider.visible = false;
				}
			});
			
			_volumeBt.alpha = .5;
		}
		//}

		
		//{ 
		private function _enableOut(e:Event):void {
			_volumeBt.addEventListener(MouseEvent.MOUSE_OUT, _outBt);
			
			var _objectsUnderPoint:Array = _volumeBt.parent.getObjectsUnderPoint(new Point(_volumeBt.parent.mouseX, _volumeBt.parent.mouseY));
			var i:int;
			var isUnder:Boolean = false;
			for (i = 0; i < _objectsUnderPoint.length; i++) {
				if (_objectsUnderPoint[i].parent.name === "background") {
					isUnder = true;
					break;
				}
			}
			if (isUnder === false) {
				_outBt();
			}
		}
		private function _disableOut(e:Event):void {
			_volumeBt.removeEventListener(MouseEvent.MOUSE_OUT, _outBt);
		}
		//}
		
		

		//{
		private function _onVolumeChange(evt:Event):void {
			_volume = (1 - _sliderVolume.percent);
			dispatchEvent(new Event(EVENT_REFRESH));
		}
		private function resetSlider():void {
			if(_sliderVolume != null){
				_sliderVolume.removeEventListener(Slider.EVENT_CHANGE, _onVolumeChange);
				_sliderVolume.removeEventListener(Slider.EVENT_PRESS, _disableOut);
				_sliderVolume.removeEventListener(Slider.EVENT_RELEASE, _enableOut);
				_sliderVolume.destroy();
				_sliderVolume = null;
			}
		}
		//}
		
		
		
		public function get volume():Number { return _volume; }
		public function set volume($value:Number):void {
			_volume = $value;
			if (_sliderVolume != null) {
				_sliderVolume.percent = 1 - _volume;
			}
		}
		
		public override function toString():String {
			return "[SoundBar]";
		}
	}
}
