package Menu 
{
	import com.greensock.easing.Back;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Kirill Prymachov aka Midnight
	 */
	public class ScrollButton extends Sprite 
	{
		private var scrollingSprite:DisplayObject;
		private var mouseOverSprite:DisplayObject;
		private var scrollPoints:Vector.<Point>;
		
		public var currentPos:int = 0;
		
		public function ScrollButton() 
		{
			
			//this.addEventListener(Event.ADDED_TO_STAGE, added);
			added();
		}
		
		private function added(e:Event = null):void 
		{
			//this.removeEventListener(Event.ADDED_TO_STAGE, added);
			
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			//this.addEventListener(MouseEvent.CLICK, click);
			
			init();
		}
		
		private function init():void 
		{
			scrollingSprite = this.getChildByName("content");
			mouseOverSprite = this.getChildByName("highlight");
			
			var temp:DisplayObject;
			var index:int = 1;
			
			scrollPoints = new Vector.<Point>();
			temp = this.getChildByName(String("pt" + index));
			
			while (temp)
			{
				scrollPoints.push(new Point(temp.x, temp.y));
				this.removeChild(temp);
				index++;
				temp = this.getChildByName(String("pt" + index));
			} 
			
			mouseOverSprite.alpha = 0;
		}
		
		public function switchTo(position:int = 0):void 
		{
			if (position >=0) 
			{
				position = position % scrollPoints.length;
			} else 
			{
				position = scrollPoints.length-1;
			}
			
			
			currentPos = position;
			TweenLite.to(scrollingSprite,0.7, {x:scrollPoints[position].x,y:scrollPoints[position].y, ease:Back.easeInOut});
			
			
			if (!(position < scrollPoints.length)) 
			{
				trace("WARNING: SCROLLBUTTON - index out of range");
			}
			
		}
		
		public function setPos(position:int):void 
		{
			if (position >=0) 
			{
				position = position % scrollPoints.length;
			} else 
			{
				position = scrollPoints.length-1;
			}
			currentPos = position;
			
			scrollingSprite.x = scrollPoints[position].x;
			scrollingSprite.y = scrollPoints[position].y;
			
			if (!(position < scrollPoints.length)) 
			{
				trace("WARNING: SCROLLBUTTON - index out of range");
			}
		}
		
		public function next():void 
		{
			switchTo(currentPos+1);			
		}
		
		public function prev():void 
		{
			switchTo(currentPos-1);			
		}
		
		private function click(e:MouseEvent=null):void 
		{
			next();
		}
		
		public function mouseOver(e:MouseEvent=null):void 
		{
			this.removeEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			
			TweenLite.to(mouseOverSprite, 0.5, { alpha:1 } );
			
			
		}
		
		public function mouseOut(e:MouseEvent=null):void 
		{
			this.removeEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			TweenLite.to(mouseOverSprite, 0.5, { alpha:0 } );
		}
		
	}

}