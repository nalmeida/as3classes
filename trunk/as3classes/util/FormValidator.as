package as3classes.util {
	
	import as3classes.ui.form.TextareaComponent;
	import flash.events.EventDispatcher;
	import as3classes.util.FormValidatorEvent;
	import as3classes.ui.form.RadiobuttonComponent;
	
	/**
	 * TODO: Documentar a classe de validaform
	 @see
		<code>
			var textFieldPadding:Object = {left:5, top:-2};
			nome = new TextfieldComponent(mcForm.getChildByName("mcNome")  as Sprite);
			email = new TextfieldComponent(mcForm.getChildByName("mcEmail")  as Sprite);
			mensagem = new TextfieldComponent(mcForm.getChildByName("mcMensagem")  as Sprite);
			btEnviar = mcForm.getChildByName("btEnviar") as SimpleButton;
			
			nome.init( { 
					title: "Seu nome",
					required: true,
					minChars: 3,
					maxChars: 50,
					padding: textFieldPadding
				} );
				
			email.init( { 
					title: "Seu email",
					required: true,
					minChars: 3,
					maxChars: 50,
					restrict: "email",
					padding: textFieldPadding
				} );
				
			mensagem.init( { 
					title: "Mensagem",
					required: true,
					minChars: 3,
					maxChars: 1000,
					padding: {left: 5}
				} );
				
			validaForm = new FormValidator();
			validaForm.addField(nome);
			validaForm.addField(email);
			validaForm.addField(mensagem);
			
			validaForm.addEventListener(FormValidatorEvent.ERROR, _onError);
			validaForm.addEventListener(FormValidatorEvent.COMPLETE, _onOk);
				
			btEnviar.addEventListener(MouseEvent.CLICK, _validate, false, 0, true);
		</code>
	 */
	
	public class FormValidator extends EventDispatcher {
		
		private var arrToValidate:Array;
		private var arrButtons:Array;
		private static var _language:String = "br";
		public static const EMAIL_REGEX:RegExp = /^[A-Z0-9._%+-]+@(?:[A-Z0-9-]+\.)+[A-Z]{2,4}$/i;
		
		public function FormValidator() {
			arrToValidate = [];
			arrButtons = [];
		}
		
		public function addField(fld:*):void {
			arrToValidate.push(fld);
		}
		
		public function addButton(bt:*):void {
			arrButtons.push(bt);
		}
		
		public function validate(skipValidation:Boolean = false):* {
			
			if (skipValidation) { // Skip validatio. Useful for test ON_OK method
				return _onComplete();
			}
			
			var fld:*;
			var t:String;
			var tmp:*;
			
			for (var i:int = 0; i < arrToValidate.length; i++) {
				
				fld = arrToValidate[i];
				t = fld.TYPE;
				
				if (t === "textfield" || t === "textarea") {
					
					/* ---------------------------------------------------------------------- Required */
					if(fld.required === true) {
						tmp = _checkRequired(fld);
						if (tmp !== true) return _onError(tmp);
					}
					
					/* ---------------------------------------------------------------------- Min */
					if(fld.text != ""){
						tmp = _checkMinChars(fld);
						if(tmp !== true) return _onError(tmp);
					}
					
					/* ---------------------------------------------------------------------- Max */
					if(fld.text != ""){
						tmp = _checkMaxChars(fld);
						if(tmp !== true) return _onError(tmp);
					}
					
					/* ---------------------------------------------------------------------- Email */
					if((fld.restrict == "email" || fld.restrict == "mail") && fld.text != "") {
						tmp = _checkEmail(fld);
						if(tmp !== true) return _onError(tmp);
					}
					
					/* ---------------------------------------------------------------------- Equal */
					if (fld.equal != null && (typeof(fld.equal) == typeof(fld))) {
						tmp = _checkEqual(fld);
						if(tmp !== true) return _onError(tmp);
					}
					/* ---------------------------------------------------------------------- CPF */
					if(fld.restrict == "cpf" && fld.text != "") {
						tmp = _checkCpf(fld);
						if(tmp !== true) return _onError(tmp);
					}

					
				} else if(t === "radiobutton"){
					/* ---------------------------------------------------------------------- Radio */
					if(fld.required === true) {
						tmp = _checkRadio(fld);
						if(tmp !== true) return _onError(tmp);
					}
				} else if(t === "checkbox"){
					/* ---------------------------------------------------------------------- Check */
					if(fld.required === true) {
						tmp = _checkCheck(fld);
						if(tmp !== true) return _onError(tmp);
					}
				} else if(t === "combobox"){
					/* ---------------------------------------------------------------------- Check */
					if(fld.required === true) {
						tmp = _checkCombo(fld);
						if(tmp !== true) return _onError(tmp);
					}
				}
				// ELSES
			}
			
			_onComplete();
			
		}
		
		public function get language():String {
			return _language
		}
		public function set language($language:String):void{
			_language = $language;
		}
		
		public function enable():void {
			for (var i:int = 0; i < arrToValidate.length; i++) {
				arrToValidate[i].enable();
			}
			
			for (var j:int = 0; j < arrButtons.length; j++) {
				// arrButtons[j].enabled = true;// TODO: Arrumar
			}
		}
		
		public function disable():void {
			for (var i:int = 0; i < arrToValidate.length; i++) {
				arrToValidate[i].disable();
			}
			
			for (var j:int = 0; j < arrButtons.length; j++) {
				// arrButtons[j].enabled = false;// TODO: Arrumar
			}
		}
		
		public function reset():void {
			for (var i:int = 0; i < arrToValidate.length; i++) {
				arrToValidate[i].reset();
			}
		}
		
		private function _onError(objError:Object):Boolean {
			dispatchEvent(new FormValidatorEvent(FormValidatorEvent.ERROR, objError, "error"));
			return false;
		}
		
		private function _onComplete():Boolean {
			dispatchEvent(new FormValidatorEvent(FormValidatorEvent.COMPLETE, true, "complete"));
			return true;
		}
		
		/**
		 * Textfield validations
		 */
		//{
		/* ---------------------------------------------------------------------- Required */
		private function _checkRequired(fld:*):*{
			
			//var tmpTxt:String = fld.text.replace(/\n|\r/g, "");
			var tmpTxt:String = fld.text;
			if (tmpTxt.length === 0) {
				if(fld.customErrorMessage != null) 
					return {fld:fld, message:fld.customErrorMessage};
				else 
					if (language == "en")
						return { fld:fld, message:"The field \"" + fld.title + "\" is required." };
					else
						return { fld:fld, message:"O campo \"" + fld.title + "\" deve ser preenchido." };
			}
			return true;
		}
		
		/* ---------------------------------------------------------------------- Min */
		public function _checkMinChars(fld:*):*{
			if(fld.text.length < fld.minChars) {
				if(fld.customErrorMessage)
					return {fld:fld, message:fld.customErrorMessage};
				else
					if(language == "en")
						return {fld:fld, message:"The field \"" + fld.title + "\" must have at least  " + fld.minChars + " characters."};
					else
						return {fld:fld, message:"O campo \"" + fld.title + "\" deve conter no mínimo " + fld.minChars + " caracteres."};
			}
			return true;
		}
		
		/* ---------------------------------------------------------------------- Max */
		public function _checkMaxChars(fld:*):*{
			if(fld.text.length > fld.maxChars) {
				if(fld.customErrorMessage)
					return {fld:fld, message:fld.customErrorMessage};
				else
					if(language == "en")
						return {fld:fld, message:"The field \"" + fld.title + "\" must have al maximum " + fld.maxChars + " characters."};
					else
						return {fld:fld, message:"O campo \"" + fld.title + "\" deve conter no máximo " + fld.maxChars + " caracteres."};
			}
			return true;
		}
		
		/* ---------------------------------------------------------------------- Email */
		public function _checkEmail(fld:*):*{
			
			var validEmail:Boolean = Boolean(fld.text.match(EMAIL_REGEX));
			
			if(!validEmail) {
				if(fld.customErrorMessage)
					return {fld:fld, message:fld.customErrorMessage};
				else
					if(language == "en")
						return {fld:fld, message: "\"" + fld.text + "\" isn't a valid e-mail for \"" + fld.title + "\" field."};
					else
						return {fld:fld, message: "\"" + fld.text + "\" não é considerado um endereço válido para o campo \"" + fld.title + "\"."};
			}
			return true;
		}
		/* ---------------------------------------------------------------------- Equal */
		public function _checkEqual(fld:*):*{
			if(fld.text != fld.equal.text) {
				if(fld.customErrorMessage)
					return {fld:fld, message:fld.customErrorMessage};
				else
					if(language == "en")
						return {fld:fld, message: "The field \"" + fld.title + "\" should be equalt to the \"" + fld.equal.title + "\" field."};
					else
						return {fld:fld, message: "O campo \"" + fld.title + "\" deve ser igual ao campo \"" + fld.equal.title + "\"."};
			}
			return true;
		}
		/* ---------------------------------------------------------------------- CPF */
		public function _checkCpf(fld:*):Object{
			if(!_isCpf(fld.text)) {
				if(fld.customErrorMessage)
					return {fld:fld, message:fld.customErrorMessage};
				else
					if(language == "en")
						return {fld:fld, message: "\"" + fld.text + "\" isn't a valid CPF for \"" + fld.title + "\" field."};
					else
						return {fld:fld, message: "\"" + fld.text + "\" não é considerado um valor válido de CPF para o campo \"" + fld.title + "\"."};
			}
			return true;
		}
		public static function _isCpf(cpf:String):Boolean{
			cpf = cpf.replace(/\.|-|\//g, "");
			if (cpf.length != 11 || cpf == "00000000000" || cpf == "11111111111" || cpf == "22222222222" || cpf == "33333333333" || cpf == "44444444444" || cpf == "55555555555" || cpf == "66666666666" || cpf == "77777777777" || cpf == "88888888888" || cpf == "99999999999")
				return false;
			var soma:Number = 0;
			for (var i:int = 0; i < 9; i++)
				soma += parseInt(cpf.charAt(i)) * (10 - i);
			var resto:Number = 11 - (soma % 11);
			if (resto == 10 || resto == 11)
				resto = 0;
			if (resto != parseInt(cpf.charAt(9)))
				return false;
			soma = 0;
			for (var j:int = 0; j < 10; j++)
				soma += parseInt(cpf.charAt(j)) * (11 - j);
			resto = 11 - (soma % 11);
			if (resto == 10 || resto == 11)
				resto = 0;
			if (resto != parseInt(cpf.charAt(10)))
				return false;
			return true;
		}
		
		/**
		 * Validate date format
		 * @param	day day of the date
		 * @param	month month of the date
		 * @param	year year of the date
		 * @return
		 */
		static public function isValidDate(day:int, month:int, year:int):Boolean {
			if ( day < 1 || day > 31 )
				return false;
			if ( month == 2 && day > (isLeapYear(year) ? 29 : 28) )
				return false;
			if ( month < 1 || month > 12 )
				return false;
			return true;
		}
		/**
		 * Returns if the year is a leap year
		 * @param	ano year to be verified
		 * @return
		 */
		static public function isLeapYear(year:int):Boolean {
			return (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
		}

		/**
		 * Radiobutton validation
		 */
		//{
		/* ---------------------------------------------------------------------- Required */
		public function _checkRadio(fld:*):*{
			if(RadiobuttonComponent.getSelectedAtGroup(fld.group).radio == null) {
				if(fld.customErrorMessage)
					return {fld:fld, message:fld.customErrorMessage};
				else
					if(language == "en")
						return {fld:fld, message:"You must select an option for \"" + fld.title + "\" field."};
					else
						return {fld:fld, message:"Selecione uma das opções para o campo \"" + fld.title + "\"."};
			}
			return true;
		}
		//}

		/**
		 * Checkbox validation
		 */
		//{
		/* ---------------------------------------------------------------------- Required */
		public function _checkCheck(fld:*):*{
			if(fld.selected == false) {
				if(fld.customErrorMessage != null)
					return {fld:fld, message:fld.customErrorMessage};
				else
					if(language== "en")
						return {fld:fld, message:"You must select the \"" + fld.title + "\" field."};
					else
						return {fld:fld, message:"Você deve selecionar o campo \"" + fld.title + "\"."};
			}
			return true;
		}
		//}
		/**
		 * ComboBox validation 
		 */
		//{
		/* ---------------------------------------------------------------------- Required */
		public function _checkCombo(fld:*):*{
			if(fld.value == null || fld.value == "0" || fld.value == 0) {
				if(fld.customErrorMessage)
					return {fld:fld, message:fld.customErrorMessage};
				else
					if(language == "en")
						return {fld:fld, message:"You must select some option from \"" + fld.title + "\" field."};
					else
						return {fld:fld, message:"Você deve selecionar alguma opção do campo \"" + fld.title + "\"."};
			}
			return true;
		}
		//}

	}
}