package  as3classes.util{
	
	import flash.utils.setTimeout;
	import as3classes.util.URL;
	
	public class GadgetInteraction {
		
		public static var ANALYTICS_CODE:String = 0;
		private static var time:Number;
		
		public static function call($obj:Object):void {
			/*
			$obj = {
				analytics: {
					name: 
				},
				interaction: {
					name:,
					value:
				},
				destination: {
					url:
				}
			}
			*/
			
			time = 300;
			
			var interactionCode:String;
			var analyticsCode:String;
			var destinationCode:String;
			var timeCount:Number = 0;
			
			
			if ($obj.analytics && ANALYTICS_CODE != "0") {
				if (typeof($obj.analytics.name) == "string" && $obj.analytics.name != "") {
					
					analyticsCode = "javascript:_IG_Analytics('" +ANALYTICS_CODE + "','/" + $obj.analytics.name + "');void(0);";
					setTimeout(function():void {
						URL.call(analyticsCode);
						trace("\n>>>>> call tracker (analytics): "+analyticsCode);
					},(time * timeCount));
					timeCount++;
				}
			}
			
			if ($obj.interaction) {
				if (typeof($obj.interaction.name) == "string" && $obj.interaction.name != "") {
					interactionCode = "javascript:_ADS_ReportInteraction('" + $obj.interaction.name + "', " + ($obj.interaction.value ? $obj.interaction.value : "1") + ");void(0);";
					setTimeout(function():void {
						URL.call(interactionCode);
						trace(">>>>> call tracker (interaction): "+interactionCode);
					},(time * timeCount));
					timeCount++;
				}
			} 
					
			if ($obj.destination) {
				if (typeof($obj.destination.url) == "string" && $obj.destination.name != "") {
					destinationCode = "javascript:_ADS_ClickDestinationUrl('" + $obj.destination.url + "');void(0);";
					setTimeout(function():void {
						URL.call(destinationCode);
						trace(">>>>> call tracker (destination): "+destinationCode);
					},(time * timeCount));
					timeCount++;
				}
			}
		}
	}
	
}