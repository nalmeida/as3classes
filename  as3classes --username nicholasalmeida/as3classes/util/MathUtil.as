package as3classes.util {
	import flash.geom.Point;
	
	public class MathUtil {
		
		public static function getAngle($end:Point, $ini:Point = null, $relative:Boolean = false):Number {
			
			$ini = ($ini == null) ? new Point(0, 0) : $ini;
			
			var x:Number = ($end.x + $ini.x);
			var y:Number = ($end.y + $ini.y) * -1;
			var angle:Number = Math.atan(y/x)/(Math.PI / 180);
			
			if($relative === false){
				if (x < 0) {
					angle += 180;
				}
				if (x >= 0 && y < 0){
					angle += 360;
				}
			}else {
				
			}
			x = NaN;
			y = NaN;
			
			return angle;
		}

	}
}