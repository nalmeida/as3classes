package as3classes.ui {
	
	/**
    * @author Marcelo Miranda Carneiro
	* @version 0.1.0
	*/
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class OverButton extends Button{

		static private var _globalOverLabel:String = "on";
		static public var _globalOutLabel:String = "out";

		static public function get globalOverLabel():String { return _globalOverLabel; }
		static public function set globalOverLabel(value:String):void {
			_globalOverLabel = value;
		}
		static public function get globalOutLabel():String { return _globalOutLabel; }
		static public function set globalOutLabel(value:String):void {
			_globalOutLabel = value;
		}
		
		private var _outLabel:String;
		private var _overLabel:String;
		private var _overContainer:MovieClip;
		
		public function OverButton($container:Sprite, $overContainer:MovieClip = null, $hitArea:Sprite = null):void {
			
			super($container, $hitArea);
			
			_overContainer = ($overContainer == null) ? container as MovieClip : $overContainer;
			_addOverListeners();
		}

		
		
		//{ listeners
		private function _addOverListeners():void {
			container.addEventListener(MouseEvent.ROLL_OVER, over);
			container.addEventListener(MouseEvent.ROLL_OUT, out);
		}
		private function _removeOverListeners():void {
			container.removeEventListener(MouseEvent.ROLL_OVER, over);
			container.removeEventListener(MouseEvent.ROLL_OUT, out);
		}
		//}

		
		
		//{ handlers
		public function over($evt:MouseEvent = null):void {
			overContainer.gotoAndPlay("over");
		}
		public function out($evt:MouseEvent = null):void {
			overContainer.gotoAndPlay("out");
		}
		public function select():void {
			over();
			disable();
		}
		public function unselect():void {
			out();
			enable();
		}
		override public function disable():void {
			_removeOverListeners();
			super.disable();
		}
		override public function enable():void {
			_addOverListeners();
			super.enable();
		}
		//}
		

		
		public function get overContainer():MovieClip { return _overContainer; }
		public function get overLabel():String { return _overLabel; }
		public function set overLabel(value:String):void {
			_overLabel = value;
		}
		public function get outLabel():String { return _outLabel; }
		public function set outLabel(value:String):void {
			_outLabel = value;
		}
	
		override public function toString():String {
			return "[OverButton]";
		}
	}
}