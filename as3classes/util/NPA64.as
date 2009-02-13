package as3classes.util{
	/*
	* Class NPA64
	*
	* @author		Nicholas Almeida, nicholasalmeida.com
	* @version		1.0
	* @history		Created: 22/7/2008 14:57
	*
	* @usage		trace(NPA64.encode("YOUR_STRING"));
	*				trace(NPA64.decode("YOUR_STRING"));
	*/
	
	import as3classes.util.NPA;
	import as3classes.util.Base64;
	
	public class NPA64 {
		
		public static function encode(w:String):String {
			return Base64.encode(NPA.encode(w));
		}
		
		public static function decode(w:String):String {
			return NPA.decode(Base64.decode(w));
		}
	}
}