package as3classes.video {
	
	import flash.net.*;
	import flash.events.Event
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	
	import flash.events.EventDispatcher;
	
	public class YouTubeDecoder extends EventDispatcher{
		
		private var loader:Loader;
		private var abortId:uint;
		
		public var v:String;
		public var url:String;
		public var id:String;
		public var t:String;
		public var iurl:String;
		
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
			
			url = "http://www.youtube.com/v/" + v;
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.INIT, _onInit, false, 0, true);
			loader.load(new URLRequest (url));
			
			_trace ("Loading YouTube URL..");
		}
            
		private function _onInit (event:Event):void{
			//http://www.youtube.com/watch?v=IpVWZePn1Y8
			
			_trace ("Loaded, processing: " + loader.contentLoaderInfo.url);
			var urlVars:URLVariables = new URLVariables ();
				urlVars.decode (loader.contentLoaderInfo.url.split("?")[1]);
			
			id = urlVars.video_id;
			t = urlVars.t;
			iurl = urlVars.iurl
			
			_trace ("\t\t video_id:" + id);
			_trace ("\t\t t param:" + t);
			_trace ("\t\t thumbnail-url:" + iurl);
			
			var flvURL:String = _constructFLVURL (id, t);
			
			_trace ("YouTube FLV URL: " + flvURL);
			_trace ("Started Playing Video...");
			
			destroy();
		}
		
		private function _constructFLVURL(video_id:String, t:String):String{
			var str:String = "http://www.youtube.com/get_video.php?";
				str += "video_id=" + video_id;
				str += "&t=" + t;
			return str;
		}
		
		private function _trace (message:String):void {
			//outputText.text += message + "\n";
			trace (message);
		}
			
	}
}
