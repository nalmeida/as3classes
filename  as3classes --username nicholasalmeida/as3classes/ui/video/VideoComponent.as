package as3classes.ui.video{
	
	import as3classes.ui.loader.LoaderIcon;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.media.Video;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	import caurina.transitions.Tweener;
	import as3classes.video.VideoController;
	import as3classes.video.VideoControllerEvent;
	import redneck.ui.Slider;
	
	
	/**
	 <code>
		import as3classes.ui.video.VideoComponent;

		var videoControl:VideoComponent = new VideoComponent(video);
		videoControl.verbose = false;
		videoControl.init( {
			flv:"http://interface.desenv/util/exemplo_5.flv",
			playAfterLoad: .25,
			timeRegressive: false,
			rememberVolume: true
		} );
	 </code>
	 */
	//TODO: Slider do vídeo
	//TODO: full screen? 
	public class VideoComponent extends Sprite {
		
		public var flv:String;
		public var video:Video;
		public var duration:Number = 0;
		public var autoPlay:Boolean = false;
		public var autoLoad:Boolean = false;
		public var loop:Boolean = false;
		public var videoWidth:int = 320;
		public var videoHeight:int = 240;
		public var playAfterLoad:Number = .2;
		public var timeRegressive:Boolean = false;
		public var rememberVolume:Boolean = false;
		
		public var verbose:Boolean = false;
		
		public var sharedObjectName:String = "";
		
		public var mc:Sprite;
			public var bigLoader:LoaderIcon;
			public var startLoading:Sprite;
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
						public var volumeWaves:Sprite;
						public var volumeTrackSlider:Sprite;
							public var volumeBackground:Sprite;
							public var volumeSlider:Sprite;
							public var volumeTrack:Sprite;
				
			public var holder:Sprite;
			
		public var control:VideoController;
		public var isMute:Boolean = false;
		
		private var _sliderControl:Slider;
		private var _sliderVolume:Slider;
		private var _trackSize:Number = 0;
		private var _currentVolume:Number = 1;
		private var _volumeSliderPos:Number;
		
		
		private const VALID_PROPS:Array = ["videoWidth", "videoHeight", "loop", "autoPlay", "autoLoad", "flv", "playAfterLoad", "timeRegressive","rememberVolume"];
		private var so:SharedObject;
		
		public function VideoComponent($mc:*, $initObj:Object = null):void{
			
			mc = $mc as Sprite;
				bigLoader = new LoaderIcon(mc, mc.getChildByName("bigLoader") as MovieClip);
				startLoading = mc.getChildByName("startLoading") as Sprite;
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
						volumeWaves = volumeBt.getChildByName("volumeWaves") as Sprite;
						volumeTrackSlider = volumeBt.getChildByName("volumeTrackSlider") as Sprite;
							volumeBackground = volumeTrackSlider.getChildByName("background") as Sprite;
							volumeTrack = volumeTrackSlider.getChildByName("track") as Sprite;
							volumeSlider = volumeTrackSlider.getChildByName("slider") as Sprite;
					
				holder = mc.getChildByName("holder") as Sprite;
			
			bigLoader.hide();
				
			// Start Buttons
			
			holder.addEventListener(MouseEvent.CLICK, playPause, false, 0, true);
			
			playPauseBt.addEventListener(MouseEvent.CLICK, playPause, false, 0, true);
			//playPauseBt.addEventListener(MouseEvent.MOUSE_OVER, _overBt, false, 0, true);
			rewindBt.addEventListener(MouseEvent.CLICK, rewind, false, 0, true);
			
			fld_time.addEventListener(MouseEvent.CLICK, changeTimeMode, false, 0, true);
			
			volumeBt.addEventListener(MouseEvent.CLICK, _clickVolume, false, 0, true);
			volumeBt.addEventListener(MouseEvent.MOUSE_OVER, _openVolume, false, 0, true);
			volumeBt.addEventListener(MouseEvent.ROLL_OUT, _closeVolume, false, 0, true);
			
			control = new VideoController();
				control.addEventListener(VideoControllerEvent.LOAD_START, _onLoadInit, false, 0, true);
				control.addEventListener(VideoControllerEvent.LOAD_PROGRESS, _onLoadProgress, false, 0, true);
				control.addEventListener(VideoControllerEvent.LOAD_COMPLETE, _onLoadComplete, false, 0, true);
				control.addEventListener(VideoControllerEvent.LOAD_ERROR, _onLoadError, false, 0, true);
				
				control.addEventListener(VideoControllerEvent.VIDEO_START, _onVideoStart, false, 0, true);
				control.addEventListener(VideoControllerEvent.VIDEO_PROGRESS, _onVideoProgress, false, 0, true);
				control.addEventListener(VideoControllerEvent.VIDEO_COMPLETE, _onVideoComplete, false, 0, true);
				control.addEventListener(VideoControllerEvent.VIDEO_ERROR, _onVideoError, false, 0, true);
				
				control.addEventListener(VideoControllerEvent.VIDEO_PLAY, _onVideoPlay, false, 0, true);
				control.addEventListener(VideoControllerEvent.VIDEO_PAUSE, _onVideoPause, false, 0, true);
				control.addEventListener(VideoControllerEvent.VIDEO_STOP, _onVideoStop, false, 0, true);
			
			_sliderControl = new Slider(slider, track, 0, true);
				_sliderControl.addEventListener(Slider.EVENT_PRESS, pause, false, 0, true);
				_sliderControl.addEventListener(Slider.EVENT_RELEASE, _onReleaseSlider, false, 0, true);
				_sliderControl.addEventListener(Slider.EVENT_CHANGE, _onMoveSlider, false, 0, true);
				
			_sliderVolume = new Slider(volumeSlider, volumeTrack, 0, true, true);
				_sliderVolume.addEventListener(Slider.EVENT_CHANGE, _onVolumeChange, false, 0, true);
				_sliderVolume.addEventListener(Slider.EVENT_PRESS, _disableVolumeOut);
				_sliderVolume.addEventListener(Slider.EVENT_RELEASE, _enableVolumeOut);
				
			startLoading.buttonMode = true;
			startLoading.mouseChildren = false;
			startLoading.addEventListener(MouseEvent.CLICK, _clickStarLoading, false, 0, true);
				
			volumeTrackSlider.visible = false;
			
			_trackSize = sliderBackground.width - slider.width;
				
			if ($initObj != null) {
				init($initObj as Object);
			}
			
			disableControls();
			track.scaleX = 0;
			
			fld_time.text = "00:00";
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
			
			video = new Video();
			video.width = videoWidth;
			video.height = videoHeight;
			holder.addChild(video);
			
			if (rememberVolume) {
				if (sharedObjectName == "") sharedObjectName = this + "_volume_" + mc.name;
				so = SharedObject.getLocal(sharedObjectName);
			}
			
			if (flv != null) {
				if(autoLoad == true)
					_changeVideo();
			}
			
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
			
			volumeBt.removeEventListener(MouseEvent.CLICK, _clickVolume);
			volumeBt.removeEventListener(MouseEvent.MOUSE_OVER, _openVolume);
			volumeBt.removeEventListener(MouseEvent.ROLL_OUT, _closeVolume);
			
			if(control != null){
				control.removeEventListener(VideoControllerEvent.LOAD_START, _onLoadInit);
				control.removeEventListener(VideoControllerEvent.LOAD_PROGRESS, _onLoadProgress);
				control.removeEventListener(VideoControllerEvent.LOAD_COMPLETE, _onLoadComplete);
				control.removeEventListener(VideoControllerEvent.LOAD_ERROR, _onLoadError);
				
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
			
			_sliderControl.removeEventListener(Slider.EVENT_PRESS, pause);
			_sliderControl.removeEventListener(Slider.EVENT_RELEASE, _onReleaseSlider);
			_sliderControl.removeEventListener(Slider.EVENT_CHANGE, _onMoveSlider);
			
			_sliderControl.destroy();
			_sliderControl = null;
			
			video.parent.removeChild(video);
			
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
			video = null;
		}
		
		/**
		 * 
		 * @param	$flv FLV file path
		 */
		public function changeVideo($flv:String):void {
			flv = $flv;
			
			// External Call of change Video
			if (control.avaliable) {
				rewind(null);
			}
			video.clear();
			control.close();
			holder.visible = false;
			
			_changeVideo();
		}
		
		private function _changeVideo():void {
			_startVideoLoading();
			
			disableControls();
			fld_time.text = (timeRegressive ? "-" : "" ) + "00:00";
			track.scaleX = 0;
		}
		
				
		private function _clickStarLoading(e:MouseEvent = null):void {
			autoPlay = true;
			_changeVideo();
		}
		private function _hideStarLoading():void {
			if(startLoading.parent != null){
				startLoading.parent.removeChild(startLoading);
			}
		}
		
		public function rewind(evt:MouseEvent):void {
			control.rewind();
			slider.x = 0;
		}
		
		public function play(evt:* = null):void {
			try {
				control.play();
			} catch (e:Error) {
				trace("["+this+"] play WARNING. control = null");
			}
		}
		
		public function pause(evt:* = null):void {
			try {
				control.pause();
			} catch (e:Error) {
				trace("["+this+"] play WARNING. control = null");
			}
		}
		
		public function stop(evt:* = null):void {
			try {
				control.stop();
			} catch (e:Error) {
				trace("["+this+"] stop WARNING. control = null");
			}
		}
		
		public function playPause(evt:*):void {
			control.playPause();
		}
		
		public function enableControls():void {
			volumeBt.mouseEnabled = 
			
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
			
			volumeBt.alpha = 
			rewindBt.alpha = 
			playPauseBt.alpha = 1;

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
		
		public function muteUnmute(...arg):void {
			if (isMute) {
				unmute();
			} else {
				mute();
			}
		}
		
		public function unmute(...arg):void {
			control.volume = _currentVolume;
			volumeSlider.y = _volumeSliderPos;
			volumeWaves.visible = true;
			isMute = false;
			_setSOVolume(_currentVolume);
			
			_trace("[" + this + "] volume UNMUTE.");
		}
		
		public function mute(...arg):void {
			control.volume = 0;
			_volumeSliderPos = volumeSlider.y;
			volumeSlider.y = volumeTrack.y + volumeTrack.height - volumeSlider.height;
			volumeWaves.visible = false;
			isMute = true;
			_setSOVolume(0);
			
			_trace("[" + this + "] volume MUTE.");
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
			Tweener.addTween(volumeTrackSlider, {
				alpha:0,
				time: .3,
				transition: "linear",
				onComplete: function():void {
					volumeTrackSlider.visible = false;
				}
			});

			volumeBt.removeEventListener(MouseEvent.MOUSE_OUT, _closeVolume);
			volumeBt.addEventListener(MouseEvent.MOUSE_OVER, _openVolume);
		}
			
		private function _clickVolume(evt:MouseEvent):void {
			if (evt.target.name == "volumeBt") {
				if (isMute) {
					unmute();
				} else {
					mute();
				}
			}
		}
		
		private function _openVolume(evt:MouseEvent):void {
			volumeBt.addEventListener(MouseEvent.MOUSE_OUT, _closeVolume);
			volumeBt.removeEventListener(MouseEvent.MOUSE_OVER, _openVolume);
			
			volumeTrackSlider.visible = true;
			Tweener.pauseTweens(volumeTrackSlider, "alpha");
			Tweener.addTween(volumeTrackSlider, { 
				alpha: 1, 
				time: .3, 
				transition: "linear"
			});
		}
		
		private function _onVolumeChange(evt:Event):void {
			
			_currentVolume = (1 - _sliderVolume.percent);
			control.volume = _currentVolume;
			_setSOVolume(_currentVolume);
			
			if (_currentVolume <= 0) {
				mute();
			} else {
				volumeWaves.visible = true;
			}
			
		}
		private function _enableVolumeOut(e:Event):void {
			volumeBt.addEventListener(MouseEvent.MOUSE_OUT, _closeVolume);
			
			var _objectsUnderPoint:Array = volumeBt.parent.getObjectsUnderPoint(new Point(volumeBt.parent.mouseX, volumeBt.parent.mouseY));
			var i:int;
			var isUnder:Boolean = false;
			for (i = 0; i < _objectsUnderPoint.length; i++) {
				if (_objectsUnderPoint[i].parent.name === "background") {
					isUnder = true;
					break;
				}
			}
			if (isUnder === false) {
				_closeVolume(null);
			}
		}
		private function _disableVolumeOut(e:Event):void {
			volumeBt.removeEventListener(MouseEvent.MOUSE_OUT, _closeVolume);
		}

		private function resetVolumeSlider():void {
			if(_sliderVolume != null){
				_sliderVolume.removeEventListener(Slider.EVENT_CHANGE, _onVolumeChange);
				_sliderVolume.removeEventListener(Slider.EVENT_PRESS, _disableVolumeOut);
				_sliderVolume.removeEventListener(Slider.EVENT_RELEASE, _enableVolumeOut);
				_sliderVolume.destroy();
				_sliderVolume = null;
			}
		}
		 
		private function _onReleaseSlider(evt:Event):void {
			setTimeout(play, 250);
		}
		
		private function _onMoveSlider(evt:Event):void {
			
			if (slider.x > track.width) {
				slider.x = track.width;
			}
			
			var calc:Number = ((control.duration * slider.x ) / _trackSize);
				calc = (int(calc * 10) / 10);
				calc = calc - (calc / 10);
				
			control.seek(calc);
		}
		 
		private function _startVideoLoading():void {
			
			_hideStarLoading();
			
			bigLoader.show();
			control.verbose = verbose;
			control.playAfterLoad = playAfterLoad;
			control.init(flv, video, autoPlay, loop);
			
		}
		
		private function _onLoadError(evt:VideoControllerEvent):void {
			disableControls();
			_trace("["+this+"] Video loader ERROR." + evt.errorMessage + " Flv: " + evt.errorFile);
		}
		
		private function _onLoadInit(evt:VideoControllerEvent):void {
			_trace("["+this+"] Video loader started. Flv: " + flv);
			holder.visible = true;
		}
		
		private function _onLoadProgress(evt:VideoControllerEvent):void {
			_trace("["+this+"] Video loaded: " + evt.percentLoaded);
			track.scaleX = evt.percentLoaded;
		}
		
		private function _onLoadComplete(evt:VideoControllerEvent):void {
			_trace("["+this+"] Video loader complete.");
		}
		
		private function _onVideoError(evt:VideoControllerEvent):void {
			_trace("["+this+"] Video ERROR." + evt.errorMessage + " Flv: " + evt.errorFile);
			disableControls();
		}
		
		private function _onVideoStart(evt:VideoControllerEvent):void {
			if(rememberVolume){
				control.volume = so.data.volume;
				if(so.data.posSlider != undefined) {
					volumeSlider.y = so.data.posSlider;
				}
				if (so.data.volume <= 0) {
					volumeWaves.visible = false;
				}
			}
			enableControls();
			_trace("["+this+"] Video started.");
		}
		
		private function _onVideoComplete(evt:VideoControllerEvent):void {
			_trace("["+this+"] Video complete.");
		}
		
		private function _onVideoProgress(evt:*):void {
			if (evt != null) {
				/**
				 * Slider
				 */
				slider.x = ((Math.ceil(evt.percentPlayed * 1000)/1000) * _trackSize);
				slider.x = slider.x < 0 ? 0 : slider.x;
				_trace("["+this+"] Video played: " + evt.percentPlayed + "\ttime: " + control.time);
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
			bigLoader.hide();
		}
		
		private function _onVideoPause(evt:VideoControllerEvent):void {
			playPauseBt.gotoAndStop("_play");
		}
		
		private function _onVideoStop(evt:VideoControllerEvent):void {
			playPauseBt.gotoAndStop("_play");
		}
		
				
		private function _setSOVolume(vol:Number):void {
			
			_trace("[" + this + "] volume changed:" + vol);
			
			if(rememberVolume){
				so.data.volume = vol;
				so.data.posSlider = volumeSlider.y;
				so.flush();
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
		
		public override function toString():String {
			return "VideoComponent";
		}
		
	}
}