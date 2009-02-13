package as3classes.ui {
	
	import as3classes.util.DevUtil;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.events.EventDispatcher;
 	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	/**
		Create a static "alert" using default ou a custom skin.
		
		@author Nicholas Almeida nicholasalmeida.com
		@since 23/7/2008 18:26
		@usage
				<code>
					//////////////////////////////////////////////////////////////////////////////////
					// IMPORTANT
					//
					// When using skinBySprite, it MUST have this MovieClips AND instance names
					//////////////////////////////////////////////////////////////////////////////////
					
					+---------------------------------------------------+
					| 	_bg: Background MC								|
					| 													|
					| 	_tit_holder: MC contains title textfield		|
					| 		_fld_tit: Title textfield					|
					| 													|
					| 	_msg_holder: MC contains message textfield		|
					| 		_fld_msg: Message textfield					|
					| 													|
					| 	_bt_ok: The "close" button						|
					+---------------------------------------------------+
					
					// Alert.init(this); // Default skin
					
					Alert.init(this, {
						skinBySprite: alert_sprite // Sprite with MC's
					});
					
					Alert.addEventListener(Event.CLOSE, _onClosePop);
					Alert.addEventListener(Event.OPEN, _onOpenPop);
					
					private function _onOpenPop(e:Event):void {
						trace("open");
					}
						
					private function _onClosePop(e:Event):void {
						trace("close");
						Alert.destroy(); // removing elements
					}
				</code>
	 */
		
	public class Alert {
		// Config vars
		public static var onClose:Function;
		public static var useSkin:Boolean;
		public static var titleTextFormat:TextFormat;
		public static var messageTextFormat:TextFormat;
		public static var buttonTextFormat:TextFormat;
		
		public static var width:int = 320;
		public static var height:int = 180;
		public static var buttonText:String = " OK ";
		public static var defaultPadding:int = 5;
		public static var align:String = "mc";
		public static var skinBySprite:Sprite;
		public static var htmlText:Boolean = false;
		
		// Private
		private static var _isOpened:Boolean;
		
		// Screen
		private static var _mc:Sprite;
		
		public static var _holder:Sprite;
			public static var _bg:Sprite;
			public static var _bt_ok:Sprite;
				public static var _fld_ok:TextField;
			public static var _tit_holder:Sprite;
				public static var _fld_tit:TextField;
			public static var _msg_holder:Sprite;
				public static var _fld_msg:TextField;
		
		private static const VALID_PROPS:Array = ["skinBySprite", "align", "defaultPadding", "buttonText", "height", "width", "htmlText"];
		
		/**
		 * Init the Alert class and set the holder and config values.
		 * 
		 * @param	$holder 			Sprite or MovieClip Alert will be added.
		 * @param	$configObj 			Object	Object with config information.
		 * @param		.skinBySprite 	Sprite 	Sprite with skin MovieClips insde.
		 * @param		.align 			String	Alert align. Default "mc" (middle center)
		 * @param		.defaultPadding	int		If you are using the default skin, its the internal padding. Default: 5.
		 * @param		.buttonText		String	Text inside the button "ok". Default: " OK ".
		 * @param		.width			int		If you are using the default skin, it's the Alert width. Default: 320.
		 * @param		.height			int		If you are using the default skin, it's the Alert height. Default: 180.
		 * @param		.htmlText		boolean	If text is HTML. Default: false.
		 * 
		 * @return 	none;
		 */
		public static function init($holder:Sprite, $configObj:Object = null ):void {
			_holder = $holder as Sprite;
			
			DevUtil.addParams($configObj, Alert, VALID_PROPS);
			
			if (skinBySprite != null) {
				setSkin(skinBySprite)
			} else {
				useSkin = false;
			}
			
			_isOpened = false;
		}
		
		/**
		 * Set the Title, Message and fires the Event.OPEN.
		 * 
		 * @param	$message		String	Alert message.
		 * @param	$title			String	Alert title
		 * @return	mc				Sprite	The openec Alert.
		 */
		public static function open($message:String, $title:String = "ERRO"):Sprite {
			if(!isOpened){
				_appySkin();
				
				if(!htmlText){
					_fld_tit.text = $title;
					_fld_msg.text = $message;
				} else {
					_fld_tit.htmlText = $title;
					_fld_msg.htmlText = $message;
				}
				
				if (!useSkin) {
					_fld_ok.text = buttonText;
					_bt_ok.y = height - (_fld_ok.height) - defaultPadding;
					_bt_ok.x = (width * .5) - (_fld_ok.width * .5);
					
					_fld_msg.height = height - (defaultPadding * 3) - _fld_tit.height - _fld_ok.height;
				}
				
				dispatchEvent(new Event(Event.OPEN));
				
				_isOpened = true;
			} else {
				trace("[Alert] Warning. Alert is already opened");
			}
			
			return mc;
		}
		
		/**
		 * Fires the event Event.CLOSE.
		 * 
		 * @param	e
		 */
		public static function close(e:MouseEvent = null):void {
			dispatchEvent(new Event(Event.CLOSE));
		}
		
		static public function get mc():Sprite { return _mc; }
		
		static public function set mc(value:Sprite):void {
			_mc = value;
		}
		
		static public function get isOpened():Boolean { return _isOpened; }
		
		/**
		 * Remove the Alert elements from holder stage.
		 * 
		 * @return	none
		 */
		public static function destroy():void {
			if (!useSkin) {
				try {
					if(_bt_ok.hasEventListener(MouseEvent.CLICK)) _bt_ok.removeEventListener(MouseEvent.CLICK, close);
					
					_tit_holder.removeChild(_fld_tit);
					_msg_holder.removeChild(_fld_msg);
					_bt_ok.removeChild(_fld_ok);
					mc.removeChild(_tit_holder);
					mc.removeChild(_msg_holder);
					mc.removeChild(_bt_ok);
					mc.removeChild(_bg);
					_holder.removeChild(mc);
					
					mc = null;
					_bg = null;
					_bt_ok = null;
					_fld_ok =  null;
					_tit_holder =  null;
					_fld_tit =  null;
					_msg_holder =  null;
					_fld_msg = null;
					
					_isOpened = false;
				} catch (e:Error) {
					trace("[Alert] ERROR: Destroy method. " + e);
				}
			} else {
				try {
					if(_bt_ok.hasEventListener(MouseEvent.CLICK)) _bt_ok.removeEventListener(MouseEvent.CLICK, close);
					
					_holder.removeChild(mc);
					
					mc = null;
					_bg = null;
					_bt_ok = null;
					_tit_holder =  null;
					_fld_tit =  null;
					_msg_holder =  null;
					_fld_msg = null;
					
					_isOpened = false;
				} catch (e:Error) {
					trace("[Alert] ERROR: Destroy method. " + e);
				}
			}
		}
		
		/**
		 * Set the skinBySprite Sprite.
		 * 
		 * @param	$skinBySprite
		 */
		public static function setSkin($skinBySprite:Sprite):void {
			skinBySprite = $skinBySprite;
			useSkin = true;
		}
		
		
		// Provate methods
		
		private static function _appySkin():void {
			
			if (!useSkin) { // Default skin
			
				mc = new Sprite();
					_bg = new Sprite();
					_bt_ok = new Sprite();
						_fld_ok = new TextField();
					_tit_holder = new Sprite();
						_fld_tit = new TextField();
					_msg_holder = new Sprite();
						_fld_msg = new TextField();
				
				// BG
				_bg.graphics.beginFill(0xCCCCCC, 1);
				_bg.graphics.drawRect(0, 0, width, height);
				_bg.graphics.endFill();
				
				// TIT
				titleTextFormat = new TextFormat();
					titleTextFormat.size = 14;
					titleTextFormat.font = "Arial";
					titleTextFormat.bold = true;
				
				_tit_holder.y = defaultPadding;
				_tit_holder.x = defaultPadding;
					
					_fld_tit.textColor = 0xFFFFFF;
					_fld_tit.width = width - (defaultPadding * 2);
					_fld_tit.height = 20;
					_fld_tit.background = true;
					_fld_tit.backgroundColor = 0x0A246A;
					_fld_tit.defaultTextFormat = titleTextFormat;
				
				// MSG
				messageTextFormat = new TextFormat();
					messageTextFormat.size = 12;
					messageTextFormat.font = "Arial";
				
				_msg_holder.y = _tit_holder.y + _fld_tit.height + defaultPadding;
				_msg_holder.x = defaultPadding;
				
					_fld_msg.wordWrap = true;
					_fld_msg.multiline = true;
					_fld_msg.width = width - (defaultPadding * 2);
					_fld_msg.defaultTextFormat = messageTextFormat;
				
				// BT
				buttonTextFormat = new TextFormat();
					buttonTextFormat.size = 14;
					buttonTextFormat.font = "Arial";
					buttonTextFormat.bold = true;
					
				_fld_ok.defaultTextFormat = buttonTextFormat;
				_fld_ok.selectable = false;
				_fld_ok.background = true;
				_fld_ok.backgroundColor = 0xadadad;
				_fld_ok.autoSize = TextFieldAutoSize.LEFT;
				
				// ADD
				_holder.addChild(mc);
					mc.addChild(_bg);
					mc.addChild(_tit_holder);
						_tit_holder.addChild(_fld_tit);
					mc.addChild(_msg_holder);
						_msg_holder.addChild(_fld_msg);
					mc.addChild(_bt_ok);
						_bt_ok.addChild(_fld_ok);
					
				if (align.toLowerCase() == "mc") {
					mc.x = width * -.5;
					mc.y = height * -.5;
				}
			} else { // Custom skin
				mc = skinBySprite;
				_holder.addChild(mc);
				_bg = mc.getChildByName("_bg") as Sprite;
				_tit_holder = mc.getChildByName("_tit_holder") as Sprite;
					_fld_tit = _tit_holder.getChildByName("_fld_tit") as TextField;
				_msg_holder = mc.getChildByName("_msg_holder") as Sprite;
					_fld_msg = _msg_holder.getChildByName("_fld_msg") as TextField;
				_bt_ok = mc.getChildByName("_bt_ok") as Sprite;
				
			}
			
			_bt_ok.mouseChildren = false;
			_bt_ok.buttonMode = true;
			_bt_ok.addEventListener(MouseEvent.CLICK, close, false, 0, true);
			
		}
		
		//
		// Static EventDispatcher by gSkinner: http://www.gskinner.com/blog/archives/2007/07/building_a_stat_1.html
		//
		protected static var disp:EventDispatcher;
		public static function addEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean=false, p_priority:int=0, p_useWeakReference:Boolean=false):void {
			if (disp == null) { disp = new EventDispatcher(); }
			disp.addEventListener(p_type, p_listener, p_useCapture, p_priority, p_useWeakReference);
		}
		public static function removeEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean=false):void {
			if (disp == null) { return; }
			disp.removeEventListener(p_type, p_listener, p_useCapture);
		}
		public static function dispatchEvent(p_event:Event):void {
			if (disp == null) { return; }
			disp.dispatchEvent(p_event);
		}
	}
}