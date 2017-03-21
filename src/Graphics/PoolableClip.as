package Graphics
{
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Kirill Prymachov aka Midnight
	 */
	public class PoolableClip extends MovieClip implements IPoolableObject
	{
		public var _pool:Pool;
		
		public function PoolableClip() 
		{
			super();
			
		}
		
		public function returnToPool():void 
		{
			if (_pool) 
			{
				cacheAsBitmap = false;
				scaleX = scaleY = 1;
				
				disable();
				_pool.returnItem(this as DisplayObject);
			}
			
		}
		
		public function destroy():void 
		{
			pool = null;
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
		
		public function enable():void 
		{
			
		}
		
		public function disable():void 
		{
			
			
		}
		
	}

}