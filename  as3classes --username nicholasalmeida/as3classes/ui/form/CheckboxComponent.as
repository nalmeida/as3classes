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
		public var mcBg:*;
		public var mcCheckBoxState:*;
		public var fld_text:TextField;
		
		// Commom
		public var title:String = "";
		public var tabIndex:Number = 0;
		public var _required:Boolean = false;
		public var customErrorMessage:String;
		//
		
		// Checkbox only
		public var type:String = "input";
		public var label:String = "";
		public var align:String = "left";
		public var _selected:Boolean = false;
		//
		
		private const VALID_PROPS:Array = ["title", "type", "tabIndex", "required", "selected", "label", "align", "customErrorMessage"];
		public const _type:String = "checkbox";
		private var objSize:Object = { };
		
		function CheckboxComponent($mc:*, $initObj:Object = null) {
			
			mc = $mc as Sprite;
				fld_text = mc.getChildByName("fld_text") as TextField;
				mcCheckBoxState = mc.getChildByName("mcCheckBoxState") as MovieClip;
				//mcBg = mc.getChildByName("mcBg") as Sprite;
			
			mc.addEventListener(MouseEvent.CLICK, _onClick, false, 0, true);
			
			mc.tabEnabled = true;
			mc.mouseEnabled = true;
			mc.mouseChildren = false;
			mc.buttonMode = true;
			
				
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
			
			mcCheckBoxState.stop();
			
			_selected = selected;

			/**
			 * Adjusts the size and aply padding definitions
			 */
			resetSize();
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
				mcCheckBoxState.gotoAndStop(1);
			} else {
				selected = true;
				mcCheckBoxState.gotoAndStop("selected");
			}
		}
	}
}