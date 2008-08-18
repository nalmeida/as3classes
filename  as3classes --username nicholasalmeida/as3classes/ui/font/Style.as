package  as3classes.ui.font {
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	
	/**
	* Style.
	* 
	* @author Marcelo Miranda Carneiro - mail: mcarneiro@gmail.com.
	* @version 0.1.1
	* @since 30.06.2008
	* @usage
	 	<code>
	 
	 		// set style
	 		var times:Font = new lib_Times() as Font; //where lib_Times is a font exported to a swc file
	 		var txtFormat:TextFormat = new TextFormat();
	 			txtFormat.font = times.fontName;
	 			txtFormat.align = TextFormatAlign.CENTER;
	 			txtFormat.size = 13;
	 
	 		Style.add("carneiro", null, txtFormat, {
	 			autoSize: TextFieldAutoSize.LEFT,
	 			wordWrap: true,
	 			antiAliasType: AntiAliasType.ADVANCED,
	 			thickness: 50
	 		});
	 
	 		// apply style
	 		Style.setStyle("carneiro", _fld1);
	 		Style.setStyle("carneiro", [_fld2, _fld3]);
	 
	 	</code>
	*/
	public class Style {
		
		public static var _styles:Object = { };
		
		/**
		 * add
		 * @param	$name style name
		 * @param	$modelTextField a base textfield to import the textFormat
		 * @param	$textFormat
		 * @param	$optTxtValues native textField properties
		 */
		public static function add($name:String, $modelTextField:TextField, $textFormat:TextFormat = null, $optTxtValues:Object = null):void {
			_styles[$name] = { };
			var obj:Object = _styles[$name];
			obj.baseFormat = ($modelTextField != null) ? $modelTextField.getTextFormat(0,1) : null;
			obj.textFormat = $textFormat;
			obj.optTxtValues = $optTxtValues;
		}
		
		/**
		 * setStyle
		 * @param	$name style name
		 * @param	$textField Can be a textfield or an array of textfields
		 * @param	$optTxtValues native textField properties
		 */
		public static function setStyle($name:String, $textField:*, $optTxtValues:Object = null):void {
			var obj:Object = _styles[$name];
			var optTxtVal:Object = $optTxtValues;
			var a:String;
			if (obj == null) {
				throw new Error("Style.setStyle ERROR: Style \""+$name+"\" does not exists.");
				return;
			}
			
			if ($optTxtValues != null) {
				if (obj.optTxtValues != null) {
					for (a in obj.optTxtValues) {
						if (optTxtVal[a] == null) {
							optTxtVal[a] = obj.optTxtValues[a];
						}
					}
				}
			}else {
				optTxtVal = obj.optTxtValues;
			}
			
			if ($textField.text == null) {
				for (var i:int = 0; i < $textField.length ; i++) {
					_applyEach($name, ($textField[i] as TextField), optTxtVal);
				}
			}else {
				_applyEach($name, $textField, optTxtVal);
			}
			
			obj = null;
			optTxtVal = null;
			a = null;
		}
		private static function _applyEach($name:String, $textField:TextField, $optTxtValues:Object):void {
			var obj:Object = _styles[$name];
			var i:String;
			$textField.embedFonts = true;
			if(obj.baseFormat != null)
				$textField.defaultTextFormat = obj.baseFormat;
			
			if ($optTxtValues != null) {
				for (i in $optTxtValues) {
					try{
						$textField[i] = $optTxtValues[i];
					}catch (e:Error) {
						trace(Style+" Warning: Custom TextField property is not valid: \"" + i + ": " + $optTxtValues[i]+"\"");
					}
				}
			}
			if (obj.textFormat != null) {
				$textField.defaultTextFormat = obj.textFormat;
			}
			obj = null;
		}
	}
}