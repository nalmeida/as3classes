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