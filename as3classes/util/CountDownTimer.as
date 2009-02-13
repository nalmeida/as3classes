package as3classes.util{
	
	import flash.events.EventDispatcher;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	/**
	 * Count Down Timer
	 * @author Nicholas Almeida nicholasalmeida.com
	 * @history 9/10/2008 15:03
	 * @usage
	 
		var startDate:Date = new Date();
		var endDate:Date = new Date(2018, 9, 9, 18, 00);
		
		var counter:CountDownTimer = new CountDownTimer(startDate, endDate);
		counter.addEventListener(TimerEvent.TIMER, onTimer);
		counter.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
		counter.start();

		...
			
		private function onTimerComplete(e:TimerEvent):void {
			trace("complete");
		}
		
		private function onTimer(e:TimerEvent):void {
			trace(counter.daysLeft + ":" + counter.hoursLeft + ":" + counter.minutesLeft + ":" + counter.secondsLeft);
		}
		
	 */

	public class CountDownTimer extends EventDispatcher{
		
		private var timer:Timer;
		private var startDate:Date;
		private var endDate:Date;
		private var timeLeft:Number;
		
		public var secondsLeft:String;
		public var minutesLeft:String;
		public var hoursLeft:String;
		public var daysLeft:String;
		public var seconds:Number;
		public var minutes:Number;
		public var hours:Number;
		public var days:Number;
		
		public function CountDownTimer($startDate:Date, $endDate:Date) {
			startDate = $startDate;
			endDate = $endDate;
			
			timer = new Timer(1000);

			timer.addEventListener(TimerEvent.TIMER, onTimer);
			
		}

		public function destroy():void {
			timer.removeEventListener(TimerEvent.TIMER, onTimer);
			stop();
			timer = null;
		}
		
		public function start():void {
			onTimer(null);
			timer.start();
		}
		
		public function stop():void {
			timer.stop();
		}
		
		private function onTimer(e:TimerEvent):void {
			
			timeLeft = endDate.getTime() - startDate.getTime();
			
			seconds = Math.floor(timeLeft / 1000);
			minutes = Math.floor(seconds / 60);
			hours = Math.floor(minutes / 60);
			days = Math.floor(hours / 24);
			
			seconds %= 60;
			minutes %= 60;
			hours %= 24;
			
			secondsLeft = seconds.toString();
			minutesLeft = minutes.toString();
			hoursLeft = hours.toString();
			daysLeft = days.toString();
			
			if (secondsLeft.length < 2) {
				secondsLeft = "0" + secondsLeft;
			}
			
			if (minutesLeft.length < 2) {
				minutesLeft = "0" + minutesLeft;
			}
			
			if (hoursLeft.length < 2) {
				hoursLeft = "0" + hoursLeft;
			}
			
			startDate.setSeconds(startDate.getSeconds() + 1);
			dispatchEvent(new TimerEvent(TimerEvent.TIMER));
			
			if (timeLeft <= 0 ) {
				stop();
				dispatchEvent(new TimerEvent(TimerEvent.TIMER_COMPLETE));	
			}
		}

	}
}
