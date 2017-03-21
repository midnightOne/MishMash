package 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author Kirill Prymachov aka Midnight
	 */
	public class Preloader extends MovieClip 
	{
		private var loader:Preload;
		private var bg:BackGround;
		
		public function Preloader() 
		{
			if (stage) {
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
			}
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// TODO show loader
			bg = new BackGround();
			this.addChild(bg);
			bg.x = 350;
			bg.y = 225;
			
			loader = new Preload();
			loader.x = 160;
			loader.y = 180;
			
			this.addChild(loader);
			loader.gotoAndStop(1);
			loader.scaleX = loader.scaleY = 2;
		}
		
		private function ioError(e:IOErrorEvent):void 
		{
			trace(e.text);
		}
		
		private function progress(e:ProgressEvent):void 
		{
			// TODO update loader
			var loaded:Number = loaderInfo.bytesLoaded;
			var total:Number = loaderInfo.bytesTotal;
			var progress:Number = loaded / total;
			
			loader.gotoAndStop(int(progress*100));
			//progressBar.getChildByName("progress_mc").x = -845 * (1 - progress);
		}
		
		private function checkFrame(e:Event):void 
		{
			if (currentFrame == totalFrames) 
			{
				stop();
				loadingFinished();
			}
		}
		
		private function loadingFinished():void 
		{
			removeEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// TODO hide loader
			
			this.removeChild(bg);
			this.removeChild(loader);
			
			startup();
		}
		
		private function startup():void 
		{
			var mainClass:Class = getDefinitionByName("Main") as Class;
			addChild(new mainClass() as DisplayObject);
		}
		
	}
	
}