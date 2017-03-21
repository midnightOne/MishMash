package Logic 
{
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author Kirill Prymachov aka Midnight
	 */
	public class Animal 
	{
		public static const ELEPHANT:int = 0;
		public static const BULL:int = 1;
		public static const GIRAFFE:int = 2;
		
		public static const STANDING:int = 0;
		public static const WALKING:int = 1;
		
		public var destinationX:Number;
		public var destinationY:Number;
		
		
		public var type:int;
		//public var body:int;
		
		public var head:int;
		public var feet:int;
		public var tail:int;
		
		/*public var head:DisplayObject;
		public var body:DisplayObject;
		public var feetBack:DisplayObject;
		public var feetFront:DisplayObject;
		public var tail:DisplayObject;*/
		
		public var state:int;
		
		public var x:Number;
		public var y:Number;
		
		public var dx:Number;
		public var dy:Number;
		
		public var baseSpeed:Number = 3;
		
		private var wait:int=0;
		private var waitMin:int = 30;
		private var waitMax:int = 250;
		
		public function Animal() 
		{
			wait = int(waitMin + Math.random() * (waitMax - waitMin));
		}
		
		public function setType(newType:int):void 
		{
			type = head = tail = feet = newType;
			
		}
		
		public function completed():Boolean 
		{
			if (head == type && feet == type && tail == type) 
			{
				return true;
			}
			return false;
		}
		
		public function update():void 
		{
			var dist:Number;
			
			if (wait < 1 && (x != destinationX || y != destinationY)) 
			{
				dx = destinationX - x;
				dy = destinationY - y;
				
				dist = Math.sqrt(dx*dx + dy*dy);
				if (dist > baseSpeed) 
				{
					dx = dx / dist * baseSpeed;
					dy = dy / dist * baseSpeed;
					
					x += dx;
					y += dy;
					
				} else 
				{
					x = destinationX;
					y = destinationY;
					
					destinationX = 50+Math.random() * 1100;
					destinationY = Math.random() * 280;
					wait = int(waitMin + Math.random() * (waitMax - waitMin));
				}
			} else 
			{
				dx = 0;
				dy = 0;
			}
			
			wait--;
			
		}
		
	}

}