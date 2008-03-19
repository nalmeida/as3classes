package as3classes.ui.form {
	
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import as3classes.util.TextfieldUtil;
	import as3classes.ui.Scrollbar;
	
	import caurina.transitions.Tweener;

	public class TextareaComponent {
		
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
		public var mcScroll:DisplayObjectContainer;
		public var type:String = "textarea";
		public var restrict:String = "none";
		public var maxChars:Number = 0;
		public var minChars:Number; // used on form validation only.
		public var initText:String;
		public var align:String = "left";
		public var equal:TextfieldComponent;
		public var padding:Object = {top: 0, left: 0, right: 0, bottom: 0};
		public var scroll:Scrollbar;
		//
		
		private const VALID_PROPS:Array = ["title", "type", "tabIndex", "required", "restrict", "maxChars", "minChars", "text", "initText", "align", "equal", "customErrorMessage", "padding"];
		public const TYPE:String = "textfield";
		private var objSize:Object = { };
		
		function TextareaComponent($mc:*, $initObj:Object = null) {
			
			mc = $mc as Sprite;
			
				fld_text = mc.getChildByName("fld_text") as TextField;
				mcBg = mc.getChildByName("mcBg") as Sprite;
				mcScroll = mc.getChildByName("mcScroll") as Sprite;
			
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
			if (title == "") trace("* WARNING: TextareaComponent: " + mc + " parameter \"title\" undefined.");
			
			/**
			 * Adjusts the size and aply padding definitions
			 */
			adjustSizes();
			
			/**
			 * Applies characters restrictions min and max chars
			 */
			applyRestrictions();
			
			scroll = new Scrollbar(mcScroll);
			scroll.addEventListener(Scrollbar.EVENT_CHANGE, _onScroll, false, 0, true);
			
			fld_text.addEventListener(Event.CHANGE, _onChange, false, 0, true);
			
			//_onChange(null);
		}
		
		public function destroy():void {
			scroll.removeEventListener(Scrollbar.EVENT_CHANGE, _onScroll);
			fld_text.removeEventListener(Event.CHANGE, _onChange);
			
			scroll.destroy();
			scroll = null;
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
		
		public function adjustSizes():void {
			objSize.w = mc.width;
			objSize.h = mc.height;
			objSize.scaleY = mc.scaleY;
			
			mc.scaleX = 1;
			mc.scaleY = 1;
			
			if ((padding.right == undefined || padding.right == 0) && padding.left > 0) { // If right is 0, gets the left value
				padding.right = padding.left;
			}
			
			if ((padding.bottom == undefined || padding.bottom == 0) && padding.top > 0) { // If bottom is 0, gets the top value
				padding.bottom = padding.top; 
			}
			
			fld_text.x = padding.left;
			fld_text.y = padding.top;
			
			mcBg.width = objSize.w - mcScroll.width;
			mcBg.height = objSize.h;
			fld_text.width = objSize.w - padding.left - padding.right - mcScroll.width;
			fld_text.height = objSize.h - padding.top - padding.bottom;
			
			mcScroll.height = mcBg.height;
		}
	
		public function set text($text:String):void {
			_text = fld_text.text = $text;
		}
		
		public function get text():String{
			_text = fld_text.text;
			if(_text === "" || _text === initText) _text = "";
			return _text;
		}

		public function enableScroll():void {
			scroll.enable();
		}
		
		public function disableScroll():void {
			scroll.disable();
		}
		
		private function _onChange(evt:*):void {
			if (fld_text.textHeight > fld_text.height) {
				enableScroll();
				var nPos:Number = fld_text.scrollV / fld_text.maxScrollV;
				scroll.percent = (nPos < .2) ? 0 : nPos;
			} else {
				scroll.percent = 0;
				disableScroll();
			}
		}
		
		private function _onScroll(evt:Event ):void {
			fld_text.scrollV = Math.round(scroll.percent);
		}
	}
}