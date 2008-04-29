package as3classes.ui.video{
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Video;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import caurina.transitions.Tweener;
	import as3classes.video.VideoControllerYouTube;
	import as3classes.video.VideoControllerEvent;
	import redneck.ui.Slider;
	
	
	/**
	 <code>
			videoControl = new VideoComponent(video);
			videoControl.verbose = false;
			videoControl.init( {
				flv:"http://br.youtube.com/watch?v=Eu-SCI9Ks_Y",
				// LONG VIDEO // flv:"http://br.youtube.com/watch?v=W1nhljdqf0E&feature=bz303",
				youtube: true,
				duration: 11.712,
				playAfterLoad: .25,
				autoPlay: true,
				timeRegressive: false
			} );
	 </code>
	 */
	//TODO: Slider do vídeo
	//TODO: full screen? 
	public class VideoComponentYoutube extends Sprite {
		
		public var videoID:String;
		public var devKey:String;
		public var as2SWF:String;
		public var video:Sprite;
		public var duration:Number = 0;
		public var autoPlay:Boolean = false;
		public var loop:Boolean = false;
		public var videoWidth:int = 320;
		public var videoHeight:int = 240;
		public var youtube:Boolean = false;
		public var playAfterLoad:Number = .3;
		public var timeRegressive:Boolean = false;
		
		public var verbose:Boolean = false;
		
		public var mc:Sprite;
			public var background:Sprite;
			public var controlerBackground:Sprite;
			public var playerControl:Sprite;
				public var playPauseBt:MovieClip;
				public var rewindBt:Sprite;
				public var fld_time:TextField;
				
				public var trackSlider:Sprite;
					public var track:Sprite;
					public var slider:Sprite;
					public var sliderBackground:Sprite;
					
					public var volumeBt:Sprite;
						public var volumeTrackSlider:Sprite;
							public var volumeBackground:Sprite;
							public var volumeSlider:Sprite;
							public var volumeTrack:Sprite;
				
			public var holder:Sprite;
			
		public var control:VideoControllerYouTube;
		private var _sliderControl:Slider;
		private var _sliderVolume:Slider;
		private var _trackSize:Number = 0;
		
		
		private const VALID_PROPS:Array = ["videoWidth", "videoHeight", "loop", "autoPlay", "duration", "videoID", "playAfterLoad", "timeRegressive", "devKey", "as2SWF"];
		private const TYPE:String = "youtube";
		
		public function VideoComponentYoutube($mc:*, $initObj:Object = null):void{
			
			mc = $mc as Sprite;
				background = mc.getChildByName("background") as Sprite;
				playerControl = mc.getChildByName("playerControl") as Sprite;
					controlerBackground = playerControl.getChildByName("background") as MovieClip;
					playPauseBt = playerControl.getChildByName("playPause") as MovieClip;
					rewindBt = playerControl.getChildByName("rewind") as Sprite;
					fld_time = playerControl.getChildByName("fld_time") as TextField;
					trackSlider = playerControl.getChildByName("trackSlider") as Sprite;
						track = trackSlider.getChildByName("track") as Sprite;
						slider = trackSlider.getChildByName("slider") as Sprite;
						sliderBackground = trackSlider.getChildByName("background") as Sprite;
					
					volumeBt = playerControl.getChildByName("volumeBt") as Sprite;
						volumeTrackSlider = volumeBt.getChildByName("volumeTrackSlider") as Sprite;
							volumeBackground = volumeTrackSlider.getChildByName("background") as Sprite;
							volumeTrack = volumeTrackSlider.getChildByName("track") as Sprite;
							volumeSlider = volumeTrackSlider.getChildByName("slider") as Sprite;
					
				holder = mc.getChildByName("holder") as Sprite;
				
			video = new Sprite();
			holder.addChild(video);
			holder.mouseChildren = false;
			
			// Start Buttons
			
			holder.addEventListener(MouseEvent.CLICK, playPause, false, 0, true);
			
			playPauseBt.addEventListener(MouseEvent.CLICK, playPause, false, 0, true);
			playPauseBt.addEventListener(MouseEvent.MOUSE_OVER, _overBt, false, 0, true);
			playPauseBt.addEventListener(MouseEvent.MOUSE_OUT, _outBt, false, 0, true);
			
			rewindBt.addEventListener(MouseEvent.CLICK, rewind, false, 0, true);
			rewindBt.addEventListener(MouseEvent.MOUSE_OVER, _overBt, false, 0, true);
			rewindBt.addEventListener(MouseEvent.MOUSE_OUT, _outBt, false, 0, true);
			
			fld_time.addEventListener(MouseEvent.CLICK, changeTimeMode, false, 0, true);
			
			volumeBt.addEventListener(MouseEvent.CLICK, _openVolume, false, 0, true);
			volumeBt.addEventListener(MouseEvent.MOUSE_OVER, _openVolume, false, 0, true);
			volumeBt.addEventListener(MouseEvent.ROLL_OVER, _overBt, false, 0, true);
			volumeBt.addEventListener(MouseEvent.ROLL_OUT, _closeVolume, false, 0, true);
			
			control = new VideoControllerYouTube();
				control.addEventListener(VideoControllerEvent.LOAD_START, _onLoadInit, false, 0, true);
				control.addEventListener(VideoControllerEvent.LOAD_PROGRESS, _onLoadProgress, false, 0, true);
				control.addEventListener(VideoControllerEvent.LOAD_COMPLETE, _onLoadComplete, false, 0, true);
				control.addEventListener(VideoControllerEvent.LOAD_ERROR, _onLoadError, false, 0, true);
				control.addEventListener(VideoControllerEvent.YOUTUBE_PLAYER_LOADED, _onYouTubeLoaded, false, 0, true);
				control.addEventListener(VideoControllerEvent.YOUTUBE_PLAYER_CLOSED, _onYouTubeClosed, false, 0, true);
				
				control.addEventListener(VideoControllerEvent.VIDEO_START, _onVideoStart, false, 0, true);
				control.addEventListener(VideoControllerEvent.VIDEO_PROGRESS, _onVideoProgress, false, 0, true);
				control.addEventListener(VideoControllerEvent.VIDEO_COMPLETE, _onVideoComplete, false, 0, true);
				control.addEventListener(VideoControllerEvent.VIDEO_ERROR, _onVideoError, false, 0, true);
				
				control.addEventListener(VideoControllerEvent.VIDEO_PLAY, _onVideoPlay, false, 0, true);
				control.addEventListener(VideoControllerEvent.VIDEO_PAUSE, _onVideoPause, false, 0, true);
				control.addEventListener(VideoControllerEvent.VIDEO_STOP, _onVideoStop, false, 0, true);
			
			//_sliderControl = new Slider(slider, track, 0, true);
				//_sliderControl.addEventListener(Slider.EVENT_PRESS, pause, false, 0, true);
				//_sliderControl.addEventListener(Slider.EVENT_RELEASE, _onReleaseSlider, false, 0, true);
				//_sliderControl.addEventListener(Slider.EVENT_CHANGE, _onReleaseSlider, false, 0, true);
				
			_sliderVolume = new Slider(volumeSlider, volumeTrack, 0, true, true);
				_sliderVolume.addEventListener(Slider.EVENT_CHANGE, _onVolumeChange, false, 0, true);
				
			volumeTrackSlider.visible = false;
			
			_trackSize = sliderBackground.width - slider.width;
				
			if ($initObj != null) {
				init($initObj as Object);
			}
			
			disableControls();
			track.scaleX = 0;
		}
		
		public function init($initObj:Object):void {
			
			/**
			 * Setting values for avaliable properties
			 */
			if($initObj != null){
				for (var i:String in $initObj) {
					if (VALID_PROPS.indexOf(i, 0) == -1) {
						throw new Error("* ERROR: " + mc + " Unavaliable property: " + i, 0);
					}else {
						this[i] = $initObj[i];
					}
				}
			}
			
			if(videoID == null) {
				throw new Error("* ERROR [VideoComponentYoutube]: you MUST define videoID.");
			}
			
			if(devKey == null) {
				throw new Error("* ERROR [VideoComponentYoutube]: you MUST define a developer Key. To get a $devKey try: http://code.google.com/apis/youtube/dashboard/?newRegistration=1");
			}
			
			if(as2SWF == null) {
				throw new Error("* ERROR [VideoComponentYoutube]: you MUST define the path to your AS2 SWF Youtube video player.");
			}
			
			_changeVideo();
		}
		
		public function destroy():void {
			
			holder.removeEventListener(MouseEvent.CLICK, playPause);

			playPauseBt.removeEventListener(MouseEvent.CLICK, playPause);
			playPauseBt.removeEventListener(MouseEvent.MOUSE_OVER, _overBt);
			playPauseBt.removeEventListener(MouseEvent.MOUSE_OUT, _outBt);
			
			rewindBt.removeEventListener(MouseEvent.CLICK, rewind);
			rewindBt.removeEventListener(MouseEvent.MOUSE_OVER, _overBt);
			rewindBt.removeEventListener(MouseEvent.MOUSE_OUT, _outBt);
			
			fld_time.removeEventListener(MouseEvent.CLICK, changeTimeMode);
			
			volumeBt.removeEventListener(MouseEvent.CLICK, _openVolume);
			volumeBt.removeEventListener(MouseEvent.MOUSE_OVER, _openVolume);
			volumeBt.removeEventListener(MouseEvent.ROLL_OVER, _overBt);
			volumeBt.removeEventListener(MouseEvent.ROLL_OUT, _closeVolume);
			
			if(control != null){
				control.removeEventListener(VideoControllerEvent.LOAD_START, _onLoadInit);
				control.removeEventListener(VideoControllerEvent.LOAD_PROGRESS, _onLoadProgress);
				control.removeEventListener(VideoControllerEvent.LOAD_COMPLETE, _onLoadComplete);
				control.removeEventListener(VideoControllerEvent.LOAD_ERROR, _onLoadError);
				control.removeEventListener(VideoControllerEvent.YOUTUBE_PLAYER_LOADED, _onYouTubeLoaded);
				control.removeEventListener(VideoControllerEvent.YOUTUBE_PLAYER_CLOSED, _onYouTubeClosed);
				
				control.removeEventListener(VideoControllerEvent.VIDEO_START, _onVideoStart);
				control.removeEventListener(VideoControllerEvent.VIDEO_PROGRESS, _onVideoProgress);
				control.removeEventListener(VideoControllerEvent.VIDEO_COMPLETE, _onVideoComplete);
				control.removeEventListener(VideoControllerEvent.VIDEO_ERROR, _onVideoError);
				
				control.removeEventListener(VideoControllerEvent.VIDEO_PLAY, _onVideoPlay);
				control.removeEventListener(VideoControllerEvent.VIDEO_PAUSE, _onVideoPause);
				control.removeEventListener(VideoControllerEvent.VIDEO_STOP, _onVideoStop);
				
				control.destroy();
				
				control = null;
			}
			
			//_sliderControl.removeEventListener(Slider.EVENT_PRESS, pause);
			//_sliderControl.removeEventListener(Slider.EVENT_RELEASE, _onReleaseSlider);
			//_sliderControl.removeEventListener(Slider.EVENT_CHANGE, _onReleaseSlider);
			
			//_sliderControl.destroy();
			//_sliderControl = null;
			
			if(_sliderVolume != null){
				_sliderVolume.removeEventListener(Slider.EVENT_CHANGE, _onVolumeChange);
				_sliderVolume.destroy();
				_sliderVolume = null;
			}
			
			slider = null;
			track = null;
			playPauseBt = null;
			rewindBt = null;
			fld_time = null;
		}
		
		public function changeVideo($videoID:String):void {
			videoID = $videoID;
			
			// External Call of change Video
			if (control.avaliable) {
				rewind(null);
			}
			control.close();
			holder.visible = false;
		}
		
		private function _onYouTubeClosed(evt:VideoControllerEvent):void {
			_changeVideo();
		}
		
		private function _changeVideo():void {
			_startVideoLoading();
			
			disableControls();
			fld_time.text = (timeRegressive ? "-" : "" ) + "00:00";
			track.scaleX = 0;
		}
		
		public function rewind(evt:MouseEvent):void {
			control.rewind();
			slider.x = 0;
		}
		
		public function play(evt:*):void {
			control.play();
		}
		
		public function pause(evt:*):void {
			control.pause();
		}
		
		public function playPause(evt:*):void {
			control.playPause();
		}
		
		public function enableControls():void {
			volumeBt.buttonMode = 
			volumeBt.mouseEnabled = 
			volumeBt.useHandCursor = 
			
			fld_time.mouseEnabled = 
			
			rewindBt.buttonMode = 
			rewindBt.mouseEnabled = 
			rewindBt.useHandCursor = 
			
			holder.buttonMode = 
			holder.mouseEnabled = 
			holder.useHandCursor = 
			
			playPauseBt.buttonMode = 
			playPauseBt.mouseEnabled = 
			playPauseBt.useHandCursor = true;
			
			trackSlider.mouseChildren = true;
		}
		
		public function enable():void {
			enableControls();
		}
		
		public function disableControls():void {
			volumeBt.buttonMode = 
			volumeBt.mouseEnabled = 
			volumeBt.useHandCursor = 
			
			fld_time.mouseEnabled = 
			
			rewindBt.buttonMode = 
			rewindBt.mouseEnabled = 
			rewindBt.useHandCursor = 
			
			holder.buttonMode = 
			holder.mouseEnabled = 
			holder.useHandCursor = 
			
			playPauseBt.buttonMode = 
			playPauseBt.mouseEnabled = 
			playPauseBt.useHandCursor = false;
			
			trackSlider.mouseChildren = false;
			
			volumeBt.alpha = 
			rewindBt.alpha = 
			playPauseBt.alpha = .5;
		}
		
		public function disable():void {
			disableControls();
		}
		
		public function changeTimeMode(evt:*):void {
			timeRegressive = !timeRegressive;
			if (control.isPlaying == false) {
				_onVideoProgress(null);
			}
		}
		
		/**
		 * Private
		 */
		private function _overBt(evt:*):void {
			evt.target.alpha = 1;
		}
		
		private function _outBt(evt:*):void {
			evt.target.alpha = .5;
		}
		
		/**
		 * Private Handlers
		 */
		
		private function _closeVolume(evt:MouseEvent):void {
			volumeBt.alpha = .5;
			Tweener.addTween(volumeTrackSlider, { alpha:0, time: .3, transition: "linear", onComplete: function():void { volumeTrackSlider.visible = false; } } );
		}
		
		private function _openVolume(evt:MouseEvent):void {
			volumeTrackSlider.alpha = 1;
			volumeTrackSlider.visible = true;
		}
		
		private function _onVolumeChange(evt:Event):void {
			control.volume = (1-_sliderVolume.percent);
		}
		 
		private function _onReleaseSlider(evt:Event):void {
			
			if (slider.x > track.width) {
				slider.x = track.width;
			}
			
			var calc:Number = ((duration * slider.x ) / _trackSize);
				calc = (int(calc * 1000) / 1000);
			
			control.seek(calc);
		}
		 
		private function _startVideoLoading():void {
			control.verbose = verbose;
			//control.playAfterLoad = playAfterLoad;
			control.init(video, devKey, as2SWF, autoPlay, loop);
		}
		
		private function _onYouTubeLoaded(evt:VideoControllerEvent):void {
			control.loadVideoById(videoID);
		}
		
		
		private function _onLoadError(evt:VideoControllerEvent):void {
			disableControls();
			_trace("[VideoComponentYoutube] Video loader ERROR." + evt.errorMessage + " Flv: " + evt.errorFile);
		}
		
		private function _onLoadInit(evt:VideoControllerEvent):void {
			_trace("[VideoComponentYoutube] Video loader started. Flv: " + videoID);
			holder.visible = true;
		}
		
		private function _onLoadProgress(evt:VideoControllerEvent):void {
			_trace("[VideoComponentYoutube] Video loaded: " + evt.percentLoaded);
			track.scaleX = evt.percentLoaded;
		}
		
		private function _onLoadComplete(evt:VideoControllerEvent):void {
			_trace("[VideoComponentYoutube] Video loader complete.");
		}
		
		private function _onVideoError(evt:VideoControllerEvent):void {
			_trace("[VideoComponentYoutube] Video ERROR." + evt.errorMessage + " Flv: " + evt.errorFile);
			disableControls();
		}
		
		private function _onVideoStart(evt:VideoControllerEvent):void {
			duration = control.duration;
			enableControls();
			_trace("[VideoComponentYoutube] Video started.");
		}
		
		private function _onVideoComplete(evt:VideoControllerEvent):void {
			_trace("[VideoComponentYoutube] Video complete.");
		}
		
		private function _onVideoProgress(evt:*):void {
			if (evt != null) {
				/**
				 * Slider
				 */
				slider.x = ((Math.ceil(evt.percentPlayed * 1000)/1000) * _trackSize);
				slider.x = slider.x < 0 ? 0 : slider.x;
				_trace("[VideoComponent] Video played: " + evt.percentPlayed + "\ttime: " + control.time);
			}
			
			/**
			 * Time Control
			 */
			var baseTime:Number;
			if (!timeRegressive) {
				baseTime = control.time * 1000;
			} else {
				baseTime = control.remainingTime * 1000;
			}
			
			var hours:uint 	= baseTime / (1000 * 60 * 60);
			var min:uint 	= (baseTime % (1000 * 60 * 60)) / (1000 * 60);
			var sec:uint 	= ((baseTime % (1000 * 60 * 60)) % (1000 * 60)) / 1000;
			
			
			if (min > 59) min = min % 60;
			if (sec > 59) sec = sec % 60;
			
			fld_time.text = (timeRegressive ? "-" : "" ) + String(min < 10 ? "0" + min : min) + ":" + String(sec < 10 ? "0" + sec : sec);
		}
		
		private function _onVideoPlay(evt:VideoControllerEvent):void {
			playPauseBt.gotoAndStop("_pause");
		}
		
		private function _onVideoPause(evt:VideoControllerEvent):void {
			playPauseBt.gotoAndStop("_play");
		}
		
		private function _onVideoStop(evt:VideoControllerEvent):void {
			playPauseBt.gotoAndStop("_play");
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