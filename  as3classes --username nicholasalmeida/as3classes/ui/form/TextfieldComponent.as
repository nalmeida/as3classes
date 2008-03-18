package as3classes.ui.form {
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import as3classes.util.TextfieldUtil;
	
	import caurina.transitions.Tweener;

	public class TextfieldComponent {
		
		public var mc:DisplayObjectContainer;
		public var mcBg:*;
		public var fld_text:TextField;
		
		// Commom
		public var title:String = "";
		public var tabIndex:Number = 0;
		public var _required:Boolean = false;
		public var _text:String = "";
		public var customErrorMessage:String;
		//
		
		// Textfield only
		public var type:String = "input";
		public var restrict:String = "none";
		public var maxChars:Number = 0;
		public var minChars:Number; // used on form validation only.
		public var initText:String;
		public var align:String = "left";
		public var equal:TextfieldComponent;
		public var padding:Object = {top: 0, left: 0, right: 0};
		//
		
		private const VALID_PROPS:Array = ["title", "type", "tabIndex", "required", "restrict", "maxChars", "minChars", "text", "initText", "align", "equal", "customErrorMessage", "padding"];
		public const TYPE:String = "textfield";
		private var objSize:Object = { };
		
		function TextfieldComponent($mc:*, $initObj:Object = null) {
			
			mc = $mc as Sprite;
			
				fld_text = mc.getChildByName("fld_text") as TextField;
				mcBg = mc.getChildByName("mcBg") as Sprite;
			
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
		
		public function disable():void {
			TextfieldUtil.aplyRestriction(fld_text, "all");
			fld_text.selectable = false;
			Tweener.addTween(mc, {alpha: .7, time: .3, transition: "linear" } );
		}
		
		public function enable():void {
			applyRestrictions();
			fld_text.selectable = true;
			Tweener.addTween(mc, {alpha: 1, time: .3, transition: "linear" } );
		}
		
		public function applyRestrictions():void {
			TextfieldUtil.aplyRestriction(fld_text, restrict);
			fld_text.maxChars = maxChars;
		}
		
		public function reset():void {
			var v:String;
			if (initText != null) {
				v = initText;
			} else if (text != null) {
				v = text;
			} else {
				v = "";
			}
			fld_text.text = v;
			applyRestrictions();
		}
		
		public function get required():Boolean {
			return _required;
		}
		
		public function set required($required:Boolean):void {
			_required = $required;
		}
		
		public function resetSize():void {
			objSize.w = mc.width;
			objSize.h = mc.height;
			
			mc.scaleX = 1;
			mc.scaleY = 1;
			
			if ((padding.right == undefined || padding.right == 0) && padding.left > 0) { // If right is 0, gets the left value
				padding.right = padding.left; 
			}
			
			fld_text.x = padding.left;
			fld_text.y = padding.top;
			
			mcBg.width = objSize.w;
			fld_text.width = objSize.w - padding.left - padding.right;
		}
	
		public function set text($text:String):void {
			_text = fld_text.text = $text;
		}
		
		public function get text():String{
			_text = fld_text.text;
			if(_text === "" || _text === initText) _text = "";
			return _text;
		}
	}
}