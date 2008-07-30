package as3classes.util {
	
	public class StringUtil {
		private static var txtArrSt:Array;
		private static var txtSt:Array;

		public static function wordCapitalize(txt:String):String{
			txtArrSt = txt.split(" ");
			txtSt = [];
			for(var i:Number = 0; i<txtArrSt.length; i++) {
				txtSt.push(txtArrSt[i].slice(0,1).toUpperCase() + "" + txtArrSt[i].slice(1).toLowerCase() + (i==(txtArrSt.length-1)?"":" "));
			}
			return txtSt.join("");
		}
		public static function lowerCase(txt:String):String{
			return txt.toLowerCase();
		}
		public static function upperCase(txt:String):String{
			return txt.toUpperCase();
		}
		public static function capitalize(txt:String):String{
			return txt.slice(0,1).toUpperCase() + "" + txt.slice(1).toLowerCase();
		}
		
		private static var specialChars:Object = [
			{val:"a",let:"áàãâä"},
			{val:"e",let:"éèêë"},
			{val:"i",let:"íìîï"},
			{val:"o",let:"óòõôö"},
			{val:"u",let:"úùûü"},
			{val:"c",let:"ç"},
			{val:"A",let:"ÁÀÃÂÄ"},
			{val:"E",let:"ÉÈÊË"},
			{val:"I",let:"ÍÌÎÏ"},
			{val:"O",let:"ÓÒÕÔÖ"},
			{val:"U",let:"ÚÙÛÜ"},
			{val:"U",let:"Ç"}
		];
		public static function replaceSpecialChars($value:String, $spaceSymbol:String = "_"):String {
			var regex:RegExp;
			var returnString:String = $value;
			for (var i:int = 0; i < specialChars.length; i++) {
				regex = new RegExp("["+specialChars[i].let+"]", "g");
				returnString = returnString.replace(regex, specialChars[i].val);
				regex = null;
			}
			return returnString.replace(/ /g,$spaceSymbol);
		}
		public static function convertToURI($value:String):String {
			return replaceSpecialChars($value).replace(/[^a-zA-Z0-9_\.\-]/g, "-");
		}
		/**
			Replaces all special characters.
			
			@param source: String to replace characters from.
			@return String with characters replaced.
		public static function replaceSpecialChars(source:String):String {
			var strSpecial:String 	= "áàãâäéèêëíìîïóòõôöúùûüçÁÀÃÂÄÉÈÊËÍÌÎÏÓÒÕÔÖÚÙÛÜÇ";
			var strClear:String	 	= "aaaaaeeeeiiiiooooouuuucAAAAAEEEEEEEEOOOOOUUUUC";
			for (var i:Number = 0; i < strSpecial.split("").length; i++) {
				source = StringUtil.replace(, strSpecial.split("")[i], strClear.split("")[i]);
			}
			return source;
		}
		
		// Original from: http://www.actionscript.org/forums/showthread.php3?t=111952
		public static function replaceSpecialHTMLChars(str:String):String {
			if(!str) return "";
			var aryEntities:Object = new Object();
				aryEntities["&nbsp;"]   = "\u00A0"; // non-breaking space
				aryEntities["&iexcl;"]  = "\u00A1"; // inverted exclamation mark
				aryEntities["&cent;"]   = "\u00A2"; // cent sign
				aryEntities["&pound;"]  = "\u00A3"; // pound sign
				aryEntities["&curren;"] = "\u00A4"; // currency sign
				aryEntities["&yen;"]    = "\u00A5"; // yen sign
				aryEntities["&brvbar;"] = "\u00A6"; // broken vertical bar (|)
				aryEntities["&sect;"]   = "\u00A7"; // section sign
				aryEntities["&uml;"]    = "\u00A8"; // diaeresis
				aryEntities["&copy;"]   = "\u00A9"; // copyright sign
				aryEntities["&reg;"]    = "\u00AE"; // registered sign
				aryEntities["&deg;"]    = "\u00B0"; // degree sign
				aryEntities["&plusmn;"] = "\u00B1"; // plus-minus sign

			   // remove spaces from next three lines in actual code
				aryEntities["& sup1;"]   = "\u00B9"; // superscript one
				aryEntities["& sup2;"]   = "\u00B2"; // superscript two
				aryEntities["& sup3;"]   = "\u00B3"; // superscript three
				aryEntities["&acute;"]  = "\u00B4"; // acute accent
				aryEntities["&micro;"]  = "\u00B5"; // micro sign

			   // remove spaces from next three lines in actual code
				aryEntities["& frac14;"] = "\u00BC"; // vulgar fraction one quarter
				aryEntities["& frac12;"] = "\u00BD"; // vulgar fraction one half
				aryEntities["& frac34;"] = "\u00BE"; // vulgar fraction three quarters
				aryEntities["&iquest;"] = "\u00BF"; // inverted question mark
				aryEntities["&Agrave;"] = "\u00C0"; // Latin capital letter A with grave
				aryEntities["&Aacute;"] = "\u00C1"; // Latin capital letter A with acute
				aryEntities["&Acirc;"]  = "\u00C2"; // Latin capital letter A with circumflex
				aryEntities["&Atilde;"] = "\u00C3"; // Latin capital letter A with tilde
				aryEntities["&Auml;"]   = "\u00C4"; // Latin capital letter A with diaeresis
				aryEntities["&Aring;"]  = "\u00C5"; // Latin capital letter A with ring above
				aryEntities["&AElig;"]  = "\u00C6"; // Latin capital letter AE
				aryEntities["&Ccedil;"] = "\u00C7"; // Latin capital letter C with cedilla
				aryEntities["&Egrave;"] = "\u00C8"; // Latin capital letter E with grave
				aryEntities["&Eacute;"] = "\u00C9"; // Latin capital letter E with acute
				aryEntities["&Ecirc;"]  = "\u00CA"; // Latin capital letter E with circumflex
				aryEntities["&Euml;"]   = "\u00CB"; // Latin capital letter E with diaeresis
				aryEntities["&Igrave;"] = "\u00CC"; // Latin capital letter I with grave
				aryEntities["&Iacute;"] = "\u00CD"; // Latin capital letter I with acute
				aryEntities["&Icirc;"]  = "\u00CE"; // Latin capital letter I with circumflex
				aryEntities["&Iuml;"]   = "\u00CF"; // Latin capital letter I with diaeresis
				aryEntities["&ETH;"]    = "\u00D0"; // Latin capital letter ETH
				aryEntities["&Ntilde;"] = "\u00D1"; // Latin capital letter N with tilde
				aryEntities["&Ograve;"] = "\u00D2"; // Latin capital letter O with grave
				aryEntities["&Oacute;"] = "\u00D3"; // Latin capital letter O with acute
				aryEntities["&Ocirc;"]  = "\u00D4"; // Latin capital letter O with circumflex
				aryEntities["&Otilde;"] = "\u00D5"; // Latin capital letter O with tilde
				aryEntities["&Ouml;"]   = "\u00D6"; // Latin capital letter O with diaeresis
				aryEntities["&Oslash;"] = "\u00D8"; // Latin capital letter O with stroke
				aryEntities["&Ugrave;"] = "\u00D9"; // Latin capital letter U with grave
				aryEntities["&Uacute;"] = "\u00DA"; // Latin capital letter U with acute
				aryEntities["&Ucirc;"]  = "\u00DB"; // Latin capital letter U with circumflex
				aryEntities["&Uuml;"]   = "\u00DC"; // Latin capital letter U with diaeresis
				aryEntities["&Yacute;"] = "\u00DD"; // Latin capital letter Y with acute
				aryEntities["&THORN;"]  = "\u00DE"; // Latin capital letter THORN
				aryEntities["&szlig;"]  = "\u00DF"; // Latin small letter sharp s = ess-zed
				aryEntities["&agrave;"] = "\u00E0"; // Latin small letter a with grave
				aryEntities["&aacute;"] = "\u00E1"; // Latin small letter a with acute
				aryEntities["&acirc;"]  = "\u00E2"; // Latin small letter a with circumflex
				aryEntities["&atilde;"] = "\u00E3"; // Latin small letter a with tilde
				aryEntities["&auml;"]   = "\u00E4"; // Latin small letter a with diaeresis
				aryEntities["&aring;"]  = "\u00E5"; // Latin small letter a with ring above
				aryEntities["&aelig;"]  = "\u00E6"; // Latin small letter ae
				aryEntities["&ccedil;"] = "\u00E7"; // Latin small letter c with cedilla
				aryEntities["&egrave;"] = "\u00E8"; // Latin small letter e with grave
				aryEntities["&eacute;"] = "\u00E9"; // Latin small letter e with acute
				aryEntities["&ecirc;"]  = "\u00EA"; // Latin small letter e with circumflex
				aryEntities["&euml;"]   = "\u00EB"; // Latin small letter e with diaeresis
				aryEntities["&igrave;"] = "\u00EC"; // Latin small letter i with grave
				aryEntities["&iacute;"] = "\u00ED"; // Latin small letter i with acute
				aryEntities["&icirc;"]  = "\u00EE"; // Latin small letter i with circumflex
				aryEntities["&iuml;"]   = "\u00EF"; // Latin small letter i with diaeresis
				aryEntities["&eth;"]    = "\u00F0"; // Latin small letter eth
				aryEntities["&ntilde;"] = "\u00F1"; // Latin small letter n with tilde
				aryEntities["&ograve;"] = "\u00F2"; // Latin small letter o with grave
				aryEntities["&oacute;"] = "\u00F3"; // Latin small letter o with acute
				aryEntities["&ocirc;"]  = "\u00F4"; // Latin small letter o with circumflex
				aryEntities["&otilde;"] = "\u00F5"; // Latin small letter o with tilde
				aryEntities["&ouml;"]   = "\u00F6"; // Latin small letter o with diaeresis
				aryEntities["&oslash;"] = "\u00F8"; // Latin small letter o with stroke
				aryEntities["&ugrave;"] = "\u00F9"; // Latin small letter u with grave
				aryEntities["&uacute;"] = "\u00FA"; // Latin small letter u with acute
				aryEntities["&ucirc;"]  = "\u00FB"; // Latin small letter u with circumflex
				aryEntities["&uuml;"]   = "\u00FC"; // Latin small letter u with diaeresis
				aryEntities["&yacute;"] = "\u00FD"; // Latin small letter y with acute
				aryEntities["&thorn;"]  = "\u00FE"; // Latin small letter thorn
				aryEntities["&yuml;"]   = "\u00FF"; // Latin small letter y with diaeresis

			while(str.indexOf('&') != -1 ){ // if it finds other occurences of the & symbol
				for(var entity:String in aryEntities){
					str =  replace(str, entity, aryEntities[entity]);
				}
			}
			return str;
		}
		*/

	}
}
