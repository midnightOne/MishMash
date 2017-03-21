package Graphics
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	
	/**
	 * ...
	 * @author Kirill Prymachov aka Midnight
	 */
	public class BitmapAnimation extends Bitmap implements IPoolableObject
	{
		private var cache:AnimationCache;
		private var _currentFrame:int;
		//var playing:Boolean;
		private var playback:int;
		private var _totalFrames:int;
		private var rect:Rectangle;
		private var dx:int;
		private var dy:int;
		private var _pool:Pool;
		
		
		public function BitmapAnimation(animationCache:AnimationCache) 
		{
			var bitmapData:BitmapData = null;
			var pixelSnapping:String = "auto";
			var smoothing:Boolean = false;
			
			cache = animationCache;
			_currentFrame = 1;
			playback = 1;
			
			super(new BitmapData(cache.rectAll.width, cache.rectAll.height), pixelSnapping, smoothing);
			rect = new Rectangle(0, 0, cache.rectAll.width, cache.rectAll.height);
			
			dx = cache.rectAll.x;
			dy = cache.rectAll.y;
			
			_totalFrames = cache.totalFrames;
			
			
			
			Settings.addToUpdateList(update);
			//this.addEventListener(Event.ENTER_FRAME, update);
			
		}
		
		
		
		/**
		 * The total number of frames in the MovieClip instance.
		 * 
		 *   If the movie clip contains multiple frames, the totalFrames property returns 
		 * the total number of frames in all scenes in the movie clip.
		 * @langversion	3.0
		 * @playerversion	Flash 9
		 * @playerversion	Lite 4
		 */
		public function get totalFrames () : int
		{
			return _totalFrames;
		}
		
		public function get currentFrame():int 
		{
			return _currentFrame;
		}


		/**
		 * Starts playing the SWF file at the specified frame.  This happens after all 
		 * remaining actions in the frame have finished executing.  To specify a scene 
		 * as well as a frame, specify a value for the scene parameter.
		 * @param	frame	A number representing the frame number, or a string representing the label of the 
		 *   frame, to which the playhead is sent. If you specify a number, it is relative to the 
		 *   scene you specify. If you do not specify a scene, the current scene determines the global frame number to play. If you do specify a scene, the playhead
		 *   jumps to the frame number in the specified scene.
		 * @param	scene	The name of the scene to play. This parameter is optional.
		 * @langversion	3.0
		 * @playerversion	Flash 9
		 * @playerversion	Lite 4
		 */
		public function gotoAndPlay (frame:int) : void
		{
			_currentFrame = frame;
			play();
		}

		/**
		 * Brings the playhead to the specified frame of the movie clip and stops it there.  This happens after all 
		 * remaining actions in the frame have finished executing.  If you want to specify a scene in addition to a frame, 
		 * specify a scene parameter.
		 * @param	frame	A number representing the frame number, or a string representing the label of the 
		 *   frame, to which the playhead is sent. If you specify a number, it is relative to the 
		 *   scene you specify. If you do not specify a scene, the current scene determines the global frame number at which to go to and stop. If you do specify a scene, 
		 *   the playhead goes to the frame number in the specified scene and stops.
		 * @param	scene	The name of the scene. This parameter is optional.
		 * @langversion	3.0
		 * @playerversion	Flash 9
		 * @playerversion	Lite 4
		 * @throws	ArgumentError If the scene or frame specified are
		 *   not found in this movie clip.
		 */
		public function gotoAndStop (frame:int) : void
		{
			_currentFrame = frame;
			stop();
		}

		
		/**
		 * Sends the playhead to the next frame and stops it.  This happens after all 
		 * remaining actions in the frame have finished executing.
		 * @langversion	3.0
		 * @playerversion	Flash 9
		 * @playerversion	Lite 4
		 */
		public function nextFrame () : void
		{
			_currentFrame++;
			
		}

		/**
		 * Moves the playhead in the timeline of the movie clip.
		 * @langversion	3.0
		 * @playerversion	Flash 9
		 * @playerversion	Lite 4
		 */
		public function play () : void
		{
			playback = 1;
		}

		/**
		 * Sends the playhead to the previous frame and stops it.  This happens after all 
		 * remaining actions in the frame have finished executing.
		 * @langversion	3.0
		 * @playerversion	Flash 9
		 * @playerversion	Lite 4
		 */
		public function prevFrame () : void
		{
			_currentFrame--;
		}


		/**
		 * Stops the playhead in the movie clip.
		 * @langversion	3.0
		 * @playerversion	Flash 9
		 * @playerversion	Lite 4
		 */
		public function stop () : void
		{
			playback = 0;
		}
		
		public function reverse():void 
		{
			playback = -1;
		}
		
		private function update(e:Event = null):void 
		{
			if (playback != 0)
			{
				
				_currentFrame += playback;
				
				if (_currentFrame < 1 && playback < 0) 
				{
					_currentFrame = _totalFrames;
					
				} else if (_currentFrame < 1) 
				{
					_currentFrame = 1;
				} else if (_currentFrame > _totalFrames && playback > 0) 
				{
					_currentFrame = 1;
					
				} else if (_currentFrame > _totalFrames)
				{
					_currentFrame = _totalFrames;
				}
				
				this.bitmapData = cache.frames[_currentFrame-1];
				
				this.x = cache.frameXs[_currentFrame-1];
				this.y = cache.frameYs[_currentFrame-1];
				
				
				
				//trace("frame " + _currentFrame);
				//trace(cache.frames[_currentFrame-1].rect);
				//this.bitmapData.fillRect(rect,0);
				//this.bitmapData.copyPixels(cache.frames[_currentFrame-1], cache.frames[_currentFrame-1].rect, new Point(cache.frameXs[_currentFrame-1]-dx,cache.frameYs[_currentFrame-1]-dy), null, null, true);
			}
		}
		
		private function trace2(string:String):void 
		{
			if (Settings.traceEnabled) 
			{
				trace(string)
			}
		}
	
		
		public function destroy():void 
		{
			Settings.removeFromUpdateList(update);
			cache = null;
		}
		
		/* INTERFACE IPoolableObject */
		
		public function set pool(value:Pool):void 
		{
			_pool = value;
		}
		
		public function get pool():Pool 
		{
			return _pool;
		}
		
		public function returnToPool():void 
		{
			if (_pool) 
			{
				//stop();
				disable();
				_pool.returnItem(this as DisplayObject);
			}
			
		}
		
		public function enable():void 
		{
			Settings.addToUpdateList(update);
			/*CONFIG::debug*/ {
				trace("BitmapAnimation ENABLED ++");
			}
		}
		
		public function disable():void 
		{
			Settings.removeFromUpdateList(update);
			/*CONFIG::debug*/ {
				trace("BitmapAnimation DISABLED --");
			}
		}
		
	}

}