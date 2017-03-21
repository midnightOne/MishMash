package  
{
	import adobe.utils.CustomActions;
	import flash.display.MovieClip;
	import flash.net.SharedObject;
	import Levels.LevelData;
	
	/**
	 * ...
	 * @author Midnight
	 */
	public class Settings 
	{
		public static var stage:MovieClip;
		public static var traceEnabled:Boolean = true;
		
		public static var animalTypes:Array = [null, "Elephant", "Bull", "Armadillo", "Giraffe", "Croc", "Ram", "Ostrich", "Fox", "Deer"];
		public static var items:Array = ["Bottle","Boot","Cap","Book","Quiver","Bow","Slingshot","Umbrella", "Shades", "Cube"];
		public static var itemsUnlocked:Array = [false, false, false, false, false, false, false, false, false];
		
		private static var updateList:Vector.<Function> = new Vector.<Function>();
		
		public static var unlockedItems:Array = [0, 0, 0, 0, 0, 0, 0, 0, 0];
		
		private static var btnSound1:ButtonSound_1 = new ButtonSound_1;
		private static var btnSound2:ButtonSound_2 = new ButtonSound_2;
		private static var btnSound3:ButtonSound_3 = new ButtonSound_3;
		
		
		public static var cloudSound:CloudSound = new CloudSound;
		public static var cloudSound2:CloudSoundOut = new CloudSoundOut;
		
		public static var toMenu:Function;
		public static var nextLevel:Function;
		
		public static var totalScore:int = 0;
		public static var currentLevelData:LevelData;
		public static var currentDay:int;
		
		public static var newUnlocks:Boolean = false;
		
		public static var levelData:Object;
		public static var so:SharedObject;
		
		public static var currentUnlockFrame:int = 3;
		
		public static var achievements:Array = [0,0,0,0,0];
		
		public function Settings() 
		{
			
			
		}
		
		public  static function unlock(unlockId:int):void 
		{
			switch (unlockId) 
			{
				case 30:
					levelData.animalNumber = 4;
					currentUnlockFrame = 2;
					break;
				case 31:
					levelData.animalNumber = 5;
					currentUnlockFrame = 4;
					break;
				case 32:
					levelData.animalNumber = 6;
					currentUnlockFrame = 6;
					break;
				case 33:
					levelData.animalNumber = 7;
					currentUnlockFrame = 8;
					break;
				case 34:
					levelData.animalNumber = 8;
					currentUnlockFrame = 10;
					break;	
				case 35:
					levelData.animalNumber = 9;
					currentUnlockFrame = 12;
					break;
					
				case 20:
					currentUnlockFrame = 15;
					levelData.grassLayers = ["Grass1_red", "Grass2_red", "Grass3_red", "Grass4_red"];
					levelData.debris = ["Tree_1_red", "Tree_2_red", "Tree_3_red", "Bush_red"];
					levelData.chapter = 2;
					break;
				case 21:
					currentUnlockFrame = 17;
					levelData.grassLayers = ["Grass1_snow", "Grass2_snow", "Grass3_snow", "Grass4_snow"];
					levelData.debris = ["Tree_1_snow", "Tree_2_snow", "Tree_3_snow", "Bush_snow"];
					levelData.chapter = 3;
					break;	
					
				default:
					return;
			}
			
			trace("Unlocking item #" + unlockId);
			so.flush();
			
		}
		
		public static function cloudsIn():void 
		{
			cloudSound.play();
		}
		
		public static function cloudsOut():void 
		{
			cloudSound2.play();
		}
		
		public static function buttonSound():void 
		{
			var rnd:Number = Math.random();
			
			if (rnd < 0.3) 
			{
				btnSound1.play();
			} else if (rnd < 0.6) 
			{
				btnSound2.play();
			} else 
			{
				btnSound3.play();
			}
		}
		
		public static function addToUpdateList(func:Function):void 
		{
			
			for (var i:int = 0; i < updateList.length; i++) 
			{
				if (updateList[i] == null) 
				{
					updateList[i] = func;
					return;
				}
			}
			updateList.push(func);
			
		}
		
		public static function removeFromUpdateList(func:Function):void 
		{
			var index:int = updateList.indexOf(func);
			if (index > -1)
			{
				func[index] = null;
				
			}
			
		}
		
		public static function update():void 
		{
			for (var i:int = 0; i < updateList.length; i++) 
			{
				updateList[i]();
				
			}
			
		}
		
		
	}

}