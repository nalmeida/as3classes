package as3classes.ui.form {
	
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import caurina.transitions.Tweener;
	
	public class RadiobuttonComponent extends EventDispatcher{
		
		public var mc:Sprite;
		public var background:*;
		public var radiobuttonState:*;
		public var fld_text:TextField;
		
		// Commom
		public var title:String = "";
		public var tabIndex:int = -1;
		public var _required:Boolean = false;
		public var customErrorMessage:String;
		//
		
		// Radiobutton only
		public var label:String = "";
		public var value:String;
		public var align:String = "left";
		public var _selected:Boolean = false;
		public var group:String;
		private static var arrGroups:Array = [];
		//
		
		private const VALID_PROPS:Array = ["title", "tabIndex", "required", "selected", "value", "label", "align", "group", "customErrorMessage"];
		public const TYPE:String = "radiobutton";
		private var objSize:Object = { };
		
		function RadiobuttonComponent($mc:*, $initObj:Object = null) {
			
			mc = $mc as Sprite;
				fld_text = mc.getChildByName("fld_text") as TextField;
				radiobuttonState = mc.getChildByName("mcRadiobuttonState") as MovieClip;
				background = mc.getChildByName("mcBg") as Sprite;
			
			if ($initObj != null) {
				init($initObj as Object);
			}
		}
		
		public function init($initObj:Object):void {
			/**
			 * Setting values for avaliable properties
			 */
			if($initObj != null){
				for (var i:String in $initObj) {
					if (VALID_PROPS.indexOf(i, 0) == -1) {
						throw new Error("* ERROR: " + mc + " Unavaliable property: " + i, 0);
					}else {
						this[i] = $initObj[i];
					}
				}
			}
			if (title == "" && required) trace("* WARNING: RadiobuttonComponent: " + mc + " parameter \"title\" undefined.");
			
			if(group == null){
				throw new Error("* ERROR: RadiobuttonComponent group not defined.");
			}
			if(value == null){
				throw new Error("* ERROR: RadiobuttonComponent value not defined.");
			}
			arrGroups.push( { radio:this, group:group } );
			
			/**
			 * Sets the label value
			 */
			_setLabel();
			radiobuttonState.stop();
			
			if ($initObj.selected == undefined || $initObj.selected === false) _selected = false;
			else _selected = true;
			
			_changeState();
			
			/**
			 * Adjusts the size and aply padding definitions
			 */
			resetSize();
			
			/**
			 * Listeners
			 */
			mc.addEventListener(MouseEvent.CLICK, _onClick, false, 0, true);
			
			/**
			 * TabIndex
			 */
			mc.tabEnabled = true;
			mc.mouseEnabled = true;
			mc.mouseChildren = false;
			mc.buttonMode = true;
			mc.useHandCursor = false;
			if(tabIndex > -1) mc.tabIndex = tabIndex;
			
		}
		
		public function destroy():void {
			mc.removeEventListener(MouseEvent.CLICK, _onClick);
			mc = null;
			fld_text = null;
			radiobuttonState = null;
		}
		
		public function resetSize():void {
			objSize.w = mc.width;
			objSize.h = mc.height;
			
			mc.scaleX = 1;
			mc.scaleY = 1;
		}
		
		public function get required():Boolean {
			return _required;
		}
		
		public function set required($required:Boolean):void {
			_required = $required;
		}
		
		public function get selected():Boolean{
			return _selected;
		}
		
		public function set selected($selected:Boolean):void {
			resetOthers(this);
			_selected = $selected;
			_changeState();
		}
		
		public function reset():void {
			_selected = false;
			_changeState();
		}
		public function resetGroup():void {
			for (var i:int = 0; i < arrGroups.length; i++) {
				if (arrGroups[i].group == group) {
					arrGroups[i].radio._selected = false;
					arrGroups[i].radio._changeState();
				}
			}
		}
		
		public function resetOthers(me:RadiobuttonComponent):void {
			for (var i:int = 0; i < arrGroups.length; i++) {
				if (arrGroups[i].group == group && arrGroups[i].radio != me) {
					arrGroups[i].radio._selected = false;
					arrGroups[i].radio._changeState();
				}
			}
		}
		
		public static function getSelectedAtGroup($group:String):Object {
			for (var i:int = 0; i < arrGroups.length; i++) {
				if (arrGroups[i].group == $group && arrGroups[i].radio.selected === true) {
					return {radio: arrGroups[i].radio, value: arrGroups[i].radio.value};
				}
			}
			return {radio: null, value: null};
		}
		
		
		public function disable():void {
			mc.mouseEnabled = false;
			Tweener.addTween(mc, {alpha: .7, time: .3, transition: "linear" } );
		}
		public function enable():void {
			mc.mouseEnabled = true;
			Tweener.addTween(mc, {alpha: 1, time: .3, transition: "linear" } );
		}
		
		/**
		 * Private methods
		 */
		private function _setLabel():void {
			fld_text.text = label;
			fld_text.autoSize = TextFieldAutoSize.LEFT;
		}
		
		private function _changeState():void {
			if (!selected) {
				radiobuttonState.gotoAndStop(1);
			} else {
				radiobuttonState.gotoAndStop("selected");
			}
		}
		
		private function _onClick(evt:*):void {
			if (selected) {
				selected = false;
			} else {
				selected = true;
			}
			_changeState();
			
			dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
	}
}