package Parallax 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Kirill Prymachov aka Midnight
	 */
	public class ParallaxObject extends Sprite 
	{
		public var parallaxX:Number;
		public var parallaxY:Number;
		public var parallaxZ:Number;
		
		public var dx:Number=0;
		
		private var _child:DisplayObject;
		
		private var debugInfo:MovieClip;
		
		//=------------------------
		//      CONSTRUCTOR
		//=------------------------
		public function ParallaxObject(child:DisplayObject, debug:Boolean = false) 
		{
			this.addChild(child)
			_child = child
			
			if (debug) 
			{
				debugInfo = new DebugInfo();
				this.addChild(debugInfo);
			}
			
			parallaxZ = 0;
		}
		
		//=------------------------
		//       DESTRUCTOR
		//=------------------------
		public function destroy():void 
		{
			this.removeChild(_child)
			_child = null;
		}
		
		public function setPosition(x:Number, y:Number):void 
		{
			parallaxX = x;
			parallaxY = y;
		}
		
		public function updateDebugInfo(distRatio:Number):void 
		{
			if (debugInfo) 
			{
				debugInfo.xx.text = x;
				debugInfo.yy.text = y;
				debugInfo.scale.text = scaleX;
				debugInfo.genRat.text = distRatio;
				
				
				
			}
			
		}
		
	}

}