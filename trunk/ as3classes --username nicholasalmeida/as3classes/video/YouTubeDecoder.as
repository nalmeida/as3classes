package as3classes.video {
	
	import flash.net.*;
	import flash.events.Event
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.system.LoaderContext;
	import flash.events.IOErrorEvent;
	import flash.events.EventDispatcher;
	import flash.system.Security;
	
	/**
	 * 
	 <code>
	 var yt:YouTubeDecoder = new YouTubeDecoder();
	 yt.decodeURL("http://br.youtube.com/watch?v=Eu-SCI9Ks_Y");
	 yt.addEventListener(Event.COMPLETE, function():void { trace("URL = " + yt.flvPath); } );
	 </code>
	 
	 */
	 
	//TODO: Fazer pegando os dados do Youtube http://code.google.com/support/bin/answer.py?answer=92715&useful=1&show_useful=1
	public class YouTubeDecoder extends EventDispatcher{
		
		private var loader:Loader;
		private var abortId:uint;
		private const YOUTUBE_APP:String = "http://www.youtube.com/v/";
		
		public var v:String;
		private var url:String;
		public var id:String;
		public var t:String;
		public var iurl:String;
		public var flvPath:String = "http://www.youtube.com/get_video.php?";
		
		private var _decodeURLvar:URLVariables;
		private var _onInitvar:URLVariables;
		
		public function YouTubeDecoder():void {
			Security.allowDomain(YOUTUBE_APP);
		}
		
		public function decodeURL(youTubeUrl:String):void {
			_decodeURLvar = new URLVariables ();
			try {
				_decodeURLvar.decode(youTubeUrl.split("?")[1]);
			} catch (e:Error) {
				throw new Error("* ERROR [YouTubeDecoder] YouTubeDecoder.decodeURL. Unable to decode youTubeUrl.");
			}
			v = _decodeURLvar.v;
			_decode();
		}
		
		public function decodeVideo(videoCode:String):void {
			v = videoCode;
			_decode();
		}
		
		public function destroy():void {
			if(loader != null) {
				loader.contentLoaderInfo.removeEventListener(Event.INIT, _onInit); // TODO: YouTubeDecoder. Adicionar weak reference.
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, _ioErrorHandler);
				loader.unload(); 
				loader = null;
			}
			
			_decodeURLvar = null;
			_onInitvar = null;
		}
		
		private function _decode():void {
			
			url = YOUTUBE_APP + v;
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.INIT, _onInit, false, 0, true);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _ioErrorHandler, false, 0, true);
			loader.load(new URLRequest (url));
		}
            
		private function _onInit (event:Event):void{
			_onInitvar = new URLVariables ();
				_onInitvar.decode (loader.contentLoaderInfo.url.split("?")[1]);
			
			id = _onInitvar.video_id;
			t = _onInitvar.t;
			iurl = _onInitvar.iurl
			
			flvPath += "video_id=" + id + "&t=" + t;
			dispatchEvent(new Event(Event.COMPLETE));
				
			destroy();
		}
		
	  
      private function _ioErrorHandler(event:IOErrorEvent):void {
          trace("====> ioErrorHandler: " + event);
      } 
		
	}
}
