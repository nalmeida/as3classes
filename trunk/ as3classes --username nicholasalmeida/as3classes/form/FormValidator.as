package as3classes.form {
	
	import flash.events.EventDispatcher;
	import as3classes.form.FormValidatorEvent;
	
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
			
			for (var i:int = 0; i < arrToValidate.length; i++) {
				
				var fld:* = arrToValidate[i];
				var t:String = fld.TYPE;
				var tmp:*;
				
				if (t === "textfield") {
					
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
					if(fld.restrict == "email" || fld.restrict == "mail") {
						tmp = _checkEmail(fld);
						if(tmp !== true) return _onError(tmp);
					}
					
				} else if (t === "checkbox") {
					
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
			
			if (fld.text.length === 0) {
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
	}
}