package Graphics 
{
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import Logic.Animal;
	
	/**
	 * ...
	 * @author Kirill Prymachov aka Midnight
	 */
	public class MagicDeskBase extends Sprite 
	{
		public var deskAnimal1:VisualAnimal;
		public var deskAnimal2:VisualAnimal;
		
		private var magicAnimation1:MagicCloud;
		private var magicAnimation2:MagicCloud;
		
		private var loaded1:Boolean = false;
		private var loaded2:Boolean = false;
		
		private var tweeInTime:Number = 0.4;
		private var tweeOutTime:Number = 0.3;
		
		public function MagicDeskBase() 
		{
			deskAnimal1 = new VisualAnimal(null);
			deskAnimal2 = new VisualAnimal(null);
			
			magicAnimation1 = new MagicCloud();
			magicAnimation2 = new MagicCloud();
			
			magicAnimation1.stop();
			magicAnimation2.stop();
			
			magicAnimation1.visible = magicAnimation2.visible = false;
			
			magicAnimation1.x = deskAnimal1.x = -92;
			magicAnimation1.y = deskAnimal1.y = -57;
			
			magicAnimation2.x = deskAnimal2.x = 92;
			magicAnimation2.y = deskAnimal2.y = -57;
			
			this.addChild(deskAnimal1);
			this.addChild(deskAnimal2);
			
			this.addChild(magicAnimation1);
			this.addChild(magicAnimation2);
		}
		
		public function setFirst(model:Animal):void 
		{
			if (model && !loaded1) 
			{
				deskAnimal1.loadNewModel(model);
				deskAnimal1.scaleX = deskAnimal1.scaleY = 0;
				
				TweenLite.to(deskAnimal1, tweeInTime, { scaleX:1, scaleY:1 } );
				loaded1 = true;
				
			} else if (!model == loaded1) 
			{
				TweenLite.to(deskAnimal1, tweeOutTime, { scaleX:0, scaleY:0 } );	
				loaded1 = false;
			}
			
			
			
		}
		
		public function setSecond(model:Animal, callback:Function = null):void 
		{
			if (model && !loaded2) 
			{
				deskAnimal2.loadNewModel(model);
				deskAnimal2.scaleX = deskAnimal2.scaleY = 0;
				
				TweenLite.to(deskAnimal2, tweeInTime, { scaleX:1, scaleY:1, onComplete:callback } );
				loaded2 = true;
				
			} else if (!model == loaded2) 
			{
				TweenLite.to(deskAnimal2, tweeOutTime, { scaleX:0, scaleY:0 } );	
				loaded2 = false;
			}
		}
		
		public function deselect():void 
		{
			setFirst(null);
			setSecond(null);
		}
		
		public function playCloudAnimation():void 
		{
			magicAnimation1.visible = magicAnimation2.visible = true;
			magicAnimation1.play();
			magicAnimation2.play();
		}
		
		public function stopCloudAnimation():void 
		{
			magicAnimation1.visible = magicAnimation2.visible = false;
			magicAnimation1.gotoAndStop(1);
			magicAnimation2.gotoAndStop(1);
		}
		
		public function unloadAnimals():void 
		{
			
		}
		
		public function destroy():void 
		{
			
		}
		
	}

}