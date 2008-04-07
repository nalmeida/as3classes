package as3classes.video {
	
	import flash.events.Event
	import br.com.stimuli.loading.BulkProgressEvent;
	
	public class VideoControllerEvent extends Event{
		
		public static const LOAD_START:String = "load_start";
		public static const LOAD_PROGRESS:String = "load_progress";
		public static const LOAD_COMPLETE:String = "load_complete";
		public static const LOAD_ERROR:String = "load_error";
		
		public static const VIDEO_START:String = "video_start";
		public static const VIDEO_PROGRESS:String = "video_progress";
		public static const VIDEO_COMPLETE:String = "video_complete";
		public static const VIDEO_ERROR:String = "video_error";
		
		public var percentLoaded:Number = 0;
		public var percentPlayed:Number = 0;
		public var errorMessage:String;
		public var errorFile:String;
		
		public function VideoControllerEvent(type:String, videoController:VideoController, message:String = "") {
			
			switch (type) {
				case VIDEO_PROGRESS : 
					if (videoController.avaliable) {
						percentPlayed = videoController.percentPlayed;
					} else {
						percentPlayed = 0;
					}
					break;
					
				case LOAD_PROGRESS : 
					if (videoController.avaliable) {
						percentLoaded = videoController._percentLoaded;
					} else {
						percentLoaded = 0;
					}
					break;
					
				case LOAD_ERROR : 
					errorFile = videoController.flv;
					break;
				case VIDEO_ERROR : 
					errorMessage = message;
					break;
			}
			
			super(type);
		}
	}
}