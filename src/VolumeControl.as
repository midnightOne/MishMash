package 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Kirill Prymachov aka Midnight
	 */
	public class VolumeControl 
	{
		private var value:Number;
		private var clip:Sprite;
		private var slider:DisplayObject;
		private var mask:DisplayObject;
		private var _low:Number;
		private var _high:Number;
		private var controlled:Object;
		private var prop:String;
		
		private var left:int;
		private var right:int;
		
		
		public function VolumeControl(controlSprite:Sprite, sliderName:String, initialValue:Number, controlledObject:Object, property:String, low:Number = 0, high:Number = 1) 
		{
			slider = controlSprite.getChildByName(sliderName);
			clip = controlSprite;
			
			clip.mouseChildren = false;
			
			if (controlSprite.getChildByName("_mask")) 
			{
				mask = controlSprite.getChildByName("_mask");
				
				left = mask.x;
				right = mask.x + mask.width;	
			} else 
			{
				left = -controlSprite.width / 2;
				right = controlSprite.width / 2;	
			}
			
					
			
			value = initialValue;
			controlled = controlledObject;
			_low = low;
			_high = high;
			prop = property;
		}
		
		public function activate():void 
		{
			clip.addEventListener(MouseEvent.MOUSE_DOWN, startDrag);
			
		}
		
		private function startDrag(e:MouseEvent):void 
		{
			clip.addEventListener(Event.ENTER_FRAME, update);
			clip.addEventListener(MouseEvent.MOUSE_UP, endDrag);
			clip.removeEventListener(MouseEvent.MOUSE_DOWN, startDrag);
			clip.addEventListener(MouseEvent.MOUSE_MOVE, drag);
			
		}
		
		private function drag(e:MouseEvent):void 
		{
			slider.x = e.localX;
			
		}
		
		private function endDrag(e:MouseEvent):void 
		{
			clip.removeEventListener(MouseEvent.MOUSE_MOVE, drag);
			clip.removeEventListener(Event.ENTER_FRAME, update);
			clip.removeEventListener(MouseEvent.MOUSE_UP, endDrag);
			clip.addEventListener(MouseEvent.MOUSE_DOWN, startDrag);
			//update();
		}
		
		private function update(e:Event=null):void 
		{
			var value:Number;
			
			if (slider.x < left) 
			{
				slider.x = left;
			} else if (slider.x > right) 
			{
				slider.x = right;
			}
			
			value = (slider.x - left) / (right-left);
			
			if (mask) 
			{
				mask.scaleX = value;
			}
			
			
			controlled[prop] = _low + value * (_high-_low);
			
		}
		
		public function deactivate():void 
		{
			clip.removeEventListener(MouseEvent.MOUSE_MOVE, drag);
			clip.removeEventListener(Event.ENTER_FRAME, update);
			clip.removeEventListener(MouseEvent.MOUSE_UP, endDrag);
			clip.removeEventListener(MouseEvent.MOUSE_DOWN, startDrag);
		}
		
		public function init():void 
		{
			
		}
		
		public function destroy():void 
		{
			
		}
		
	}

}