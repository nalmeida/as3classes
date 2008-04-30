package as3classes.util{
	/*
	* Class NPA
	*
	* @author		Nicholas Almeida, nicholasalmeida.com
	* @version		1.0
	* @history		Created: 06/01/2006
	*
	* @usage		trace(NPA.encode("YOUR_STRING"));
	*				trace(NPA.decode("YOUR_STRING"));
	*/
	public class NPA{
		public static function encode(w:String):String {
			var e:String;
			var dt:Number = Number(new Date().getMilliseconds())+1;
			e = dt+"O";
			var i:int=0;
			while(i<w.length) {
				e += (w.charCodeAt(i))*dt + "O";
				i++;
			}
			i = NaN;
			dt = NaN;
			return e;
		}
		
		public static function decode(w:String):String {
			var d:Number = Number(w.slice(0,w.indexOf("O")));
			var a:Array = w.split("O");
			var s:Number;
			var _s:String = "";
			a.shift();
			a.pop();
			var b:Number = 0;
			while(b<a.length) {
				s = Number(a[b]/d);
				_s += String.fromCharCode(s);
				b++;
			}
			s = NaN;
			b = NaN;
			d = NaN;
			a = null;
			return _s;
		}
	}
}