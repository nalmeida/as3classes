
//@original: http://groups.google.com/group/youtube-api-gdata/browse_thread/thread/3c98068961296b38/970777ce3db3551e?lnk=gst&q=Flex+3#970777ce3db3551e

package as3classes.video{

		import flash.display.DisplayObject;
        import flash.system.Security;
        import flash.display.Sprite;
        import flash.display.Loader;
        import flash.net.URLRequest;
        import flash.events.StatusEvent;
        import flash.net.LocalConnection;
		import flash.events.Event;
		import flash.events.IOErrorEvent;
		import flash.events.EventDispatcher;
		import flash.utils.setInterval;
		import flash.utils.clearInterval;
		
		
		import as3classes.video.VideoControllerEvent;

		/**
		 @see
		 <code>
			public function init():void{
				_youtube = new VideoControllerYouTube();
				_youtube.verbose = true;
				_youtube.init(holder, "AI39si6wrMCU8iALegU8weZAVpdD4lVCR4fsDgiTJGP32gXkPq9MSaJB9QlO8VrOpY7UGHnbKtyQTgo4bTD5IazUxqr7JC7rWQ", "yt.swf", true, true);
				_youtube.addEventListener(VideoControllerEvent.YOUTUBE_PLAYER_LOADED, _onPlayerLoaded);
			}
			
			public function _onPlayerLoaded(e:VideoControllerEvent):void {
				_youtube.loadVideoById("Eu-SCI9Ks_Y");				
			}
		 </code>
		 */
		
        public class VideoControllerYouTube extends EventDispatcher{
			private var _loader:Loader;
			private var _as3_to_as2:LocalConnection;
			private var _as2_to_as3:LocalConnection;
			
			public var videoId:String;
			public var devKey:String;
			public var container:Sprite;
			public var as2SWF:String;
			public var verbose:Boolean = false;
			public var duration:Number = 0;
			public var _time:Number = 0;
			public var _volume:Number = 100;
			public var avaliable:Boolean = false;
			
			public var isPlaying:Boolean;
			public var autoPlay:Boolean;
			public var loop:Boolean;
			
			public var _percentLoaded:Number = 0;
			public var _interval:uint;
			
			public function VideoControllerYouTube ():void {
			}
			
			public function init($container:*, $devKey:String, $as2SWF:String, $autoplay:Boolean = true, $loop:Boolean = false):void {
				
				container = $container as Sprite;
				devKey = $devKey; // To get a $devKey try: http://code.google.com/apis/youtube/dashboard/?newRegistration=1
				as2SWF = $as2SWF;
				
				autoPlay = $autoplay;
				loop = $loop;
				
				Security.allowDomain('www.youtube.com');
				Security.allowDomain('gdata.youtube.com');
				Security.allowInsecureDomain('gdata.youtube.com');
				Security.allowInsecureDomain('www.youtube.com');
				
				if(_as3_to_as2 == null){
					_as3_to_as2 = new LocalConnection();
					_as3_to_as2.addEventListener(StatusEvent.STATUS, onLocalConnectionStatusChange, false, 0, true);
				}
				
				
				if (_as2_to_as3 == null) {
					_as2_to_as3 = new LocalConnection();
					_as2_to_as3.addEventListener(StatusEvent.STATUS, onLocalConnectionStatusChange, false, 0, true);
					_as2_to_as3.client = this; //This enables the local connection to use functions of this class
					_as2_to_as3.connect("AS2_to_AS3");
				}
				
				_loader = new Loader();
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:*):void { trace("carregou"); }, false, 0, true);
				_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onSwfLoadError, false, 0, true);
				
				var url:String = as2SWF + "?devKey=" + devKey + "&" + "VideoControllerYouTube=" + String(Math.round(Math.random()  * 100 * new Date().getTime()));;
				_loader.load(new URLRequest(url));
				trace("[VideoControllerYouTube] Loading swf file:\n\t" + url);
			}
			
			private function _destroy():void {
				
				//_as3_to_as2.removeEventListener(StatusEvent.STATUS, onLocalConnectionStatusChange);
				//_as2_to_as3.removeEventListener(StatusEvent.STATUS, onLocalConnectionStatusChange);	
				
				//try{
					//_as3_to_as2.close();
					//_as2_to_as3.close();
				//} catch (e:Error) {
					//trace(e);
				//}
				
				//try {
					//_as3_to_as2 = null;
					//_as2_to_as3 = null;
				//} catch (e:Error) {
					//trace(e);
				//}
				
				if (_loader != null) {
					_loader.unload();
					container.removeChild(_loader);
					_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onSwfLoadError);
					_loader = null;
				}
				
				clearInterval(_interval);
				_interval = 0;
				
				dispatchEvent(new VideoControllerEvent(VideoControllerEvent.YOUTUBE_PLAYER_CLOSED, this));
			}
			
			public function stop():void {
				_as3_to_as2.send("AS3_to_AS2", "stopVideo");
				isPlaying = false;
				avaliable = false;
			}
			
			public function playPause():void {
				if (!isPlaying) {
					play();
				} else {
					pause();
				}
			}
			
			public function destroy():void {
				stop();
			}
			
			public function close():void {
				stop();
				_as3_to_as2.send("AS3_to_AS2", "closeVideo");
			}
			
			public function play():void {
				_as3_to_as2.send("AS3_to_AS2", "playVideo");
				isPlaying = true;
				dispatchEvent(new VideoControllerEvent(VideoControllerEvent.VIDEO_PLAY, this));
			}
			
			public function pause():void {
				_as3_to_as2.send("AS3_to_AS2", "pauseVideo");
				isPlaying = false;
				dispatchEvent(new VideoControllerEvent(VideoControllerEvent.VIDEO_PAUSE, this));
			}
			
			public function loadVideoById(id:String):void {
				videoId = id;
				_as3_to_as2.send("AS3_to_AS2", "loadVideoById", videoId);
			}
			
			public function get time():Number {
				_as3_to_as2.send("AS3_to_AS2", "getCurrentTime");
				return _time;
			}
			
			public function get remainingTime():Number {
				return (duration - time);
			}
			
			public function get percentPlayed():Number {
				return time / duration;
			}
			
			public function get percentLoaded():Number {
				_as3_to_as2.send("AS3_to_AS2", "getVideoPercentLoaded");
				return _percentLoaded;
			}
			
			
			public function set volume(amount:Number):void {
				amount = (amount > 1) ? 1 : (amount < 0) ? 0 : amount;
				_volume = amount;
				_as3_to_as2.send("AS3_to_AS2", "setVolume", Math.round(_volume * 100));
			}
			
			public function get volume():Number {
				_as3_to_as2.send("AS3_to_AS2", "getVolume");
				return _volume;
			}
			
			public function rewind():void {
				pause();
				seek(0);
			}
			
			public function seek($amount:Number):void {
				if ($amount > duration) $amount = duration;
				else if ($amount < 0) $amount = 0;
				_trace("[VideoControllerYouTube] seek : " + $amount);
				
				_as3_to_as2.send("AS3_to_AS2", "seekTo", $amount, true);
			}
			
			public function _setCurrentTime($time:Number):void {
				_time = $time
			}
			
			public function _setDuration($duration:Number):void {
				duration = $duration;
			}
			
			public function _setPercentLoaded($percentLoaded:Number):void {
				_percentLoaded = $percentLoaded;
			}
			
			// Handlers
			public function onSwfLoadError(e:IOErrorEvent):void {
				trace("[VideoControllerYouTube] ERROR: File not found: " + as2SWF);
				dispatchEvent(new VideoControllerEvent(VideoControllerEvent.LOAD_ERROR, null, "File not found: " + as2SWF));
				destroy();
			}
			
			public function onSwfLoadComplete():void { // This event is fired by the loaded SWF.
				container.addChild(_loader);
				dispatchEvent(new VideoControllerEvent(VideoControllerEvent.YOUTUBE_PLAYER_LOADED));
			}
			
			public function onPlayerStateChange(e:Number):void {
				//Possible values are unstarted (-1), ended (0), playing (1), paused (2), buffering (3), video cued (5).
				trace("[VideoControllerYouTube] State changed to: " + e);
				switch(e) {
					case -1 : 
						_destroy();
						break;
					case 0 : 
						if (loop) {
							rewind();
							play();
						} else {
							isPlaying = false;
							dispatchEvent(new VideoControllerEvent(VideoControllerEvent.VIDEO_PAUSE, this));
							dispatchEvent(new VideoControllerEvent(VideoControllerEvent.VIDEO_COMPLETE, this));
						}
						break;
					case 1 : 
						if (duration == 0) { // First Video Load
							if (!autoPlay) {
								pause();
							} else {
								play();
							}
						}
						if(_interval == 0) _interval = setInterval(_onEnterFrame, 200);
						break;
					case 2 : 
						isPlaying = false;
						dispatchEvent(new VideoControllerEvent(VideoControllerEvent.VIDEO_PAUSE, this));
						break;
					case 3 : 
						dispatchEvent(new VideoControllerEvent(VideoControllerEvent.LOAD_START, this));
						break;
					case 5 : 
						
						break;
				}
			}
			
			public function onError(e:Number):void {
				//100 for "Video not found."
				_trace("[VideoControllerYouTube] ERROR: " + e +  ". Video not found: " + videoId);
				dispatchEvent(new VideoControllerEvent(VideoControllerEvent.VIDEO_ERROR, null, "Video not found: " + videoId));
			}				
			
			private function onLocalConnectionStatusChange(e:StatusEvent):void{
				//trace(e);
			}
			
			private function _onEnterFrame():void {
				if (duration <= 0) {
					_as3_to_as2.send("AS3_to_AS2", "getDuration");
				} else {
					if(!avaliable){
						dispatchEvent(new VideoControllerEvent(VideoControllerEvent.VIDEO_START));
						avaliable = true;
					}
				}
				percentPlayed;
				percentLoaded;
				dispatchEvent(new VideoControllerEvent(VideoControllerEvent.LOAD_PROGRESS, this));
				dispatchEvent(new VideoControllerEvent(VideoControllerEvent.VIDEO_PROGRESS, this));
			}
				
			/**
			 * Private function to trace if verbose is true.
			 * @param	str
			 */
			private function _trace(str:*):void {
				if (verbose) {
					trace(str);
				}
			}				
        }

} 