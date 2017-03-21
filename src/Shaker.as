package 
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	//import flash.display.MovieClip;
	/**
	 * ...
	 * @author Kirill Prymachov aka Midnight
	 */
	public class Shaker 
	{
		//---------SHAKE--------------
		private var isShaking:Boolean = false;
		private var degRad:Number = Math.PI/180;
		
		private var w:Number;
		private var h:Number;
		
		private var hipotenuse:Number;
		private var addAngle:Number;
		
		private var defPower:Number;
		private var power:Number;
		private var frame:uint;
		private var decay:Number;
		
		private var _autoUpdate:Boolean;
		private var _shakeType:int;
		
		private var mc:DisplayObject;
		
		public function Shaker(shakingObj:DisplayObject, width:Number,height:Number, defaultPower:Number = 80, shakeDecay:Number = 0.9, autoupdate:Boolean=false, shakeType:int=0) 
		{
			w = width / 2;
			h = height / 2;
			hipotenuse = Math.sqrt(w*w + h*h);
			addAngle = Math.atan2(h, w);
			defPower = defaultPower;
			frame = 0;
			decay = shakeDecay;
			mc = shakingObj;
			
			_shakeType = shakeType;
			
			_autoUpdate = autoupdate;
		}
		
		public function startShake(magnitude:Number = 1):void 
		{
			isShaking = true;
			power = defPower*magnitude;
			
			if (_autoUpdate) 
			{
				mc.addEventListener(Event.ENTER_FRAME, update);
			}
			
		}
		
		public function update(e:Event=null):void 
		{
			frame++;
			
			if (isShaking) 
			{
				if (_shakeType == 0) 
				{
					shakeRotate();
				} else if (_shakeType == 1) 
				{
					verticalShake();
				}
				
				
			} else 
			{
				mc.rotation = 0;
				mc.y = 0;
				mc.x = 0;
			}
		}
		
		private function shakeRotate():void 
		{
			//mc.rotation = Math.sin(frame * 0.2) * 2;
			mc.rotation = Math.sin(frame*1)*(power/18);
			mc.y = h -hipotenuse*Math.sin(mc.rotation*degRad + addAngle);
			mc.x = w -hipotenuse * Math.cos(mc.rotation * degRad + addAngle);
			
			power *= decay;
			
			
			if (power < 4)
			{
				//decay = 0.5;
				power = 0;
				isShaking = false;
			} //else if
		}
		
		private function verticalShake():void 
		{
			//mc.rotation = Math.sin(frame * 0.2) * 2;
			//mc.rotation = Math.sin(frame*1)*(power/18);
			mc.y = Math.sin(frame * 1) * (power / 9);
			//mc.x = w -hipotenuse * Math.cos(mc.rotation * degRad + addAngle);
			
			power *= decay;
			
			
			if (power < 4)
			{
				//decay = 0.5;
				power = 0;
				isShaking = false;
			} //else if
		}
		
		public function destroy():void 
		{
			mc = null;
			isShaking = false;
			
		}
	}

}