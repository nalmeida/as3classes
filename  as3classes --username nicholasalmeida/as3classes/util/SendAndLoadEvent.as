package as3classes.util {
	import flash.events.*;
	
	public class SendAndLoadEvent extends Event{
		
		/* The name of this event */
		public static const COMPLETE:String = "complete";
		public static const ERROR:String 	= "error";
		
		public var answer:*;
		
		public function SendAndLoadEvent(type:String, $answer:*, $dataType:String) {
			if($dataType == "xml") {
				this.answer = $answer as XML;
			} else if ($dataType == "error") {
				this.answer = $answer as String;
			}
			super(type);
		}
	}
}