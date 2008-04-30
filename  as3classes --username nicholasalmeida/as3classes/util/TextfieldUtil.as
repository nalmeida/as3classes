/*
	AS2classes Framework for ActionScript 2.0
	Copyright (C) 2007  Nicholas Almeida
	http://nicholasalmeida.com
	
	This library is free software; you can redistribute it and/or
	modify it under the terms of the GNU Lesser General Public
	License as published by the Free Software Foundation; either
	version 2.1 of the License, or (at your option) any later version.
	http://www.gnu.org/licenses/lgpl.html
	
	This library is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
	Lesser General Public License for more details.
	
	If needed, use this character converter:
	http://rishida.net/scripts/uniview/conversion.php
*/

package as3classes.util {
	
	/**
	TextfieldUtil.aplyRestriction method. Restrict the characters of a Textfield.
	
	@author Nicholas Almeida
	@version 03/07/07
	@since Flash Player 8
	
	@param textField:TextField - Textfield will receive the restriction.
	@param $restriction:String - Type of restriction. Valid values:
			<pre>
				alnum
				alphanumeric
				text
				message				
					letters, numbers, accentuation, space, -?!.@
				
				let
				letter
				letters
					letters, accentuation, space
					
				num
				number
				numbers
					numbers
				
				rest
				restrict
				pass
				passw
				password
					letters (lowercase), numbers, -_
				
				email
				mail
					letters (lowercase), numbers, -_@+.
				
				money
				mon
					numbers , $
				
				cpf
					numbers, .-
				
				rg
					letters(uppercase),  numbers, .-
				
				cnpf
					numbers, /.-
				
				disable
				all
					NONE character allowed
				
				none
					all character allowed
				
				$restriction
					the value of $restriction parameter
			</pre>
	
	@return  Return none.
	
	@example
		<code>
			TextfieldUtil.aplyRestriction(myTextField, "numbers");
		</code>
	*/
		
	import flash.text.TextField;
			
	public class TextfieldUtil {
		
		public static function aplyRestriction(textField:TextField, $restriction:String):void{
			
			var restriction:String = $restriction.toLowerCase();
			
			switch (restriction){
				case "alnum" :
				case "alphanumeric" :
				case "text" :
				case "message" :
					//"a-z A-Z 0-9 áàãâäéèêëíìîïóòõôöúùûüç\\s\\-?!.@";
					textField.restrict = "a-z A-Z 0-9 \u00E1\u00E0\u00E3\u00E2\u00E4\u00E9\u00E8\u00EA\u00EB\u00ED\u00EC\u00EE\u00EF\u00F3\u00F2\u00F5\u00F4\u00F6\u00FA\u00F9\u00FB\u00FC\u00E7\u00C1\u00C0\u00C3\u00C2\u00C4\u00C9\u00C8\u00CA\u00CB\u00CD\u00CC\u00CE\u00CF\u00D3\u00D2\u00D5\u00D4\u00D6\u00DA\u00D9\u00DB\u00DC\u00C7\\s\\-?!.@";
					break;
					
				case "let" :
				case "letter" :
				case "letters" :
					//"a-z A-Z áàãâäéèêëíìîïóòõôöúùûüç\\s";
					textField.restrict = "a-z A-Z \u00E1\u00E0\u00E3\u00E2\u00E4\u00E9\u00E8\u00EA\u00EB\u00ED\u00EC\u00EE\u00EF\u00F3\u00F2\u00F5\u00F4\u00F6\u00FA\u00F9\u00FB\u00FC\u00E7\u00C1\u00C0\u00C3\u00C2\u00C4\u00C9\u00C8\u00CA\u00CB\u00CD\u00CC\u00CE\u00CF\u00D3\u00D2\u00D5\u00D4\u00D6\u00DA\u00D9\u00DB\u00DC\u00C7\\s";
					break;
					
				case "num" :
				case "number" :
				case "numbers" :
					textField.restrict = "0-9";
					break;
					
				case "rest" :
				case "restrict" :
				case "pass" :
				case "passw" :
				case "password" :
					textField.restrict = "a-z0-9\\-_";
					break;
					
				case "email" :
				case "mail" :
					textField.restrict = "a-z0-9\\-_@+.";
					break;
					
				case "mon" :
				case "money" :
					textField.restrict = "$0-9,";
					break;
					
				case "cpf" :
					textField.restrict = "0-9\\-.";
					break;
					
				case "rg" :
					textField.restrict = "0-9\\-.A-Z";
					break;
					
				case "cnpj" :
					textField.restrict = "0-9\\-./";
					break;
					
				case "disable" :
				case "all" :
					textField.restrict = "-";
					break;
					
				case "none" : 
					textField.restrict = "^";
					break;
					
				default : 
					textField.restrict = $restriction || "^";
			}
		}
	}
}
