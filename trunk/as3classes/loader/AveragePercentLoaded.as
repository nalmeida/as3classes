package br.com.chiclets.loader {
	
	/**
    * @author Marcelo Miranda Carneiro
	*/
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class AveragePercentLoaded extends EventDispatcher {
		
		static public const PERCENT_REFRESH:String = "percentRefresh";
		static public const COMPLETE:String = "complete";
		static public var _instances:Array = [];
		
		static public function getByName($name:String):AveragePercentLoaded {
			var i:int;
			for (i = 0; i < _instances.length; i++) {
				if (_instances[i].name == $name) {
					return _instances[i];
				}
			}
			return null;
		}
		
		private var _name:String;
		private var _allItens:Array = [];
		private var _itemCounter:int = 0;
		private var _totalPercent:Array = [];
		private var _completeDispatched:Boolean = false;
		
		public function AveragePercentLoaded($name:String = ""):void {
			_instances.push(this);
			_name = ($name != "") ? $name : (new Date()).toString() +" "+ (Math.random()).toString();
		}
		
		public function add($itemName:String):void {
			_allItens[_itemCounter] = $itemName;
			_totalPercent[_itemCounter] = 0;
			_itemCounter++;
		}
		
		public function refresh($name:String, $percent:Number):void {
			if (_allItens.indexOf($name) < 0) {
				return;
			}
			
			_totalPercent[_allItens.indexOf($name)] = ($percent / _allItens.length);
			//trace("totalPercent: " + totalPercent);
			dispatchEvent(new Event(PERCENT_REFRESH));
			
			if ((Math.ceil(totalPercent * 100)/100) == 1 && _completeDispatched != true) {
				_completeDispatched = true;
				dispatchEvent(new Event(COMPLETE));
			}
		}
		
		public function getPercent($name:String):Number {
			return _totalPercent[_allItens.indexOf($name)];
		}
		
		public function get totalPercent():Number {
			var perc:Number = 0;
			var i:int;
			for (i = 0; i < _totalPercent.length; i++) {
				perc += _totalPercent[i];
			}
			if (perc >= 1) {
				perc = 1;
			}
			return perc;
		}
		
		public override function toString():String {
			return "[AveragePercentLoaded] || percents data:["+_totalPercent.join(',')+"]";
		}
		
	}
	
}
