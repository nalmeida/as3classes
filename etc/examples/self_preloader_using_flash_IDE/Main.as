package {
	import flash.display.Sprite;
	
	public class Main extends Sprite {
		public function Main() {
			trace(this + " created");
			super();
		}
		
		public override function toString():String {
			return "[Main]";
		}
	}
}