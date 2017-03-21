package Parallax 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import Graphics.IPoolableObject;
	import Graphics.PoolableClip;
	/**
	 * ...
	 * @author Kirill Prymachov aka Midnight
	 */
	public class ParallaxPerspective 
	{
		private var internalObjects:Vector.<ParallaxObject>;
		private var objectDictionary:Dictionary;
		private var localStage:DisplayObjectContainer;
		
		private var realWidth:Number;
		private var ratio:Number;
		private var _height:Number
		private var scaleObjects:Boolean;
		
		private var debug:Boolean = false;
		
		
		private var cameraPosX:Number;
		
		//=------------------------
		//       CONSTRUCTOR
		//=------------------------
		public function ParallaxPerspective(stage:DisplayObjectContainer, lowerWidth:Number, perspectiveHeight:Number, upperToLowerRatio:Number=0.7, currentCameraPosX:Number = 0, scale:Boolean=true) 
		{
			localStage = stage;
			ratio = upperToLowerRatio;
			realWidth = lowerWidth;
			cameraPosX = currentCameraPosX;
			_height = perspectiveHeight;
			scaleObjects = scale;
			
			internalObjects = new Vector.<ParallaxObject>;
			objectDictionary = new Dictionary(true);
		}
		
		//=------------------------
		//  Adds a DisplayObject to virtual perspective
		//=------------------------
		public function addObject(obj:DisplayObject, localX:Number=0, localY:Number=0, mouseEnabled:Boolean = true):void 
		{
			var tempParObj:ParallaxObject = new ParallaxObject(obj, debug);
			var added:Boolean = false;
			var index:int = 0;
			
			if (!mouseEnabled) 
			{
				tempParObj.mouseEnabled = false;
				tempParObj.mouseChildren = false;
			}
			
			tempParObj.parallaxX = localX;
			tempParObj.parallaxY = localY;
			
			//objectDictionary[obj] = internalObjects.length;
			
			while (index < internalObjects.length)
			{
				if (internalObjects[index] == null)  
				{
					objectDictionary[obj] = tempParObj;
					internalObjects[index] = tempParObj;
					added = true;
				}
				index++;
			}
			
			if (!added) 
			{
				objectDictionary[obj] = tempParObj;
				internalObjects.push(tempParObj);
			}
			
			tempParObj.x = -100;
			tempParObj.y = -100;
			
			localStage.addChild(tempParObj);
			
			
		}
		
		//=------------------------
		//  Removes a DisplayObject from virtual perspective
		//=------------------------
		public function removeObject(obj:DisplayObject):void 
		{
			var tempParObj:ParallaxObject = objectDictionary[obj];
			//internalObjects[internalObjects.indexOf(tempParObj)] = null;
			
			internalObjects.splice(internalObjects.indexOf(tempParObj),1);
			
			
			objectDictionary[obj] = null;
			delete objectDictionary[obj];
			
			localStage.removeChild(tempParObj);
			
			tempParObj.removeChild(obj);
			tempParObj = null;
			
			if (obj is IPoolableObject) 
			{
				(obj as IPoolableObject).returnToPool();
			}
			
		}
		
		public function replaceObject(remove:DisplayObject, substitute:DisplayObject):void 
		{
			var tempParObj:ParallaxObject = objectDictionary[remove];
			
			tempParObj.removeChild(remove);
			tempParObj.addChild(substitute);
			
			objectDictionary[remove] = null;
			delete objectDictionary[remove];
			
			objectDictionary[substitute] = tempParObj;
			
			substitute.scaleX = remove.scaleX;
			substitute.scaleY = remove.scaleY;
			
			if (remove is IPoolableObject) 
			{
				(remove as IPoolableObject).returnToPool();
			}
		}
		
		public function clear():void 
		{
			var tempD:DisplayObject;
			
			for (var i:int = 0; i < internalObjects.length; i++) 
			{
				if (internalObjects[i]) 
				{
					for (var j:int = 0; j < internalObjects[i].numChildren; j++) 
					{
						tempD = internalObjects[i].getChildAt(j);
						
						internalObjects[i].removeChild(tempD);
						if (tempD is PoolableClip) 
						{
							(tempD as PoolableClip).returnToPool();
							
						}
					}
					
					localStage.removeChild(internalObjects[i]);
					internalObjects[i] = null;
				}
			}
			
			//TODO FIX ----------------------------------------------------------------------------------------MEMORY LEAK
			
			internalObjects = new Vector.<ParallaxObject>;
			clearD(objectDictionary);
			objectDictionary = new Dictionary(true);
			
		}
		
		private function clearD(d:Dictionary):void
		{
			//Get Keys from dictionary.
			var idVec:Vector.<Object> = new Vector.<Object>(0);
			for(var obj:Object in d){
				idVec.push(obj);
			}//[next obj]
			
			//Delete Keys from dictionary and clear from vector at same time.
			var vLen:int = idVec.length;
			for(var vi:int = 0; vi<vLen; vi++){
				delete d[ idVec[vi] ];
				idVec[vi] = null;
			}//[next vi]
		}//[FN:clearD]
		
		//=------------------------
		//          Update
		//=------------------------
		public function update(newCameraPosX:Number = -1):void 
		{
			if (newCameraPosX != -1){
				cameraPosX = newCameraPosX;
			}
			
			var generalRatio:Number;
			var distRatio:Number;
			
			for (var i:int = 0; i < internalObjects.length; i++) 
			{
				internalObjects[i].parallaxX += internalObjects[i].dx;
				
				distRatio = (_height-internalObjects[i].parallaxY) / _height;
				generalRatio = 1 - distRatio * (1 - ratio);
				
				internalObjects[i].x = internalObjects[i].parallaxX * generalRatio + cameraPosX * (1 - generalRatio);
				internalObjects[i].y = internalObjects[i].parallaxY - internalObjects[i].parallaxZ * generalRatio;
				
				if (scaleObjects) 
				{
					internalObjects[i].scaleX = internalObjects[i].scaleY = generalRatio;
				}
				
				if (debug) 
				{
					internalObjects[i].updateDebugInfo(distRatio);
					
				}
			}
			sortZ();
			
			
		}
		
		//=------------------------
		//    Z sorting function
		//=------------------------
		private function sortZ():void 
		{
			
			internalObjects.sort(sortCompare);
			
			for(var i:int=0; i<internalObjects.length; i++)
			{
				localStage.setChildIndex(internalObjects[i], i);
			}
		}
		
		private function sortCompare(p1:ParallaxObject, p2:ParallaxObject):int 
		{
			if (p1.parallaxY < p2.parallaxY) 
			{
				return -1;
			} 
			else if (p1.parallaxY > p2.parallaxY)
			{
				return 1;
			}
			
			return 0;
		}
		
		//=------------------------
		//        DESTRUCTOR
		//=------------------------
		public function destroy():void
		{
			
		}
		
		public function get height():Number 
		{
			return _height;
		}
		
	}

}