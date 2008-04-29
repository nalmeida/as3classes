package as3classes.video {
	
	import flash.events.Event
	
	public class VideoControllerEvent extends Event{
		
		public static const LOAD_START:String = "load_start";
		public static const LOAD_PROGRESS:String = "load_progress";
		public static const LOAD_COMPLETE:String = "load_complete";
		public static const LOAD_ERROR:String = "load_error";
		
		public static const VIDEO_START:String = "video_start";
		public static const VIDEO_PROGRESS:String = "video_progress";
		public static const VIDEO_COMPLETE:String = "video_complete";
		public static const VIDEO_ERROR:String = "video_error";
		
		public static const VIDEO_PLAY:String = "video_play";
		public static const VIDEO_PAUSE:String = "video_pause";
		public static const VIDEO_STOP:String = "video_stop";
		
		public static const YOUTUBE_PLAYER_LOADED:String = "youtube_player_loaded";
		public static const YOUTUBE_PLAYER_CLOSED:String = "youtube_player_closed";
		
		public var percentLoaded:Number = 0;
		public var percentPlayed:Number = 0;
		public var errorMessage:String;
		public var errorFile:String;
		
		public function VideoControllerEvent(type:String, videoController:* = null, message:String = "") {
			
			switch (type) {
				case LOAD_PROGRESS : 
					if (videoController._percentLoaded > 0) {
						percentLoaded = videoController._percentLoaded;
					} else {
						percentLoaded = 0;
					}
					break;
					
				case LOAD_ERROR : 
					if (videoController.TYPE == "youtube") {
						errorFile = videoController.videoID;
					} else {
						errorFile = videoController.flv;
					}
					break;
					
					
					
				case VIDEO_PROGRESS : 
					if (videoController.avaliable) {
						percentPlayed = videoController.percentPlayed;
					} else {
						percentPlayed = 0;
					}
					break;
					
				case VIDEO_ERROR : 
					if (videoController.TYPE == "youtube") {
						try { 
							errorFile = videoController.videoID;
						} catch (e:Error) { };
					} else {
						errorFile = videoController.flv;
					}
					errorMessage = message;
					break;
			}
			
			super(type);
		}
	}
}