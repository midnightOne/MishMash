package Levels 
{
	/**
	 * ...
	 * @author Kirill Prymachov aka Midnight
	 */
	public class LevelOne extends Level 
	{
		
		
		
		public function LevelOne() 
		{
			shuffleLevel = 0.1;
			animalNumber = 3;
			animalEnergy; // Relocation speed
			unlockedAnimal;
			availableAnimalTypes = [1,2,3,4,5,6,7,8,9];
			
			grassLayers = ["Grass1","Grass2","Grass3","Grass4"];
			grassLayersNumber = 4;
			debris = ["Tree_1", "Tree_2", "Tree_3", "Bush"];
			debrisNumber = 10;
			
			clouds;
			cloudsNumber;
			cloudMinSppeed;
			cloudMaxSpeed;
		}
		
	}

}