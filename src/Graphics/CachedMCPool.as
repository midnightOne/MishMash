package Graphics
{
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author Kirill Prymachov aka Midnight
	 */
	public class CachedMCPool extends Pool 
	{
		private var animCache:AnimationCache;
		
		public function CachedMCPool(baseClass:Class, maxlength:int) 
		{
			animCache = AnimationCache.createAnimationCacheFromMC(baseClass);
			super(baseClass, maxlength);
			
		}
		
		override protected function createInstance():DisplayObject 
		{
			var newSprite:PoolableClip = new PoolableClip();
			var bitmapAnim:BitmapAnimation = new BitmapAnimation(animCache);
			newSprite.addChild(bitmapAnim);
			
			//IPoolableObject
			return /*new BitmapAnimation(animCache)*/ newSprite as DisplayObject;
			//return super.createInstance();
		}
		
		override public function destroy():void 
		{
			animCache.destroy();
			animCache = null;
			super.destroy();
		}
		
	}

}