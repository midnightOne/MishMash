package Graphics
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	//import LevelPhysics.PlatformBase;
	
	/**
	 * ...
	 * @author Alexander Porechnov
	 */
	public class AnimationCache
	{
		public var frames:Array;
		public var frameXs:Array;
		public var frameYs:Array;
		public var totalFrames:int;
		public var rectAll:Rectangle;
		public var scenes:Vector.<int>;
		
		
		protected static const INDENT_FOR_FILTER:int = 64;
		protected static const INDENT_FOR_FILTER_DOUBLED:int = INDENT_FOR_FILTER * 2;
		protected static const DEST_POINT:Point = new Point(0, 0);
		
		public function AnimationCache()
		{
			frames = new Array();
			frameXs = new Array();
			frameYs = new Array();
			scenes = new Vector.<int>();
			
			scenes[0] = 1;
			
			totalFrames = 0;
		}
		
		public static function createAnimationCacheFromMC(clipClass:Class, obstacle:Boolean = false):AnimationCache
		{
			var clip:MovieClip;
			var tempClip:MovieClip = MovieClip(new clipClass());
			var res:AnimationCache = new AnimationCache();
			
			var totalFrames:int = tempClip.totalFrames;
			
			var frames:Array = res.frames;
			var frameXs:Array = res.frameXs;
			var frameYs:Array = res.frameYs;
			var scenes:Vector.<int> = res.scenes;
			
			var rect:Rectangle;
			var flooredX:int;
			var flooredY:int;
			var mtx:Matrix = new Matrix();
			var scratchBitmapData:BitmapData = null;
			
			// WARNING: custom code
			
			var additionalX:int = 0;
			var additionalY:int = 0;
			
			//var isObstacle:Boolean = false; 
			
			clip = tempClip;
			
			var tempPoint:Point;
			
			res.rectAll = getFrameSize(clip);
			
			for (var i:int = 1; i <= totalFrames; i++)
			{
				clip.gotoAndStop(i);
				rect = clip.getBounds(clip);
				rect.width = Math.ceil(rect.width) + INDENT_FOR_FILTER_DOUBLED;
				rect.height = Math.ceil(rect.height) + INDENT_FOR_FILTER_DOUBLED;
				
				flooredX = Math.floor(rect.x) - INDENT_FOR_FILTER;
				flooredY = Math.floor(rect.y) - INDENT_FOR_FILTER;
				mtx.tx = -flooredX;
				mtx.ty = -flooredY;
				
				scratchBitmapData = new BitmapData(rect.width, rect.height, true, 0);
				scratchBitmapData.draw(clip, mtx);
				
				var trimBounds:Rectangle = scratchBitmapData.getColorBoundsRect(0xFF000000, 0x00000000, false);
				trimBounds.x -= 1;
				trimBounds.y -= 1;
				trimBounds.width += 2;
				trimBounds.height += 2;
				
				flooredX += trimBounds.x;
				flooredY += trimBounds.y;
				
				tempPoint = new Point(0,0);//new Point(flooredX < 0 ? 0 : flooredX, flooredY < 0 ? 0 : flooredY);
				
				var bmpData:BitmapData = new BitmapData(trimBounds.width, trimBounds.height, true, 0);
				//bmpData.fillRect(trimBounds, 0xffffffff);
				bmpData.copyPixels(scratchBitmapData, trimBounds, tempPoint /*DEST_POINT*/);
				
				frames.push(bmpData);
				frameXs.push(flooredX+additionalX);
				frameYs.push(flooredY+additionalY);
				
				scratchBitmapData.dispose();
				
				if (clip.currentFrameLabel != null && i > 0)
				{
					scenes.push(i);
				}
			}
			res.totalFrames = res.frames.length;
			return res;
		}
		
		public static function createCacheFromExisting(clip:MovieClip):AnimationCache
		{
			var res:AnimationCache = new AnimationCache();
			
			var totalFrames:int = clip.totalFrames;
			
			var frames:Array = res.frames;
			var frameXs:Array = res.frameXs;
			var frameYs:Array = res.frameYs;
			var scenes:Vector.<int> = res.scenes;
			
			
			var rect:Rectangle;
			var flooredX:int;
			var flooredY:int;
			var mtx:Matrix = new Matrix();
			var scratchBitmapData:BitmapData = null;
			
			
			var tempPoint:Point;
			
			res.rectAll = getFrameSize(clip);
			
			for (var i:int = 1; i <= totalFrames; i++)
			{
				clip.gotoAndStop(i);
				rect = clip.getBounds(clip);
				rect.width = Math.ceil(rect.width) + INDENT_FOR_FILTER_DOUBLED;
				rect.height = Math.ceil(rect.height) + INDENT_FOR_FILTER_DOUBLED;
				
				flooredX = Math.floor(rect.x) - INDENT_FOR_FILTER;
				flooredY = Math.floor(rect.y) - INDENT_FOR_FILTER;
				mtx.tx = -flooredX;
				mtx.ty = -flooredY;
				
				scratchBitmapData = new BitmapData(rect.width, rect.height, true, 0);
				scratchBitmapData.draw(clip, mtx);
				
				var trimBounds:Rectangle = scratchBitmapData.getColorBoundsRect(0xFF000000, 0x00000000, false);
				trimBounds.x -= 1;
				trimBounds.y -= 1;
				trimBounds.width += 2;
				trimBounds.height += 2;
				
				flooredX += trimBounds.x;
				flooredY += trimBounds.y;
				
				tempPoint = new Point(0,0);//new Point(flooredX < 0 ? 0 : flooredX, flooredY < 0 ? 0 : flooredY);
				
				var bmpData:BitmapData = new BitmapData(trimBounds.width, trimBounds.height, true, 0);
				//bmpData.fillRect(trimBounds, 0xffffffff);
				bmpData.copyPixels(scratchBitmapData, trimBounds, tempPoint /*DEST_POINT*/);
				
				frames.push(bmpData);
				frameXs.push(flooredX);
				frameYs.push(flooredY);
				
				scratchBitmapData.dispose();
				
				if (clip.currentFrameLabel != null && i > 0)
				{
					scenes.push(i);
				}
			}
			res.totalFrames = res.frames.length;
			return res;
		}
		
		/**
		 * Рассчитывает максимальный размер кадра на основе всех кадров клипа.
		 *
		 * @param	mc	 Клип для которого необходимо получить максимальный размер кадра.
		 * @return		Возвращает максимальный размер кадра для указанного клипа.
		 */
		private static function getFrameSize(mc:MovieClip):Rectangle
		{
			var min:Point = new Point();
			var max:Point = new Point();
			var bounds:Rectangle;
			
			var n:int = mc.totalFrames;
			for (var i:int = 1; i <= n; i++)
			{
				mc.gotoAndStop(i);
				//allGotoFrame(mc, i);
				bounds = mc.getBounds(mc);
				min.x = Math.min(bounds.topLeft.x, min.x);
				min.y = Math.min(bounds.topLeft.y, min.y);
				max.x = Math.max(bounds.bottomRight.x, max.x);
				max.y = Math.max(bounds.bottomRight.y, max.y);
			}
			
			mc.gotoAndStop(1);
			//trace("Rectangle("+min.x+","+ min.y+"," + (max.x - min.x)+","+ (max.y - min.y)+");");
			return new Rectangle(min.x, min.y, max.x - min.x, max.y - min.y);
		}
		
		/**
		 * Переключает кадры указанного клипа и вложенных в него клипов на заданный кадр.
		 *
		 * @param	mc	 Клип кадры которого необходимо переключить.
		 * @param	frame	 Номер кадра на которых необходимо переключить.
		 */
		protected function allGotoFrame(mc:MovieClip, frame:int):void
		{
			var clip:Object;
			var n:int = mc.numChildren;
			for (var i:int = 0; i < n; i++)
			{
				clip = mc.getChildAt(i);
				if (clip is MovieClip)
				{
					allGotoFrame(clip as MovieClip, frame);
					clip.gotoAndStop(frame);
				}
			}
		}
		
		public function destroy():void
		{
			while (frames.length)
			{
				(frames.pop() as BitmapData).dispose();
				
			}
			frames = null;
			while (frameXs.length)
			{
				frameXs.pop();
				
			}
			frameXs = null;
			while (frameYs.length)
			{
				frameYs.pop();
				
			}
			frameYs = null;
			rectAll = null;
			while (scenes.length)
			{
				scenes.pop();
			}
			scenes = null;
		
		}
	}

}