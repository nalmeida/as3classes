package as3classes.ui.form {
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import as3classes.util.TextfieldUtil;

	public class CheckboxComponent {
		
		public var mc:Sprite;
		public var background:*;
		public var checkboxState:*;
		public var fld_text:TextField;
		
		// Commom
		public var title:String = "";
		public var tabIndex:int = -1;
		public var _required:Boolean = false;
		public var customErrorMessage:String;
		//
		
		// Checkbox only
		public var label:String = "";
		public var align:String = "left";
		public var _selected:Boolean = false;
		//
		
		private const VALID_PROPS:Array = ["title", "type", "tabIndex", "required", "selected", "label", "align", "customErrorMessage"];
		public const TYPE:String = "checkbox";
		private var objSize:Object = { };
		
		function CheckboxComponent($mc:*, $initObj:Object = null) {
			
			mc = $mc as Sprite;
				fld_text = mc.getChildByName("fld_text") as TextField;
				checkboxState = mc.getChildByName("mcCheckBoxState") as MovieClip;
				//background = mc.getChildByName("mcBg") as Sprite;
			
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
			if (title == "" && required) trace("* WARNING: CheckboxComponent: " + mc + " parameter \"title\" undefined.");
			
			/**
			 * Sets the label value
			 */
			_setLabel();
			checkboxState.stop();
			if ($initObj[selected] == undefined) selected = false;
			else selected = true;
			
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
			if(tabIndex > -1) mc.tabIndex = tabIndex;
		}
		
		public function destroy():void {
			mc.removeEventListener(MouseEvent.CLICK, _onClick);
			mc = null;
			fld_text = null;
			checkboxState = null;
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
			_selected = $selected;
			//_onClick(null);
		}
		
		/**
		 * Private methods
		 */
		private function _setLabel():void {
			fld_text.text = label;
			fld_text.autoSize = TextFieldAutoSize.LEFT;
		}
		
		private function _onClick(evt:*):void {
			if (selected) {
				selected = false;
				checkboxState.gotoAndStop(1);
			} else {
				selected = true;
				checkboxState.gotoAndStop("selected");
			}
		}
	}
}