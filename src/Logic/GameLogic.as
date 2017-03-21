package Logic 
{
	/**
	 * ...
	 * @author Kirill Prymachov aka Midnight
	 */
	public class GameLogic 
	{
		public var animals:Vector.<Animal>;
		public var availableAnimals:Array;
		
		public var totalNumber:int;
		
		private var iterations:int;
		
		public function GameLogic() 
		{
			animals = new Vector.<Animal>();
		}
		
		public function chooseAnimal():void 
		{
			
		}
		
		public function loadAnimals(availableTypesArray:Array, number:int):void 
		{
			var tempAnimal:Animal;
			//var arr:Array;
			var tempType:int;
			//var lastType:int;
			
			availableAnimals = availableTypesArray;
			totalNumber = number;
			
			//lastType = tempType = availableAnimals[Math.round(Math.random() * availableAnimals.length)];
			//arr.push(tempType);
			
			if (animals) 
			{
				while (animals.length) 
				{
					animals.pop();
				}
				animals = new Vector.<Animal>;
			}
			
			for (var j:int = 0; j < number; j++) 
			{
				/*do
				{
					tempType = availableAnimals[Math.round(Math.random() * availableAnimals.length)];
				} while (tempType == lastType) 
				lastType = tempType;*/
				//tempTypeArr.push(tempType);
				
				if (j < availableAnimals.length) 
				{
					tempType = availableAnimals[j];
				} else 
				{
					tempType = availableAnimals[Math.round(Math.random() * (availableAnimals.length-1))];
				}
				
				
				
				tempAnimal = new Animal();
				tempAnimal.setType(tempType)
				animals.push(tempAnimal);
			}
			
			
		}
		
		public function shuffle(amount:Number):void 
		{
			//var a1:Animal;
			//var a2:Animal;
			var r:int;
			var r2:int;
			
			iterations = 0;
			
			for (var i:int = 0; i < (totalNumber-1); i++) 
			{
				if (amount <= 0.33) 
				{
					r = 1+Math.round(Math.random() * 2);
					r2 = i + 1 + int(Math.random() * (totalNumber - i-2-0.01)); // UNSTABLE int()
					
					exchangeParts(r, animals[i], animals[r2]);
					
				} else if (amount <= 0.66) 
				{
					r = 1 + Math.round(Math.random() * 2);
					
					for (var j:int = 1; j <= 3; j++) 
					{
						if (j != r) 
						{
							r2 = i + 1 + int(Math.random() * (totalNumber - i-2-0.01)); // UNSTABLE int()
							exchangeParts(r, animals[i], animals[r2]);
						}
					}
				} else 
				{
					for (var k:int = 1; k <= 3; k++) 
					{
						r2 = i + 1 + int(Math.random() * (totalNumber - i-2-0.01)); // UNSTABLE int()
						exchangeParts(k, animals[i], animals[r2]);
						
					}
				}
			}
			trace("Animals shuffled by " + iterations + " exchanges.");
		}
		
		/**
		 * Exchanges animal parts based on part number, 1-head,2-feet,3-tail.
		 * @param	partNumber
		 * @param	animal1
		 * @param	animal2
		 */
		
		public function exchangeParts(partNumber:int, animal1:Animal, animal2:Animal):void 
		{
			var temp:int;
			iterations++;
			
			if (partNumber == 1) 
			{
				temp = animal1.head;
				animal1.head = animal2.head;
				animal2.head = temp;
				
			} else if (partNumber == 2) 
			{
				temp = animal1.feet;
				animal1.feet = animal2.feet;
				animal2.feet = temp;
			} else 
			{
				temp = animal1.tail;
				animal1.tail = animal2.tail;
				animal2.tail = temp;
			}
			
		}
		
		public function checkSwap(animal1:Animal, animal2:Animal):Array 
		{
			var arr:Array = [0,0,0];
			var need1:Array = [0,0,0];
			var need2:Array = [0, 0, 0];
			
			var swap:Boolean = false;
			
			// First Animal
			
			if (animal1.type == animal1.head) 
			{
				need1[0] = -1;
			} else if (animal1.type == animal2.head) 
			{
				need1[0] = 1;
			} 
			
			if (animal1.type == animal1.feet) 
			{
				need1[1] = -1;
			} else if (animal1.type == animal2.feet) 
			{
				need1[1] = 1;
			} 
			
			if (animal1.type == animal1.tail) 
			{
				need1[2] = -1;
			} else if (animal1.type == animal2.tail) 
			{
				need1[2] = 1;
			} 
			
			//////////	Second one
			
			if (animal2.type == animal2.head) 
			{
				need2[0] = -1;
			} else if (animal2.type == animal1.head) 
			{
				need2[0] = 1;
			} 
			
			if (animal2.type == animal2.feet) 
			{
				need2[1] = -1;
			} else if (animal2.type == animal1.feet) 
			{
				need2[1] = 1;
			} 
			
			if (animal2.type == animal2.tail) 
			{
				need2[2] = -1;
			} else if (animal2.type == animal1.tail) 
			{
				need2[2] = 1;
			} 
			
			
			
			
			for (var i:int = 0; i < 3; i++) 
			{
				arr[i] = need1[i] + need2[i];
				
				if (arr[i] > 0) 
				{
					swap = true;
				}
			}
			
			if (swap) 
			{
				return arr;
			} else 
			{
				return null;
			}
			
			
		}
		
		public function update():void 
		{
			for (var i:int = 0; i < animals.length; i++) 
			{
				animals[i].update();
				
			}
			
			
		}
		
		
		
		
		public function  destroy():void 
		{
			
		}
		
	}

}