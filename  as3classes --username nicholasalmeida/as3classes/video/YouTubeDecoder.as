package as3classes.video {
	
	import flash.net.*;
	import flash.events.Event
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.system.LoaderContext;
	
	import flash.events.EventDispatcher;
	
	
	/**
	 * 
	 <code>
	 var yt:YouTubeDecoder = new YouTubeDecoder();
	 yt.decodeURL("http://br.youtube.com/watch?v=ek8iWRA6jzA");
	 yt.addEventListener(Event.COMPLETE, function():void { trace("URL = " + yt.flvPath); } );
	 </code>
	 
	 */
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
		
		public function decodeURL(youTubeUrl:String):void {
			var urlVars:URLVariables = new URLVariables ();
				urlVars.decode(youTubeUrl.split("?")[1]);
			v = urlVars.v;
			_decode();
		}
		
		public function decodeVideo(videoCode:String):void {
			v = videoCode;
			_decode();
		}
		
		public function destroy():void {
			loader.contentLoaderInfo.removeEventListener(Event.INIT, _onInit);
			loader.unload(); 
			loader = null;
		}
		
		private function _decode():void {
			
			url = YOUTUBE_APP + v;
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.INIT, _onInit);
			loader.load(new URLRequest (url));
		}
            
		private function _onInit (event:Event):void{
			var urlVars:URLVariables = new URLVariables ();
				urlVars.decode (loader.contentLoaderInfo.url.split("?")[1]);
			
			id = urlVars.video_id;
			t = urlVars.t;
			iurl = urlVars.iurl
			
			flvPath += "video_id=" + id + "&t=" + t;
			dispatchEvent(new Event(Event.COMPLETE));
				
			destroy();
		}
		
	}
}
