package as3classes.ui.loader {
	
	/**
    * @author Marcelo Miranda Carneiro
	*/
	
	import flash.display.MovieClip;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	public class LoaderIcon extends EventDispatcher{
		
		public const SHOW_COMPLETE:String = "showComplete";
		public const HIDE_COMPLETE:String = "hideComplete";
		public const SHOW_START:String = "showStart";
		public const HIDE_START:String = "hideStart";
		private var _container:MovieClip;
		private var _parent:DisplayObjectContainer;
		private var _animationScope:MovieClip;
		private var _position:Point;
		private var _visible:Boolean;
		private var _scale:Number;
		
		public function LoaderIcon($parent:DisplayObjectContainer, $container:MovieClip, $animationScope:MovieClip = null, $position:Point = null, $scale:Number = 1):void {
			
			_position = ($position != null) ? $position : new Point(0, 0);
			_scale = $scale;
			_parent = $parent;
			_container = $container;
			_animationScope = ($animationScope != null) ? $animationScope : _container;
			
			_container.x = _position.x;
			_container.y = _position.y;
			_container.scaleX = _container.scaleY = _scale;
			
			_position = null;
		}
		
		private function _initTransition():void {
			if (_container.stage == null) {
				_parent.addChild(_container);
			}
			_animationScope.play();
			_container.alpha = 0;
			_container.visible = true;;
		}
		private function _showComplete():void {
			_container.alpha = 1;
			dispatchEvent(new Event(SHOW_COMPLETE));
			_visible = true;
		}
		private function _hideComplete():void {
			_container.alpha = 0;
			_container.visible = false;
			_animationScope.stop();
			if(_container.stage != null){
				_container.parent.removeChild(_container);
			}
			dispatchEvent(new Event(HIDE_COMPLETE));
			_visible = false;
		}
		
		public function show($fx:Boolean = true):void {
			dispatchEvent(new Event(SHOW_START));
			_initTransition();
			if ($fx === true) {
				_showComplete();
			}else {
				_showComplete();
			}
		}
		public function hide($fx:Boolean = true):void {
			dispatchEvent(new Event(HIDE_START));
			_initTransition();
			if ($fx === true) {
				_hideComplete();
			}else {
				_hideComplete();
			}
		}
		
		public function get container():MovieClip { return _container; }
		public function get animationScope():MovieClip { return _animationScope; }
		
		public function set visible($value:Boolean):void {
			if (_visible === true) {
				show(false);
			} else {
				hide(false);
			}
		}
		public function get visible():Boolean { return _visible; }
		
		public override function toString():String {
			return "[LoaderIcon]";
		}
	}
}
