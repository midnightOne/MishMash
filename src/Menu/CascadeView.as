package Menu 
{
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Kirill Prymachov aka Midnight
	 */
	public class CascadeView 
	{
		private var clip:Sprite;
		private var downSprites:int;
		
		private var initialPositions:Vector.<Point>;
		private var offscreenPositions:Vector.<Point>;
		
		private var width:int;
		private var height:int;
		
		
		public function CascadeView(screenWidth:int, screenHeight:int) 
		{
			width = screenWidth;
			height = screenHeight;
			
		}
		
		/**
		 * 
		 * @param	Container
		 * @param	How many sprites from bottom will tween downwards.
		 */
		
		public function loadClip(sprite:Sprite, downwards:int):void 
		{
			var tempDisplayObject:DisplayObject;
			
			clip = sprite;
			downSprites = downwards;
			
			initialPositions = new Vector.<Point>();
			offscreenPositions = new Vector.<Point>();
			
			for (var i:int = 0; i < sprite.numChildren; i++) 
			{
				tempDisplayObject = sprite.getChildAt(i);
				initialPositions[i] = new Point(tempDisplayObject.x, tempDisplayObject.y);
				
				if (i < downwards) 
				{
					offscreenPositions[i] = new Point(tempDisplayObject.x, height+tempDisplayObject.height - sprite.y);
				} else 
				{
					offscreenPositions[i] = new Point(tempDisplayObject.x, -tempDisplayObject.height - sprite.y);
				}
				
			}
			
		}
		
		public function tweenOut(callback:Function = null):Number 
		{
			var delay:Number = 0;
			var cb:Function = null;
			//var time:Number = 0;
			
			for (var i:int = clip.numChildren-1; i >= 0; i--) 
			{
				if (i == 0) 
				{
					cb = callback;
				}
				TweenLite.to(clip.getChildAt(i), 0.3, { x:offscreenPositions[i].x, y:offscreenPositions[i].y, delay:delay, onComplete:cb, ease:Cubic.easeIn} );
				delay += 0.05;
				
			}
			return (delay + 0.3);
		}
		
		public function tweenIn(callback:Function = null):void 
		{
			var delay:Number = 0;
			var cb:Function = null;
			
			for (var i:int = 0; i < clip.numChildren; i++) 
			{
				if (i == clip.numChildren-1) 
				{
					cb = callback;
				}
				TweenLite.to(clip.getChildAt(i), 0.3, { x:initialPositions[i].x, y:initialPositions[i].y, delay:delay, onComplete:cb, ease:Cubic.easeOut} );
				delay += 0.05;
				
			}
		}
		
		public function setPosOut():void 
		{
			for (var i:int = 0; i < clip.numChildren; i++) 
			{
				clip.getChildAt(i).x = offscreenPositions[i].x;
				clip.getChildAt(i).y = offscreenPositions[i].y;
				
			}
		}
		
		public function setPosIn():void 
		{
			for (var i:int = 0; i < clip.numChildren; i++) 
			{
				clip.getChildAt(i).x = initialPositions[i].x;
				clip.getChildAt(i).y = initialPositions[i].y;
				
			}
		}
		
		public function destroy():void 
		{
			
		}
		
	}

}