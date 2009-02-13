package as3classes.sound {
	
	/**
    * @author Marcelo Miranda Carneiro
	*/
	
	import flash.display.Sprite;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	
	public class GlobalSound{
		
		private var _soundTransform:SoundTransform;
		
		public function GlobalSound($initVolume:Number = .5, $initPanning:Number = 0):void {
			_soundTransform = new SoundTransform($initVolume, $initPanning);
			_refreshGlobalSoundMixer();
		}
		
		public function _refreshGlobalSoundMixer():void {
			SoundMixer.soundTransform = _soundTransform;
		}
		
		public function get leftToLeft():Number {return _soundTransform.leftToLeft}
		public function set leftToLeft(value:Number):void {
			_soundTransform.leftToLeft = value;
			_refreshGlobalSoundMixer();
		}
		public function get leftToRight():Number {return _soundTransform.leftToRight}
		public function set leftToRight(value:Number):void {
			_soundTransform.leftToRight = value;
			_refreshGlobalSoundMixer();
		}
		public function get pan():Number {return _soundTransform.pan}
		public function set pan(value:Number):void {
			_soundTransform.pan = value;
			_refreshGlobalSoundMixer();
		}
		public function get rightToLeft():Number {return _soundTransform.rightToLeft}
		public function set rightToLeft(value:Number):void {
			_soundTransform.rightToLeft = value;
			_refreshGlobalSoundMixer();
		}
		public function get rightToRight():Number {return _soundTransform.rightToRight}
		public function set rightToRight(value:Number):void {
			_soundTransform.rightToRight = value;
			_refreshGlobalSoundMixer();
		}
		public function get volume():Number {return _soundTransform.volume}
		public function set volume(value:Number):void {
			_soundTransform.volume = value;
			_refreshGlobalSoundMixer();
		}
		
		public function toString():String {
			return "[GlobalSound] volume: "+volume;
		}
	}
}
