package as3classes.util {
	
	import flash.display.DisplayObjectContainer;
	
	public class MovieclipUtil{
		
		public static var verbose:Boolean = false;
		
		/**
			Swaps an object index to the highest index inside scope.
			
			@param $scope Container.
			@param $movieclip Movieclip, Srite, etc to be wapped.
			
			@author Nicholas Almeida nicholasalmeida.com
			@version 11/3/2008 18:43
			@usage
					<code>
						MovieclipUtil.swapToHightestIndex(spriteContainer, sprite);
					</code>
		 */
		
        public static function swapToHightestIndex($scope:DisplayObjectContainer, $movieclip:*):void {
			
			var highest:uint = 0;
			
			for (var i:uint = 0; i < $scope.numChildren - 1; i++) {
				var mc:* = $scope.getChildAt(i);
				
				if ($scope.getChildIndex(mc) > highest) highest = $scope.getChildIndex(mc);
			}
			
			if ($scope.getChildIndex($movieclip) < highest) {
				_trace("Swapping index of \"" + $movieclip + "\" from " + $scope.getChildIndex($movieclip) + " to " + highest);
				$scope.swapChildrenAt($scope.getChildIndex($movieclip), highest);
			} else {
				_trace("\"" + $movieclip + "\" is on the highest index " + highest);
			}
		}
		
		/**
			Returns the smallest proportion based on a min width and min height
			
			@param element Element.
			@param maxWidth Maximum width allowed.
			@param maxHeight Maximum height allowed.
			@return scale Minimum proportion of element without distortion. 
			
			@author Nicholas Almeida nicholasalmeida.com
			@version 14/4/2008 17:40
			@usage
					<code>
						trace(MovieclipUtil.getSmallestProportion(theBitmap, 500, 355));
					</code>
		 */
		public static function getSmallestProportion(element:*, maxWidth:Number, maxHeight:Number):Number {
			var scale:Number = 1;
			var scaleW:Number = 1;
			var scaleH:Number = 1;
			
			if (element.width >= maxWidth) {
				scaleW = maxWidth / element.width;
			}
		
			if (element.height >= maxHeight) {
				scaleH = maxHeight / element.height;
			}
			
			scale = scaleH < scaleW ? scaleH : scaleW; // seting the smallest size
			
			return scale;
		}
		
		/**
		 * Private function to trace if verbose is true.
		 * @param	str
		 */
		private static function _trace(str:*):void {
			if (verbose) {
				trace(str);
			}
		}
    }
}