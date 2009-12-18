package as3classes.ui.form {
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.events.FocusEvent;
	import flash.text.TextFieldType;
	
	import as3classes.util.TextfieldUtil;
	import caurina.transitions.Tweener;

	public class TextfieldComponent {
		
		public var mc:DisplayObjectContainer;
		public var background:Sprite;
		public var fld_text:TextField;
		
		// Commom
		public var title:String = "";
		public var tabIndex:int = -1;
		public var _required:Boolean = false;
		public var _text:String = "";
		public var customErrorMessage:String;
		//
		
		// Textfield only
		public var selectable:Boolean = true;
		public var type:String = "input";
		public var restrict:String = "none";
		public var _initText:String = "";
		public var maxChars:Number = 0;
		public var minChars:Number; // used on form validation only.
		public var align:String = "left";
		public var custom:Array;
		public var equal:TextfieldComponent;
		public var padding:Object = { top: 0, left: 0, right: 0 };
		
		public static var listenersWeakReference:Boolean = true;
		//
		
		private const VALID_PROPS:Array = ["title", "type", "selectable", "tabIndex", "required", "restrict", "maxChars", "minChars", "text", "initText", "align", "equal", "customErrorMessage", "padding", "custom"];
		public const TYPE:String = "textfield";
		private var objSize:Object = { };
		
		function TextfieldComponent($mc:*, $initObj:Object = null) {
			
			mc = $mc as Sprite;
			
				fld_text = mc.getChildByName("fld_text") as TextField;
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
			if (title == "") trace("* WARNING: TextfieldComponent: " + mc + " parameter \"title\" undefined.");
			
			/**
			 * Adjusts the size and aply padding definitions
			 */
			adjustSizes();
			
			/**
			 * Applies characters restrictions min and max chars
			 */
			applyRestrictions();
			
			/**
			 * Listeners
			 */
			fld_text.addEventListener(FocusEvent.FOCUS_IN, clearInitText, false, 0, listenersWeakReference);
			fld_text.addEventListener(FocusEvent.FOCUS_OUT, checkInitText, false, 0, listenersWeakReference);
			
			/**
			 * TabIndex
			 */
			mc.tabEnabled = false;
			mc.tabChildren = true;
			fld_text.tabEnabled = true;
			if(tabIndex > -1) fld_text.tabIndex = tabIndex;
		}
		
		public function destroy():void {
			fld_text.removeEventListener(FocusEvent.FOCUS_IN, clearInitText);
			fld_text.removeEventListener(FocusEvent.FOCUS_OUT, checkInitText);
			
			mc = null;
			fld_text = null;
			background = null;
		}
		
		public function disable():void {
			TextfieldUtil.aplyRestriction(fld_text, "all");
			fld_text.selectable = false;
			Tweener.addTween(mc, {alpha: .7, time: .3, transition: "linear" } );
		}
		
		public function enable():void {
			applyRestrictions();
			fld_text.selectable = selectable;
			Tweener.addTween(mc, {alpha: 1, time: .3, transition: "linear" } );
		}
		
		public function applyRestrictions():void {
			TextfieldUtil.aplyRestriction(fld_text, restrict);
			fld_text.maxChars = maxChars;
			if (type == "password" && !initText) {
				fld_text.displayAsPassword = true;
			}else if (type === "dynamic") {
				fld_text.type = TextFieldType.DYNAMIC;
				fld_text.selectable = selectable;
			}
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
		
		public function set initText($initText:String):void {
			_initText = fld_text.text = $initText;
		}
	
		public function get initText():String {
			return _initText;
		}
		
		public function clearInitText(evt:FocusEvent):void {
			if (initText == fld_text.text) text = "";
			if (type == "password") fld_text.displayAsPassword = true;
			
		}
		public function checkInitText(evt:FocusEvent):void {
			
			if ((fld_text.text == initText || fld_text.text.length == 0) && initText.length > 0) text = initText;
			
			if (type == "password" && text.length>0) {
				fld_text.displayAsPassword = true;
			} else {
				fld_text.displayAsPassword = false;
			}
		}
		
		public function adjustSizes():void {
			if (padding.left == undefined) padding.left = 0;
			if (padding.top == undefined) padding.top = 0;
			
			objSize.w = mc.width;
			objSize.h = mc.height;
			
			mc.scaleX = 1;
			mc.scaleY = 1;
			
			if ((padding.right == undefined || padding.right == 0) && padding.left > 0) { // If right is 0, gets the left value
				padding.right = padding.left; 
			}
			
			fld_text.x = padding.left;
			fld_text.y = padding.top;
			
			background.width = objSize.w;
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