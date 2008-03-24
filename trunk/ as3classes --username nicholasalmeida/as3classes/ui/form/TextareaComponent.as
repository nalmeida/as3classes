package as3classes.ui.form {
	
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
	
	import caurina.transitions.Tweener;
	
	/**
	 @see
	 <code>
			textarea = new TextareaComponent(mcTextarea);
			
			textarea.init( { 
				title: "Mensagem",
				padding: { top:6, left:6 },
				initText: "escreva aqui!"
			} );
	 </code>
	 */
	public class TextareaComponent {
		
		public var mc:DisplayObjectContainer;
		public var mcBg:*;
		public var fld_text:TextField;
		
		// Commom
		public var title:String = "";
		public var tabIndex:int = -1;
		public var _required:Boolean = false;
		public var _text:String = "";
		public var customErrorMessage:String;
		//
		
		// Textfield only
		public var mcScroll:DisplayObjectContainer;
		public var type:String = "textarea";
		public var restrict:String = "none";
		public var htmlText:Boolean = false;
		public var maxChars:Number = 0;
		public var minChars:Number; // used on form validation only.
		public var _initText:String;
		public var align:String = "left";
		public var equal:TextareaComponent;
		public var padding:Object = {top: 0, left: 0, right: 0, bottom: 0};
		public var scroll:ScrollbarComponent;
		//
		
		private const VALID_PROPS:Array = ["title", "type", "tabIndex", "required", "restrict", "maxChars", "minChars", "text", "initText", "align", "equal", "customErrorMessage", "padding", "htmlText"];
		public const TYPE:String = "textarea";
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
			
			/**
			 * Listeners
			 */
			scroll = new ScrollbarComponent(mcScroll);
			scroll.addEventListener(ScrollbarComponent.EVENT_CHANGE, _onScroll, false, 0, true);
			
			fld_text.addEventListener(Event.CHANGE, _onChange, false, 0, true);
			fld_text.addEventListener(MouseEvent.MOUSE_WHEEL, _onChange, false, 0, true);
			fld_text.addEventListener(FocusEvent.FOCUS_IN, clearInitText, false, 0, true);
			fld_text.addEventListener(FocusEvent.FOCUS_OUT, checkInitText, false, 0, true);
			
			_onChange(null);
			
			/**
			 * TabIndex
			 */
			mc.tabEnabled = false;
			mc.tabChildren = true;
			fld_text.tabEnabled = true;
			if (tabIndex > -1) fld_text.tabIndex = tabIndex;
		}
		
		public function destroy():void {
			scroll.removeEventListener(ScrollbarComponent.EVENT_CHANGE, _onScroll);
			fld_text.removeEventListener(Event.CHANGE, _onChange);
			fld_text.removeEventListener(MouseEvent.MOUSE_WHEEL, _onChange);
			fld_text.removeEventListener(FocusEvent.FOCUS_IN, clearInitText);
			fld_text.removeEventListener(FocusEvent.FOCUS_OUT, checkInitText);
			
			scroll.destroy();
			scroll = null;
			
			mc = null;
			fld_text = null;
			mcBg = null;
			mcScroll = null;;
		}
		
		/**
		 * Enable and Disable Methods
		 */
		public function disable():void {
			TextfieldUtil.aplyRestriction(fld_text, "all");
			fld_text.selectable = false;
			Tweener.addTween(mc, { alpha: .7, time: .3, transition: "linear" } );
			disableScroll(false);
		}
		
		public function disableScroll($changeScrollAlpha:Boolean = true):void {
			scroll.disable();
			if($changeScrollAlpha) Tweener.addTween(mcScroll, {alpha: .7, time: .3, transition: "linear" } );
		}
		
		public function enable():void {
			applyRestrictions();
			fld_text.selectable = true;
			Tweener.addTween(mc, { alpha: 1, time: .3, transition: "linear" } );
			enableScroll(false);
		}
		
		public function enableScroll($changeScrollAlpha:Boolean = true):void {
			scroll.enable();
			if($changeScrollAlpha) Tweener.addTween(mcScroll, {alpha: 1, time: .3, transition: "linear" } );
		}
		//
		
		public function applyRestrictions():void {
			TextfieldUtil.aplyRestriction(fld_text, restrict);
			fld_text.maxChars = maxChars;
			if (type == "dynamic") fld_text.type = TextFieldType.DYNAMIC;
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
		
		public function clearInitText(evt:FocusEvent):void {
			if (htmlText) {
				trace("* ERROR TextareaComponent.clearInitText: if htmlText is true, can't use initText property");
			} else {
				if (initText == fld_text.text) text = "";
			}
			
		}
		public function checkInitText(evt:FocusEvent):void {
			if (htmlText) {
				trace("* ERROR TextareaComponent.checkInitText: if htmlText is true, can't use initText property");
			} else {
				if(fld_text.text == initText || fld_text.text.length == 0) text = initText;
			}
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
		
		public function set initText($initText:String):void {
			if (htmlText) {
				_initText = fld_text.htmlText = $initText;
			} else {
				_initText = fld_text.text = $initText;
			}
		}
	
		public function get initText():String {
			return _initText;
		}
		
		public function set text($text:String):void {
			if (htmlText) {
				_text = fld_text.htmlText = $text;
			} else {
				_text = fld_text.text = $text;
			}
			_onChange(null);			
		}
		
		public function get text():String{
			_text = fld_text.text;
			if(_text === "" || _text === initText) _text = "";
			return _text;
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