package as3classes.form {
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import com.adobe.utils.ArrayUtil;
	import as3classes.util.TextfieldUtil;

	public class TextfieldComponent {
		
		public var mc:*;
		public var mcBg:*;
		public var fld_text:TextField;
		
		// Commom
		public var title:String = "";
		public var tabIndex:Number = 0;
		public var required:Boolean = false;
		public var customErrorMessage:String;
		//
		
		// Textfield only
		public var type:String = "input";
		public var restrict:String = "none";
		public var maxChars:Number = 0;
		public var minChars:Number; // used on form validation only.
		public var text:String
		public var initText:String;
		public var align:String = "left";
		public var equal:TextfieldComponent;
		public var padding:Object = {top: 0, left: 0, right: 0};
		//
		
		private const _avaliableProperties:Array = ["title", "type", "tabIndex", "required", "restrict", "maxChars", "minChars", "text", "initText", "align", "equal", "customErrorMessage", "padding"];
		public const _type:String = "textfield";
		private var objSize:Object = { };
		
		function TextfieldComponent($mc:*, $initObj:* = null) {
			
			mc = $mc;
			fld_text = mc.getChildByName("fld_text");
			mcBg = mc.getChildByName("mcBg");
			
			if ($initObj != null) {
				init($initObj);
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
			if (title == "") trace("* WARNING: TextfieldComponent: " + mc + " parameter \"title\" undefined.");
			
			/**
			 * Adjusts the size and aply padding definitions
			 */
			resetSize();
			
			/**
			 * Applies characters restrictions min and max chars
			 */
			applyRestrictions();
		}
		
		public function applyRestrictions():void {
			TextfieldUtil.aplyRestriction(fld_text, restrict);
			fld_text.maxChars = maxChars;
		}
		
		public function resetSize():void {
			objSize.w = mc.width;
			objSize.h = mc.height;
			
			mc.scaleX = 1;
			mc.scaleY = 1;
			
			fld_text.x = padding.left;
			fld_text.y = padding.top;
			
			mcBg.width = objSize.w;
			fld_text.width = objSize.w - padding.left - padding.right;
		}
	
		public function getText():String{
			var value:String = fld_text.text;
			if(value === "" || value === initText) value = "";
			return value;
		}
	}
}