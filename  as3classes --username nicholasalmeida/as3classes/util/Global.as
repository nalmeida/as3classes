package as3classes.util {

	public class Global {
		private static var obj:Object = {};
			
		public static function setVar(objItem:String, value:*):*{
			obj[objItem] = value;
		}
		public static function getVar(objItem:String):*{
			return obj[objItem];
		}
	}
}