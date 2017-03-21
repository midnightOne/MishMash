package Levels 
{
	
	/**
	 * ...
	 * @author Kirill Prymachov aka Midnight
	 */
	public class LevelData extends Object
	{
		public var loaded:Boolean=true;
		
		public var shuffleLevel:Number;
		public var animalNumber:int;
		//public var animalEnergy:Number; // Relocation speed
		//public var unlockedAnimal:int; 
		public var availableAnimalTypes:Array;
		
		public var background:String;
		public var grassLayers:Array;
		
		public var debris:Array;
		public var debrisNumber:int = 99;
		
		public var trees:Array;
		public var treeNumber:int
		
		public var clouds:Array;
		public var cloudsNumber:int;
		public var cloudMinSppeed:Number;
		public var cloudMaxSpeed:Number;
		
		public var starsEnabled:Boolean;
		
		public var opponentEnabled:Boolean;
		public var opponentDifficulty:Number;
		
		public function LevelData() 
		{
			
		}
		
	}

}