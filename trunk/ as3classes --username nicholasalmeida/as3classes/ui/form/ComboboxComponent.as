package as3classes.ui.form {
	
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.events.FocusEvent;
	
	import as3classes.util.TextfieldUtil;
	import as3classes.ui.ScrollbarComponent;
	import as3classes.util.DisplayobjectUtil;
	
	import caurina.transitions.Tweener;
	
	public class ComboboxComponent extends EventDispatcher{
		
		public var mc:DisplayObjectContainer;
		public var background:*;
		public var fld_text:TextField;
		public var openButton:Sprite;
		private var _itemMaster:Sprite;
		
		// Commom
		public var title:String = "";
		public var tabIndex:int = -1;
		public var _required:Boolean = false;
		public var customErrorMessage:String;
		//
		
		// TextareaComponent only
		public var rows:Number;
		public var data:Array;
		public var mcScroll:DisplayObjectContainer;
		public var padding:Object = {top: 0, left: 0, right: 0, bottom: 0};
		public var scroll:ScrollbarComponent;
		public var _arrItens:Array = [];
		//
		
		private const VALID_PROPS:Array = ["title", "tabIndex", "required", "restrict", "customErrorMessage", "padding", "rows", "data"];
		public const TYPE:String = "textarea";
		private var objSize:Object = { };
		
		function ComboboxComponent($mc:*, $initObj:Object = null) {
			
			mc = $mc as Sprite;
			
				fld_text = mc.getChildByName("fld_text") as TextField;
				background = mc.getChildByName("mcBg") as Sprite;
				openButton = mc.getChildByName("btOpen") as Sprite;
				mcScroll = mc.getChildByName("mcScroll") as Sprite;
				_itemMaster = mc.getChildByName("mcItem") as Sprite;
			
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
			if (isNaN(rows)) throw new Error("* EROOR ComboboxComponent: parameter \"rows\" undefined.");
			if (data == null) throw new Error("* EROOR ComboboxComponent: parameter \"data\" undefined.");
			if (title == "") trace("* WARNING ComboboxComponent: " + mc + " parameter \"title\" undefined.");
			
			/**
			 * Adjusts the size and aply padding definitions
			 */
			adjustSizes();
			
			/**
			 * Create Itens
			 */
			_addItens();
			
			/**
			 * Listeners
			 */
			scroll = new ScrollbarComponent(mcScroll);
			scroll.addEventListener(ScrollbarComponent.EVENT_CHANGE, _onScroll, false, 0, true);
			
			fld_text.addEventListener(Event.CHANGE, _onChange, false, 0, true);
			fld_text.addEventListener(MouseEvent.MOUSE_WHEEL, _onChange, false, 0, true);
			
			_onChange(null);
			
			/**
			 * TabIndex
			 */
			mc.tabEnabled = false;
			mc.tabChildren = true;
			fld_text.tabEnabled = true;
			if (tabIndex > -1) fld_text.tabIndex = tabIndex;
			
			/**
			 * 
			 */
			//close();
		}
		
		public function destroy():void {
			scroll.removeEventListener(ScrollbarComponent.EVENT_CHANGE, _onScroll);
			fld_text.removeEventListener(Event.CHANGE, _onChange);
			fld_text.removeEventListener(MouseEvent.MOUSE_WHEEL, _onChange);
			
			scroll.destroy();
			scroll = null;
			
			mc = null;
			fld_text = null;
			background = null;
			mcScroll = null;;
		}
		
		/**
		 * Enable and Disable Methods
		 */
		public function disable():void {
			Tweener.addTween(mc, { alpha: .7, time: .3, transition: "linear" } );
			disableScroll(false);
		}
		
		public function disableScroll($changeScrollAlpha:Boolean = true):void {
			scroll.disable();
			if($changeScrollAlpha) Tweener.addTween(mcScroll, {alpha: .7, time: .3, transition: "linear" } );
		}
		
		public function enable():void {
			Tweener.addTween(mc, { alpha: 1, time: .3, transition: "linear" } );
			enableScroll(false);
		}
		
		public function enableScroll($changeScrollAlpha:Boolean = true):void {
			scroll.enable();
			if($changeScrollAlpha) Tweener.addTween(mcScroll, {alpha: 1, time: .3, transition: "linear" } );
		}
		//
		
		public function open():void {
			scroll.enable();
			mcScroll.visible = true;
		}
		
		public function close():void {
			scroll.disable();
			mcScroll.visible = false;
		}
		
		public function reset():void {
		
		}
		
		public function get required():Boolean {
			return _required;
		}
		
		public function set required($required:Boolean):void {
			_required = $required;
		}
		
		public function adjustSizes():void {
			
			if (padding.left == undefined) padding.left = 0;
			if (padding.top == undefined) padding.top = 0;
			
			objSize.w = mc.width;
			objSize.h = mc.height;
			objSize.scaleY = mc.scaleY;
			
			mc.scaleX = 1;
			mc.scaleY = 1;
			
			mcScroll.scaleX = 1;
			mcScroll.scaleY = 1;
			
			if ((padding.right == undefined || padding.right == 0) && padding.left > 0) { // If right is 0, gets the left value
				padding.right = padding.left;
			}
			
			if ((padding.bottom == undefined || padding.bottom == 0) && padding.top > 0) { // If bottom is 0, gets the top value
				padding.bottom = padding.top; 
			}
			
			fld_text.x = padding.left;
			fld_text.y = padding.top;
			
			background.width = objSize.w - openButton.width;
			
			openButton.x = background.width;
			
			mcScroll.x = objSize.w - mcScroll.width;
			mcScroll.y = background.height;
			
			_itemMaster.width = objSize.w - mcScroll.width;
			
			fld_text.width = background.width - padding.left - padding.right;
			fld_text.height = background.height - padding.bottom;
		}
		
		private function _addItens():void {
			for (var j:int = 0; j < data.length; j++) {
				var newItem:Sprite = DisplayobjectUtil.duplicate(_itemMaster, true);
				newItem.y = (_itemMaster.height * j) + _itemMaster.y;
				_arrItens.push(newItem);
			}
			mc.removeChild(_itemMaster);
			_itemMaster = null;
			
			//TODO: Criar a classe ComboItem
		}
		
		private function _onChange(evt:*):void {
			if (fld_text.maxScrollV > 1) {
				enableScroll();
				scroll.percent = (fld_text.scrollV - 1) / (fld_text.maxScrollV - 1);
			} else {
				scroll.percent = 0;
				disableScroll();
			}
		}
		
		private function _onScroll(evt:Event ):void {
			fld_text.scrollV = ((fld_text.maxScrollV - 1) * scroll.percent) + 1;
		}
	}
}