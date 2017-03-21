package  
{
	//import com.greensock.easing.Circ;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Quad;
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import Graphics.GraphicVault;
	import Graphics.PoolableClip;
	/**
	 * ...
	 * @author Kirill Prymachov aka Midnight
	 */
	public class ExpBar
	{
		public var points:int = 0;
		private var pointsAddition:int;
		private var localMaxPoints:int;
		
		private var leftX:int;
		private var rightX:int;
		
		private var unlockPositions:Array;
		private var unlocks:Array;
		
		private var indicators:Vector.<PoolableClip>;
		
		private var expBarMc:ExpBarBase;
		
		private var addition:int = 0;
		
		private var filled:Boolean = false;
		
		public function ExpBar() 
		{
			
		}
		
		public function init(graphic:ExpBarBase, minPoints:int=0, maxPoints:int=100, currentPoints:int=0, unlockPos:Array=null, unlockIds:Array=null):void 
		{
			expBarMc = graphic;
			
			trace("TESTING: " + expBarMc);
			
			pointsAddition = minPoints;
			localMaxPoints = maxPoints - minPoints;
			points = currentPoints - minPoints;
			
			unlockPositions = unlockPos;
			unlocks = unlockIds;
			
			leftX = expBarMc.pointsMask.x;
			rightX = expBarMc.pointsMask.width+leftX;
			
			indicators = new Vector.<PoolableClip>();
			
			placeIndicators();
			update();
		}
		
		public function loadNext(minPoints:int=100, maxPoints:int=200, unlockPos:Array=null, unlockIds:Array=null):void 
		{
			while (indicators.length) 
			{
				removeIndicator();
			}
			
			points -= localMaxPoints;
			
			pointsAddition = minPoints;
			localMaxPoints = maxPoints - minPoints;
			//points = currentPoints - minPoints;
			
			unlockPositions = unlockPos;
			unlocks = unlockIds;
			
			filled = false;
			
			//leftX = expBarMc.pointsMask.x;
			//rightX = expBarMc.pointsMask.width+leftX;
			
			indicators = new Vector.<PoolableClip>();
			
			placeIndicators();
			update();
		}
		
		public function getTotalPts():int 
		{
			return points + pointsAddition;
		}
		
		private function placeIndicators():void 
		{
			trace(unlockPositions);
			if (!unlockPositions || !unlocks) 
			{
				trace("return");
				return;
			}
			
			
			for (var i:int = 0; i < unlockPositions.length; i++) 
			{
				if (unlockPositions[i] > pointsAddition) 
				{
					indicators[i] = GraphicVault.getInstance().getObject("UnlockIndicator") as PoolableClip;
					
					indicators[i].y = expBarMc.pointsIndicator.y;
					indicators[i].x = leftX + (rightX - leftX) * ((unlockPositions[i]-pointsAddition) / localMaxPoints);
					indicators[i].alpha = 1;
					indicators[i].scaleY = indicators[i].scaleX = 1;
					
					
					expBarMc.addChildAt(indicators[i],expBarMc.numChildren-1);
					trace("added");
					
				}
			}
			
		}
		
		public function checkUnlock(addedPoints:int):Boolean 
		{
			return ((unlockPositions && points + pointsAddition + addedPoints >= unlockPositions[0]) || (points + addedPoints >= localMaxPoints ));
			
		}
		
		private function setDisplayNumber(number:int):void 
		{
			var strNum:String = String(number);
			while (strNum.length < 4) 
			{
				strNum = "0" + strNum;
			}
			
			expBarMc.pointsIndicator.amount.text = strNum;
			
		}
		
		/*public function add(addPoints:int):void 
		{
			TweenLite.to(this, 2.5, {points:points+addPoints, ease:Quad.easeInOut, onUpdate:update});
		}*/
		
		public function update(newPoints:int = -1):int 
		{
			var temp:int;
			var displayedPoints:int;
			
			if (newPoints != -1) 
			{
				points = newPoints;
			}
			
			if (points >= localMaxPoints) 
			{
				//points = localMaxPoints;
				displayedPoints = localMaxPoints;
				
				
			} else 
			{
				displayedPoints = points;
			}
			
			var percentage:Number = displayedPoints / localMaxPoints;
			
			expBarMc.pointsMask.scaleX = percentage;
			expBarMc.pointsIndicator.x = leftX + (rightX - leftX) * percentage;
			
			setDisplayNumber(displayedPoints + pointsAddition);
			
			if (unlockPositions && displayedPoints + pointsAddition >= unlockPositions[0]) 
			{
				TweenLite.to(indicators[0], 1, { scaleX:1.5, scaleY:1.5, alpha:0, onComplete:removeIndicator } );
				temp = unlocks[0];
				unlockPositions.splice(0, 1);
				unlocks.splice(0, 1);
				return temp;
			}
			
			if (points >= localMaxPoints && !filled) 
			{
				points++;
				filled = true;
				return -10;
			}
			
			return 0;
		}
		
		private function removeIndicator():void 
		{
			expBarMc.removeChild(indicators[0]);
			indicators[0].returnToPool();
			indicators.splice(0, 1);
			
		}
		
		public function destroy():void 
		{
			
		}
		
	}

}