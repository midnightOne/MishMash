package Graphics
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	//import Digits.*;
	
	/**
	 * ...
	 * @author Kirill Prymachov aka Midnight
	 */
	public class DigitDisplay extends Sprite 
	{
		private var digitClasses:Array = [ Zero, One, Two, Three, Four, Five, Six, Seven, Eight, Nine];
		private var digitPools:Vector.<Pool>;
		private var digits:Array;
		
		private var text:String;
		
		private var dist:Number = 1;
		
		private var cHeight:Number;
		private var scale:Number = 0;
		
		public var downscaleLarger:Number = 0;
		
		private var initialHeight:Number;
		
		public function DigitDisplay() 
		{
			
		}
		
		public function init(distance:Number = 1):void 
		{
			//digitClasses = digitClassArray;
			dist = distance;
			cHeight = height;
			digits = new Array();
			
			digitPools = new Vector.<Pool>(10, true);
			
			for (var i:int = 0; i < digitClasses.length; i++) 
			{
				digitPools[i] = new Pool(digitClasses[i], 10);
			}
			
			
			this.removeChild(this.getChildByName("area"));
			/*while(this.numChildren > 0) 
			{
				this, removeChildAt(0);
			}*/
		}
		
		public function update(number:int):void 
		{
			clear();
			
			var pushedToArray:Boolean;
			
			
			text = String(number);
			var tempSprite:DisplayObject;
			var counter:Number = -dist;
			
			
			for (var i:int = 0; i < text.length; i++) 
			{
				pushedToArray = false;
				tempSprite = digitPools[int(text.charAt(i))].getItem();
				
				if (scale == 0) 
				{
					scale = (cHeight / tempSprite.height) * (1 - (text.length-1)*0.2*downscaleLarger);
					
				}		
				
				tempSprite.scaleX = scale;
				tempSprite.scaleY = scale;
				
				
				for (var k:int = 0; k < digits.length; k++) 
				{
					if (digits[k] == null) 
					{
						digits[k] = tempSprite;
						pushedToArray = true;
						break;
						
					}
					
				}
				
				if (!pushedToArray)
				{
					digits.push(tempSprite);
				}
				
				
				
				this.addChild(tempSprite);
				counter += dist;
				tempSprite.x = counter;
				counter += tempSprite.width;
				
				
			}
			
			
			
			counter *= 0.5;
			
			
			
			for (var j:int = 0; j < text.length; j++) 
			{
				digits[j].x -= counter;
				
			}
			
		}
		
		public function clear():void 
		{
			for (var i:int = 0; i < digits.length; i++) 
			{
				if (digits[i]) 
				{
					this.removeChild(digits[i]);
					
					(digits[i] as IPoolableObject).returnToPool();
					//digitPools[i].returnItem(digits[i]);
					
					digits[i] = null;
				}
			}
			
		}
		
	}

}