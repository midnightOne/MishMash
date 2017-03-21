package Graphics
{
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Kirill Prymachov aka Midnight
	 */
	public class Pool 
	{
		
		private var pool:Array;
		private var _counter:int;
		private var itemClass:Class;
		public var length:int;
		
		public function Pool(baseClass:Class, maxlength:int) 
		{
			pool = new Array();//Vector.<Projectile>(len, true); //fixed length Vector
			_counter = 0;
			length = maxlength;
			itemClass = baseClass;
			
		}
		
		public function add(item:DisplayObject):void 
		{
			if (_counter <= length) {
				
				pool[_counter] = item;
				_counter++;					
			} else {
				throw new Error("You overpopulated the pool!");
			}
			
		}
		
		
		public function getItem():DisplayObject
		{
			var tempItem:DisplayObject;
			
			if (_counter > 0) {
				_counter--;
				
				tempItem = pool[_counter];
				pool[_counter] = null;
				
				if (tempItem is BitmapAnimation) 
				{
					(tempItem as BitmapAnimation).enable();
					
				}
				
				return tempItem;
			}
			else {
				//throw new Error("You exhausted the pool!");
				tempItem = createInstance();
				(tempItem as IPoolableObject).pool = this;
				
				//pool[_counter] = tempItem;
				//_counter++;
				
				return tempItem;
			}
		}
		
		protected function createInstance():DisplayObject 
		{
			return new itemClass() as DisplayObject;
			
		}
		
		public function returnItem(item:DisplayObject):void
		{
			if (pool) 
			{
				if (pool.indexOf(item) == -1) 
				{
					pool[_counter] = item;
					_counter++;
				}
				
				
			} else {
				(item as IPoolableObject).destroy();
			}
			
			
		}
		
		public function destroy():void 
		{
			var tempObj:IPoolableObject;
			itemClass = null;
			
			while (pool.length) 
			{
				tempObj = (pool.pop() as IPoolableObject);
				
				if (tempObj) 
				{
					tempObj.destroy();
				}
				
				
			}
			pool = null;
			
		}
		
		public function get counter():int 
		{
			return _counter;
		}
		
	}

}