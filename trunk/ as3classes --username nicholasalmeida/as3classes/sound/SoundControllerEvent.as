package as3classes.sound {
	
	import flash.events.*;
	
	public class SoundControllerEvent extends Event{
		
		/* The name of this event */
		public static const PROGRESS:String = "progress";
		public static const COMPLETE:String = "complete";
		public static const ERROR:String = "error";
		
		public var position:int;
		public var total:int;
		public var percentPlayed:Number;
		
		public function SoundControllerEvent(type:String, $position:int = 0, $total:int = 0) {
			if (type == "error") {
				position = 
				total = 
				percentPlayed = 0;
			} else {
				position = $position;
				total = $total;
				percentPlayed = Math.ceil((Math.ceil(position / 100)) / (Math.ceil(total / 100)) * 100) / 100;
			}
			
			super(type);
		}
	}
}