package as3classes.sound {
	
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.events.Event;
	import flash.utils.*;
	import caurina.transitions.Tweener;
	
	import as3classes.sound.SoundControllerEvent;
	
	public class SoundController extends EventDispatcher {
		
		public var sound:Sound;
		public var loop:Boolean;
		public var channel:SoundChannel;
		public var position:int;
		public var isPlaying:Boolean;
		public var verbose:Boolean = false;
		
		private var _interval:uint = 0;
		
		public function SoundController() {
		}
		
		public function addSound($sound:Sound, $autoplay:Boolean = false, $loop:Boolean = false ):void {
			sound = $sound as Sound;
			//channel = sound.play();
			
			loop = $loop;
			
			position = 0;
			isPlaying = false;
			
			try {
				if ($autoplay) {
					play();
				} else {
					stop();
				}
			} catch (e:Error) {
				trace("* ERROR: " + e.message);
				dispatchEvent(new SoundControllerEvent(SoundControllerEvent.ERROR));
				clear();
			}
		}
		
		public function stop():void {
			if (sound != null && channel != null) {
				_stopCheckProgress();
				
				isPlaying = false;
				position = 0;
				channel.stop();
				
				_trace("! SoundController.stop called.");
			} else {
				_trace("* ERROR: SoundController sound and/or channel is undefined: " + sound);
			}
			
		}
		
		public function pause():void {
			
			_stopCheckProgress();
			
			isPlaying = false;
			position = channel.position;
			channel.stop();
			_trace("! SoundController.pause called at: " + getPosition());
		}
		
		public function play():void {
			if(!isPlaying){
				
				if (position == getTotal()) {
					position = 0;
				}
				
				channel = sound.play(position);
				isPlaying = true;
				
				_startCheckProgress();
				
				_trace("! SoundController.play called at: " + getPosition());
			}
		}
		
		public function playPause():void {
			if (isPlaying) {
				pause();
			} else {
				play();
			}
		}
		
		public function getPosition():int {
			return channel.position;
		}
		
		public function getTotal():int {
			return sound.length;
		}
		
		public function clear():void {
			stop();
			sound = null;
			channel = null;
		}
		
		private function _onComplete(evt:Event):void {
			
			dispatchEvent(new SoundControllerEvent(SoundControllerEvent.COMPLETE, getTotal(), getTotal()));
			_stopCheckProgress();
			
			position = getTotal();
			
			stop();
			if (loop) {
				play();
			}
			
		}
		
		private function _startCheckProgress():void {
			
			clearInterval(_interval);
			_interval = NaN;
			_interval = setInterval(_checkProgress, 100);
			
			if (!channel.hasEventListener(Event.SOUND_COMPLETE)) {
				channel.addEventListener(Event.SOUND_COMPLETE, _onComplete, false, 0, true);
			}
		}
		
		private function _stopCheckProgress():void {
			
			clearInterval(_interval);
			_interval = NaN;
			
			if(channel.hasEventListener(Event.SOUND_COMPLETE)){
				channel.removeEventListener(Event.SOUND_COMPLETE, _onComplete);
			}
		}
		
		private function _checkProgress():void {
			dispatchEvent(new SoundControllerEvent(SoundControllerEvent.PROGRESS, getPosition(), getTotal()));
		}
		
		/**
		 * Private function to trace if verbose is true.
		 * @param	str
		 */
		private function _trace(str:*):void {
			if (verbose) {
				trace(str);
			}
		}
	}
}