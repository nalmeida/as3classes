package as3classes.ui.sound {
	
	/**
    * @author Marcelo Miranda Carneiro
	*/
	
	import br.com.chiclets.sound.GlobalSound;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class GlobalSoundBar extends GlobalSound{
		
		private var _soundBar:SoundBar;
		
		public function GlobalSoundBar($container:Sprite, $initVolume:Number = 1, $initPanning:Number = 0):void {
			super($initVolume, $initPanning);
			_soundBar = new SoundBar($container);
			_soundBar.addEventListener(SoundBar.EVENT_REFRESH, _soundRefresh);
			_soundBar.volume = $initVolume;
		}
		
		private function _soundRefresh(e:Event):void {
			volume = _soundBar.volume;
		}
		
		public override function toString():String {
			return "[GlobalSoundBar]";
		}
	}
}
