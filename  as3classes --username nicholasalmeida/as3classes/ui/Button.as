package as3classes.ui {
	
	/**
	* @author Marcelo Miranda Carneiro
	* @version 0.1.0
	*/
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class Button{
		
		private var _container:Sprite;
		private var _hitCoord:Rectangle;
		private var _hit:Sprite;
		
		public function Button($container:Sprite, $hitArea:Sprite = null):void {
			
			_container = $container;
			
			_hit = ($hitArea == null) ? new Sprite() : $hitArea as Sprite;
			
			if($hitArea == null){
				_hitCoord = _container.getRect(_container);
				_hit.graphics.beginFill(0xFF0000, 0);
				_hit.graphics.drawRect(_hitCoord.x, _hitCoord.y, _hitCoord.width, _hitCoord.height);
				_hit.graphics.endFill();
				_container.addChild(_hit);
				_hitCoord = null;
			}
			
			_container.hitArea = _hit;
			
			_container.buttonMode = true;
			_container.mouseChildren = false;
		}
		
		
		
		//{ listeners
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			_container.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			_container.removeEventListener(type, listener, useCapture);
		}
		//}
		
		
		//{ handlers
		public function disable():void {
			_container.buttonMode = false;
			_container.mouseEnabled = false;
		}
		public function enable():void {
			_container.buttonMode = true;
			_container.mouseEnabled = true;
		}
		//}
		
		
		
		public function get container():Sprite { return _container; }
		public function get hit():Sprite { return _hit; }
		public function set hit(value:Sprite):void {
			_hit = value;
		}
	
		public function toString():String {
			return "[Button]";
		}
	}
}