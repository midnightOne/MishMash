package Graphics 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import Logic.Animal;
	
	/**
	 * ...
	 * @author Kirill Prymachov aka Midnight
	 */
	public class VisualAnimal extends Sprite 
	{
		public var model:Animal;
		
		public var head:MovieClip;
		public var body:MovieClip;
		public var feetBack:MovieClip;
		public var feetFront:MovieClip;
		public var tail:MovieClip;
		private var shadow:MovieClip;
		
		private var arrow:MovieClip;
		
		private var gv:GraphicVault;
		
		//private var type:String;
		
		
		
		
		
		public function VisualAnimal(animalModel:Animal) 
		{
			gv = GraphicVault.getInstance();
			
			if (animalModel) 
			{
				loadNewModel(animalModel);
			}
			
			//type = Settings.animalTypes[animalModel.type];
			
		}
		
		private function buildAnimal():void 
		{
			
			
			head = gv.getObject(type(model.head) + "Head") as MovieClip;
			feetBack = gv.getObject(type(model.feet) + "FeetBack") as MovieClip;
			feetFront = gv.getObject(type(model.feet) + "FeetFront") as MovieClip;
			body = gv.getObject(type(model.type) + "Body") as MovieClip;
			tail = gv.getObject(type(model.tail) + "Tail") as MovieClip;
			shadow = gv.getObject("Shadow") as MovieClip;
			
			head.x = -10;
			head.y = -66;
			feetBack.x = -12;
			feetBack.y = -22;
			feetFront.x = -27;
			feetFront.y = -22;
			body.x = -34;
			body.y = -46;
			tail.x = -57;
			tail.y = -34;
			shadow.x = -38;
			shadow.y = -13;
			
			this.addChild(shadow);
			this.addChild(feetBack);
			this.addChild(tail);
			this.addChild(body);
			this.addChild(feetFront);
			this.addChild(head);
			
			stop();
			
		}
		
		public function select():void 
		{
			if (!arrow)
			{
				arrow = gv.getObject("Arrow") as MovieClip;
				this.addChild(arrow);
				
				arrow.x = 0;
				arrow.y = -70;
			}
			
		}
		
		public function deselect():void 
		{
			if (arrow) 
			{
				this.removeChild(arrow);
				(arrow as PoolableClip).returnToPool();
				arrow = null;
			}
		}
		
		public function selectionToggle():void 
		{
			if (arrow) 
			{
				deselect();
			} else 
			{
				select();
			}
			
		}
		
		private function type(index:int):String 
		{
			return Settings.animalTypes[index];
			
		}
		
		public function update():void 
		{
			
		}
		
		public function loadNewModel(animalModel:Animal):void 
		{
			if (model) 
			{
				clear();
			}
			
			model = animalModel;
			buildAnimal();
		}
		
		public function clear():void 
		{
			deselect();
			model = null;
			
			this.removeChild(shadow);
			this.removeChild(feetBack);
			this.removeChild(tail);
			this.removeChild(body);
			this.removeChild(feetFront);
			this.removeChild(head);
			
			(shadow as PoolableClip).returnToPool();
			(feetBack as PoolableClip).returnToPool();
			(tail as PoolableClip).returnToPool();
			(body as PoolableClip).returnToPool();
			(feetFront as PoolableClip).returnToPool();
			(head as PoolableClip).returnToPool();
			
			shadow = null;
			feetBack = null;
			tail = null;
			body = null;
			feetFront = null;
			head = null;
		}
		
		public function run():void 
		{
			if (feetBack.currentFrame == 1) 
			{
				feetBack.gotoAndPlay(1);
				tail.gotoAndPlay(1);
				body.gotoAndPlay(1);
				feetFront.gotoAndPlay(1);
				head.gotoAndPlay(1);
			}
			
		}
		
		public function stop():void 
		{
			feetBack.gotoAndStop(1);
			tail.gotoAndStop(1);
			body.gotoAndStop(1);
			feetFront.gotoAndStop(1);
			head.gotoAndStop(1);
		}
		
		public function  destroy():void 
		{
			clear();
			
			gv = null;
		}
		
	}

}