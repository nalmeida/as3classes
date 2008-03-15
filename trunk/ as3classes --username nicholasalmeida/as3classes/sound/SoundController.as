package as3classes.sound {
	
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.events.Event;
	import flash.media.SoundTransform;
	import flash.utils.*;
	import caurina.transitions.Tweener;
	
	import as3classes.sound.SoundControllerEvent;
	
	public class SoundController extends EventDispatcher {
		
		public var sound:Sound;
		public var loop:Boolean;
		public var channel:SoundChannel;
		public var transform:SoundTransform;
		public var position:int;
		public var isPlaying:Boolean;
		public var verbose:Boolean = false;
		public var volume:Number = 1;
		
		private var _interval:uint = 0;
		
		public function SoundController() {
		}
		
		public function addSound($sound:Sound, $autoplay:Boolean = false, $loop:Boolean = false ):void {
			sound = $sound as Sound;
			
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
				trace("* ERROR: addSound method " + e.message);
				dispatchEvent(new SoundControllerEvent(SoundControllerEvent.ERROR));
				clear();
			}
		}
		
		public function stop():void {
			try {
				_stopCheckProgress();
				
				isPlaying = false;
				position = 0;
				channel.stop();
				
				_trace("! SoundController.stop called.");
			} catch(e:Error) {
				_trace("* ERROR: stop method " + e.message);
			}
			
		}
		
		public function pause():void {
			
			_stopCheckProgress();
			
			isPlaying = false;
			position = getPosition();
			channel.stop();
			_trace("! SoundController.pause called at: " + position);
		}
		
		public function play():void {
			if(!isPlaying){
				
				if (position >= getTotal()) {
					position = 0;
				}
				
				channel = sound.play(position);
				transform = new SoundTransform();
				
				isPlaying = true;
				
				_startCheckProgress();
				
				_trace("! SoundController.play called at: " + position);
			}
		}
		
		public function playPause():void {
			if (isPlaying) {
				pause();
			} else {
				play();
			}
		}
		
		public function getPosition():* {
			try {
				return channel.position;
			} catch (e:Error) {
				trace("* ERROR: channel object " + e.message);
			}
		}
		
		public function getTotal():* {
			try {
				return sound.length;
			} catch (e:Error) {
				trace("* ERROR: sound object " + e.message);
			}
		}
		
		public function setVolume($volume:Number, _changeVolumeValue:Boolean = true):void {
			try {
				if (_changeVolumeValue) {
					volume = $volume;
					transform.volume = volume;
				} else { // Avoid volume change. Used on mute and unMute methods.
					transform.volume = $volume;
				}
				channel.soundTransform = transform;
			} catch (e:Error) {
				trace("* ERROR: SoundTransform object " + e.message);
			}
		}
		
		public function getVolume():Number {
			return volume;
		}
		
		public function mute():void {
			setVolume(0, false);
		}
		
		public function unMute():void {
			setVolume(volume, false);
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
			_interval = setInterval(_checkProgress, 10);
			
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