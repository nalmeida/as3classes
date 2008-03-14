package as3classes.form {
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import com.adobe.utils.ArrayUtil;
	import as3classes.util.TextfieldUtil;

	public class CheckboxComponent {
		
		public var mc:DisplayObjectContainer;
		public var mcBg:*;
		public var mcCheckBoxState:*;
		public var fld_text:TextField;
		
		// Commom
		public var title:String = "";
		public var tabIndex:Number = 0;
		public var required:Boolean = false;
		public var customErrorMessage:String;
		//
		
		// Checkbox only
		public var type:String = "input";
		public var label:String = "";
		public var align:String = "left";
		public var selected:Boolean = false;
		//
		
		private const _avaliableProperties:Array = ["title", "type", "tabIndex", "required", "selected", "label", "align", "customErrorMessage"];
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
				
			if ($initObj != null) {
				init($initObj as Object);
			}
		}
		
		public function init($initObj:Object):void {
			
			/**
			 * Setting values for avaliable properties
			 */
			for (var name:String in $initObj) {
				if (!ArrayUtil.arrayContainsValue(_avaliableProperties, name)) {
					trace("* ERROR: " + mc + " Unavaliable property: " + name);
				} else { // Avaliable properties
					this[name] = $initObj[name];
				}
			}
			if (title == "" && required) trace("* WARNING: TextfieldComponent: " + mc + " parameter \"title\" undefined.");
			
			/**
			 * Sets the label value
			 */
			_setLabel();
			
			/**
			 * Sets the checkbox to selected or not.
			 */
			setSelected(selected);
			
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
		
		public function getValue():Boolean{
			return selected;
		}
		
		public function setSelected($selected:Boolean):void {
			selected = !$selected;
			_onClick(null);
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