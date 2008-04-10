package as3classes.video {
	
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.media.Video;
	import flash.net.NetStream;
	import flash.events.NetStatusEvent;
	import flash.events.Event;
	import flash.media.Video;
	import flash.media.SoundTransform;
	
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkErrorEvent;
	import br.com.stimuli.loading.BulkProgressEvent;
	
	import as3classes.video.VideoControllerEvent;
	
	/**
	 * 
	<code>
		public function Main():void {
			
			video = new Video(320, 240);
			addChild(video);
			
			control = new VideoController();
			
			control.addEventListener(VideoControllerEvent.LOAD_START, _onLoadInit);
			control.addEventListener(VideoControllerEvent.LOAD_PROGRESS, _onLoadProgress);
			control.addEventListener(VideoControllerEvent.LOAD_COMPLETE, _onLoadComplete);
			control.addEventListener(VideoControllerEvent.LOAD_ERROR, _onLoadError);
			
			control.addEventListener(VideoControllerEvent.VIDEO_START, _onInit);
			control.addEventListener(VideoControllerEvent.VIDEO_PROGRESS, _onProgress);
			control.addEventListener(VideoControllerEvent.VIDEO_COMPLETE, _onComplete);
			control.addEventListener(VideoControllerEvent.VIDEO_ERROR, _onError);
			
			
			control.init(FLV_FILE, video, 7, true, true);
			
			stage.addEventListener(MouseEvent.CLICK, _playPause );
		}
		
		private function _playPause(evt:MouseEvent):void {
			control.playPause(); 
		}
		
		private function _onLoadError(evt:VideoControllerEvent):void {
			trace("ERROR FILE: " + evt.errorFile);
		}
		private function _onLoadInit(evt:VideoControllerEvent):void {
			trace("Carregamento iniciado");
		}
		private function _onLoadProgress(evt:VideoControllerEvent):void {
			trace("LOAD: " + evt.percentLoaded + "%");
		}
		private function _onLoadComplete(evt:VideoControllerEvent):void {
			trace("Carregamento COMPLETO");
		}
		
		private function _onError(evt:VideoControllerEvent):void {
			trace(evt.errorMessage);
		}
		private function _onInit(evt:VideoControllerEvent):void {
			trace("V�deo dispon�vel");
		}
		
		private function _onComplete(evt:VideoControllerEvent):void {
			trace("V�deo completo");
		}
		
		private function _onProgress(evt:VideoControllerEvent):void {
			trace(evt.percentPlayed +  "%");
		}
	</code>
	 */
	public class VideoController extends Sprite{
		
		public var flv:String;
		public var flvId:String;
		public var video:Video;
		public var _netStream:NetStream;
		public var isPlaying:Boolean;
		public var verbose:Boolean = false;
		public var _duration:Number;
		public var position:Number = 0;
		
		public var autoPlay:Boolean;
		public var loop:Boolean;
		
		public var loader:BulkLoader;
		public var playAfterLoad:Number = .3;
		public var avaliable:Boolean = false;
		
		public var _percentLoaded:Number = 0;
		public var _volume:Number = 1;
		
		
		public function VideoController($flv:String = "", $video:Video = null, $duration:Number = NaN, $autoplay:Boolean = false, $loop:Boolean = false):void {
			if ($flv != "") init($flv, $video, $duration, $autoplay, $loop);
			loader = new BulkLoader(BulkLoader.getUniqueName());
		}
		
		public function init($flv:String, $video:Video, $duration:Number, $autoplay:Boolean = false, $loop:Boolean = false):void {
			try{
				flv = $flv;
			} catch (e:Error) {
				throw new Error("* ERROR [VideoController]: you MUST define $flv file.");
			}
			
			try{
				video = $video;
			} catch (e:Error) {
				throw new Error("* ERROR [VideoController]: you MUST define $video target.");
			}
			
			try{
				_duration = Math.round(int($duration * 1000)) / 1000;
			} catch (e:Error) {
				throw new Error("* ERROR [VideoController]: you MUST define $duration time.");
			}
			
			autoPlay = $autoplay;
			loop = $loop;
			isPlaying = false;
			flvId = "video_" + String(uint(Math.random() * new Date().getTime()));
			_load();
		}
		
		public function destroy():void {
			
			loader.remove(flvId);
			loader.removeFailedItems();
			
			loader.removeEventListener(BulkProgressEvent.PROGRESS, _onLoadProgress);
			loader.removeEventListener(BulkProgressEvent.COMPLETE, _onLoadComplete);
			loader.removeEventListener(BulkErrorEvent.ERROR, _onLoadError);
			loader = null;
			
			removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
			
			if(avaliable){
				stop();
				netStream.close();
				_netStream.removeEventListener(NetStatusEvent.NET_STATUS, _onNetStatus);
				netStream = null;
				video = null;
			}
		}
		
		public function set netStream($netStream:NetStream):void {
			if (_netStream == null) {
				_netStream = $netStream;
				_connect();
				_netStream.addEventListener(NetStatusEvent.NET_STATUS, _onNetStatus, false, 0, true);
			}
		}
		
		public function get netStream():NetStream {
			return (_netStream != null) ? _netStream : null;
		}
		
		public function set volume(amount:Number):void {
			amount = (amount > 1) ? 1 : (amount < 0) ? 0 : amount;
			_volume = amount;
			netStream.soundTransform = new SoundTransform(amount);
		}
		
		public function get volume():Number {
			return Number(netStream.soundTransform.volume);
		}
		
		public function get percentPlayed():Number {
			return time / _duration;
		}
		
		public function get duration():Number {
			return _duration;
		}
		
		public function get remainingTime():Number {
			return (duration - time);
		}
		
		public function get time():Number {
			return Math.round(int(netStream.time * 1000))/1000;;
		}
		
		public function playPause():Boolean {
			if (isPlaying) {
				pause();
			} else {
				play();
			}
			return isPlaying;
		}
		
		public function play():void {
			try {
				if (time >= duration) {
					seek(0);
				} 
				netStream.resume();
				isPlaying = true;
				_trace("! VideoController.play called at: " + time);
				dispatchEvent(new VideoControllerEvent(VideoControllerEvent.VIDEO_PLAY, this));
			} catch (e:Error) {
				//throw new Error("* ERROR [VideoController] play method : " + e.message);
				dispatchEvent(new VideoControllerEvent(VideoControllerEvent.VIDEO_ERROR, this, "* ERROR [VideoController] play method : netStream not avaliable."));
			}
		}
		
		public function pause():void {
			try {
				position = netStream.time;
				netStream.pause();
				isPlaying = false;
				_trace("! VideoController.pause called at: " + time);
				dispatchEvent(new VideoControllerEvent(VideoControllerEvent.VIDEO_PAUSE, this));
			} catch (e:Error) {
				//throw new Error("* ERROR [VideoController] pause method : " + e.message);
				dispatchEvent(new VideoControllerEvent(VideoControllerEvent.VIDEO_ERROR, this, "* ERROR [VideoController] pause method : netStream not avaliable."));
			}
		}
		
		public function rewind():void {
			stop();
			pause();
		}
		
		public function seek($amount:Number):void {
			if ($amount > duration) $amount = duration;
			else if ($amount < 0) $amount = 0;
			_trace("! VideoController.seek : " + $amount);
			netStream.seek($amount);
		}
		
		public function stop():void {
			try {
				netStream.pause();
				seek(0);
				_trace("! VideoController.stop called at: " + netStream.time);
				dispatchEvent(new VideoControllerEvent(VideoControllerEvent.VIDEO_STOP, this));
			} catch (e:Error) {
				throw new Error("* ERROR [VideoController] stop method : " + e.message);
				dispatchEvent(new VideoControllerEvent(VideoControllerEvent.VIDEO_ERROR, this, "* ERROR [VideoController] stop method : netStream not avaliable."));
			}
		}
		
		public function close():void {
			
			loader.pause(flvId);
			loader.removePausedItems();
			if(netStream != null){
				netStream.close();
				_netStream.removeEventListener(NetStatusEvent.NET_STATUS, _onNetStatus);
			}
			_netStream = null;
			avaliable = false;
			isPlaying = false;
		}
		
		/**
		 * Private
		 */
		
		private function _load():void {
			
			loader.add(flv , {id: flvId, type: BulkLoader.TYPE_VIDEO, pausedAtStart: true});
			
			loader.addEventListener(BulkProgressEvent.PROGRESS, _onLoadProgress, false, 0, true);
			loader.addEventListener(BulkProgressEvent.COMPLETE, _onLoadComplete, false, 0, true);
			loader.addEventListener(BulkErrorEvent.ERROR, _onLoadError, false, 0, true);
			
			loader.start();
			
			dispatchEvent(new VideoControllerEvent(VideoControllerEvent.LOAD_START, this));
		}
		 
		private function _onLoadError(evt:BulkErrorEvent):void {
			dispatchEvent(new VideoControllerEvent(VideoControllerEvent.LOAD_ERROR, this));
			loader.removeFailedItems();
			
			loader.removeEventListener(BulkProgressEvent.PROGRESS, _onLoadProgress);
			loader.removeEventListener(BulkProgressEvent.COMPLETE, _onLoadComplete);
		}
		
		private function _onLoadComplete(evt:BulkProgressEvent):void {
			dispatchEvent(new VideoControllerEvent(VideoControllerEvent.LOAD_COMPLETE, this));
			
			loader.removeEventListener(BulkProgressEvent.PROGRESS, _onLoadProgress);
			loader.removeEventListener(BulkErrorEvent.ERROR, _onLoadError);
		}
		
		private function _onLoadProgress(evt:BulkProgressEvent):void {
			
			_percentLoaded = evt.percentLoaded;
			
			if (_percentLoaded > playAfterLoad && !avaliable) {
				netStream = loader.getNetStream(flvId);
				video.attachNetStream(netStream);
				avaliable = true;
				dispatchEvent(new VideoControllerEvent(VideoControllerEvent.VIDEO_START, this));
				addEventListener(Event.ENTER_FRAME, _onEnterFrame, false, 0, true);
				
				volume = _volume; // restoring the volume
			}
			
			dispatchEvent(new VideoControllerEvent(VideoControllerEvent.LOAD_PROGRESS, this));
		}
		 
		private function _onEnterFrame(evt:Event):void {
			if (isPlaying) {
				dispatchEvent(new VideoControllerEvent(VideoControllerEvent.VIDEO_PROGRESS, this));
			}
		}
		 
		private function _connect():void {
			if (!autoPlay) {
				stop();
			} else {
				play();
			}
		}
		 
		private function _onNetStatus(event:Object):void {
			//trace(" >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> " + event.info.code);
			switch (event.info.code) {
				//case "NetConnection.Connect.Success":
					//_connect();
					//_trace("! VideoController status: " + event.info.code);
					//break;
				//case "NetStream.Buffer.Full":
					//_connect();
					//_trace("! VideoController status: " + event.info.code);
					//break;
				case "NetStream.Seek.Notify":
					//trace("Foi para " + netStream.time);
					break;
				case "NetStream.Play.StreamNotFound":
					trace("* ERROR VideoController Stream not found.");
					dispatchEvent(new VideoControllerEvent(VideoControllerEvent.VIDEO_ERROR, this, "* ERROR [VideoController] play method : netStream not avaliable."));
					break;
				case "NetStream.Play.Stop":
					dispatchEvent(new VideoControllerEvent(VideoControllerEvent.VIDEO_COMPLETE, this));
					_trace("! VideoController complete.");
					if (loop) rewind();
					else pause();
					break;
			}
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