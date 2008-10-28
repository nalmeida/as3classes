package as3classes.util {
	import flash.events.*;
	
	public class XmlLoadEvent extends Event{
		
		/* The name of this event */
		public static const COMPLETE:String = "complete";
		public static const ERROR:String 	= "error";
		
		public var answer:*;
		
		public function XmlLoadEvent(type:String, $answer:*, $dataType:String) {
			if($dataType == "xml") {
				this.answer = $answer as XML;
			} else {
				this.answer = $answer as String;
			}
			super(type);
		}
	}
}