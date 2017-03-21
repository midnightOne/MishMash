package Graphics 
{
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	/**
	 * ...
	 * @author Kirill Prymachov aka Midnight
	 */
	public class CurtainsAnimation extends Curtains 
	{
		// top
		// left
		// right
		// main_left
		// main_right
		
		public function CurtainsAnimation() 
		{
			super();
			
		}
		
		public function tweenIn():void 
		{
			TweenLite.to(top, 0.7, {y:88, ease:Back.easeOut } );
			TweenLite.to(left, 0.7, {x:-360, y:-18, rotation:0 , ease:Back.easeOut } );
			TweenLite.to(right, 0.7, {x:175, y:-18, rotation:0, ease:Back.easeOut } );
			TweenLite.to(main_left, 0.7, { x:-362, ease:Back.easeOut, delay:0.2 } );
			TweenLite.to(main_right, 0.7, { x:362, ease:Back.easeOut, delay:0.2 } );
			
		}
		
		public function setIn():void 
		{
			top.y = 88;
			
			left.x = -360;
			left.y = -18;
			left.rotation = 0;
			
			right.x = 175;
			right.y = -18;
			right.rotation = 0;
			
			main_left.x = -362;
			main_right.x = 362;
		}
		
		public function setOut():void 
		{
			top.y = -22;
			
			left.x = -498;
			left.y = -143;
			left.rotation = 19;
			
			right.x = 316;
			right.y = -93;
			right.rotation = -19;
			
			main_left.x = -737;
			main_right.x = 737;
		}
		
		
		public function tweenOut():void 
		{
			TweenLite.to(top, 0.5, {y:-22, ease:Back.easeIn, delay:0.2 } );
			TweenLite.to(left, 0.5, {x:-498, y:-143, rotation:19 , ease:Back.easeIn, delay:0.2 } );
			TweenLite.to(right, 0.5, {x:316, y:-93, rotation:-19, ease:Back.easeIn, delay:0.2 } );
			TweenLite.to(main_left, 0.5, { x:-737, ease:Back.easeIn } );
			TweenLite.to(main_right, 0.5, { x:737, ease:Back.easeIn } );
		}
	}

}