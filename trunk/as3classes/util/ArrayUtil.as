package as3classes.util {
	
	public class ArrayUtil {
		
		// @original: http://interactivesection.wordpress.com/2008/01/16/random-array-generator-class-as3/
		public static function random(numElements:int, origArray:Array=null):Array{
			if (origArray==null || numElements>origArray.length) {
				origArray = (origArray==null)? new Array():origArray;
				for (var i:int = origArray.length; numElements>i; i++){
					origArray.push(i);
				}
			}
			//
			var tempArray:Array = new Array();
			tempArray = origArray.slice();
			var resultArray:Array = new Array();
			while (tempArray.length>0 && numElements>resultArray.length){
				var rdm:int = Math.floor(Math.random()*tempArray.length);
				resultArray.push(tempArray[rdm]);
				tempArray.splice(rdm,1);
			}
			//trace("returning generated array: "+resultArray);
			return resultArray;
		}
	}
	
}