package as3classes.form {
	import flash.events.*;
	
	public class FormValidatorEvent extends Event{
		
		/* The name of this event */
		public static const COMPLETE:String = "complete";
		public static const ERROR:String 	= "error";
		
		public var field:*;
		public var message:*;
		
		public function FormValidatorEvent(type:String, $answer:*, $dataType:String) {
			if ($dataType == "error") {
				this.field = $answer.fld;
				this.message = $answer.message as String;
			}
			super(type);
		}
	}
}