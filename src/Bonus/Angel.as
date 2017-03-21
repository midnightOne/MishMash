package Bonus 
{
	import flash.display.MovieClip;
	import Graphics.PoolableClip;
	
	/**
	 * ...
	 * @author Kirill Prymachov aka Midnight
	 */
	public class Angel extends PoolableClip 
	{
		public var headSkin:int=1;
		public var bodySkin:int=1;
		public var feetSkin:int = 1;
		
		public var dir:int=0;
		
		public function Angel() 
		{
			randomize();
		}
		
		public function randomize():void 
		{
			headSkin = 1 + int(Math.random()*3.999);
			bodySkin = 1 + int(Math.random()*3.999);
			feetSkin = 1 + int(Math.random() * 3.999);
			//this.gotoAndPlay(1);
		}
		
		public function set(head:int, body:int,feet:int):void 
		{
			headSkin = head;
			bodySkin = body;
			feetSkin = feet;
		}
		
	}

}