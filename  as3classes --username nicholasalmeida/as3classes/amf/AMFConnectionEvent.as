package as3classes.amf {
	
	import flash.events.Event;
	
	public class AMFConnectionEvent extends Event{
		
		public static const COMPLETE:String = "complete";
		public static const ERROR:String 	= "error";
		
		public var answer:*;
		public var errorObject:Object;
		
		public function AMFConnectionEvent(type:String, $answer:*) {
			if(type == COMPLETE) {
				this.answer = $answer;
			} else if (type == ERROR) {
				this.errorObject = $answer;
				this.answer = this.errorObject.description;
			}
			super(type);
		}
	}
}