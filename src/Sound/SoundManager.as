package Sound 
{
	import com.greensock.plugins.SoundTransformPlugin;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author Kirill Prymachov aka Midnight
	 */
	public class SoundManager 
	{
		private var dict:Dictionary;
		private var internalSounds:Boolean;
		private var folder:String;
		
		private var soundGroups:Vector.<Vector.<String>>;
		private var soundGroupIds:Dictionary;
		private var soundVolumes:Dictionary;
		private var soundsPlaying:Vector.<SoundChannel>;
		private var soundsPlayingIds:Vector.<String>;
		
		private var screenWidth:int;
		
		private var enabled:Boolean = false;
		
		//public var mute:Boolean = false;
		//public var muteSounds:Boolean;
		
		private var _volume:Number = 1;
		
		private static var instance:SoundManager;
		
		/**
		 * 
		 * @param	Will sounds be loaded from swf or from directroy?
		 * @param	Must not end in "/". Leave empty if same dir as swf.
		 */
		
		public function SoundManager(screen_Width:int = 700, loadSoundsFromSwf:Boolean = true, directory:String = "") 
		{
			this.screenWidth = screen_Width;
			this.folder = directory;
			dict = new Dictionary(true);
			soundVolumes = new Dictionary(true);
			soundsPlaying = new Vector.<SoundChannel>();
			soundsPlayingIds = new Vector.<String>();
			soundGroupIds = new Dictionary(true);
			internalSounds = loadSoundsFromSwf;
			
			soundGroups = new Vector.<Vector.<String>>();
			
			if (directory != "") 
			{
				folder = directory + "/";
			} else 
			{
				folder = "";
			}
			
			if (!instance) 
			{
				instance = this;
			}
		}
		
		public static function getInstance():SoundManager 
		{
			if (instance) 
			{
				return instance;
				
			} else 
			{
				instance = new SoundManager();
				return instance;
			}
			
		}
		
		public function init():void 
		{
			
			
		}
		
		public function addSound(id:String, st:SoundTransform = null, startPos:Number = 0):void 
		{
			if (!enabled) 
			{
				return;
			}
			var tempSound:Sound;
			if (!dict[id]) 
			{
				if (st == null) 
				{
					st = new SoundTransform(1, 0);
				}
				tempSound = getSound(id);
				dict[id] = [tempSound, st, startPos];
				
				soundVolumes[id] = st.volume;
				
				
				
			} else {
				trace("Sound already exists.");
			}
			
			
		}
		
		public function addMultipleSounds(ids:Array):void 
		{
			for (var i:int = 0; i < ids.length; i++) 
			{
				addSound(ids[i]);
			}
		}
		
		public function addSoundGroup(id:String, soundIdArray:Array):void 
		{
			if (!enabled) 
			{
				return;
			}
			
			var tempIndex:int = soundGroups.length;
			soundGroups[tempIndex] = new Vector.<String>();
			
			for (var i:int = 0; i < soundIdArray.length; i++) 
			{
				soundGroups[tempIndex][i] = soundIdArray[i];
				addSound(soundIdArray[i]);
			}
			soundGroupIds[id] = tempIndex;
			
		}
		
		private function getSound(id:String):Sound
		{
			var soundClass:Class;
			var tempSound:Sound;
			
			if (internalSounds) 
			{
				soundClass = getDefinitionByName(id) as Class;
				tempSound = new soundClass();
				
			} else 
			{
				var req:URLRequest = new URLRequest(folder + id); 
				tempSound = new Sound(req);
				//var s:Sound = new Sound(req);
				//s.play(0, 100);
			}
			return tempSound;
		}
		
		
		public function playSound(id:String, repeat:int=1, startPos:Number = -1, objScreenXPos:Number=-1):void 
		{
			if (!enabled) 
			{
				return;
			}
			
			var sc:SoundChannel;
			var st:SoundTransform = dict[id][1];
			
			st.pan = 0;
			st.volume = soundVolumes[id] * _volume;
			
			if (objScreenXPos >= 0 && objScreenXPos <= screenWidth) 
			{
				prepareSTPan(st, objScreenXPos);
			}
			if (startPos == -1) 
			{
				startPos = dict[id][2];
			}
			sc = (dict[id][0] as Sound).play(startPos, repeat, st);
			sc.addEventListener(Event.SOUND_COMPLETE, soundComplete);
			
			soundsPlaying.push(sc);
			soundsPlayingIds.push(id);
		}
		
		public static function play(id:String, repeat:int=1, startPos:Number = 0, objScreenXPos:Number=-1):void 
		{
			if (instance) 
			{
				instance.playSound(id, repeat, startPos, objScreenXPos);
			}
			
		}
		
		private function soundComplete(e:Event):void 
		{
			var soundsPlayingLength:int = soundsPlaying.length;
			for (var i:int = 0; i < soundsPlayingLength; i++) 
			{
				if (soundsPlaying[i] == e.target) 
				{
					e.target.removeEventListener(Event.SOUND_COMPLETE, soundComplete);
					soundsPlayingIds.splice(i, 1);
					soundsPlaying.splice(i, 1);
					break;
				}
			}
			
		}
		
		/*public function fadeOutSound(id:String):void 
		{
			var tempST:SoundTransform;
			var soundsPlayingLength:int = soundsPlaying.length;
			for (var i:int = 0; i < soundsPlayingLength; i++) 
			{
				if (soundsPlayingIds[i] == id) 
				{
					tempST = soundsPlaying[i].soundTransform;
					tempST.volume = tempST.volume - 0.05;
					soundsPlaying[i].soundTransform = tempST;
				}
			}
		}*/
		
		public function stopSound(id:String):void 
		{
			if (!enabled) 
			{
				return;
			}
			
			var soundsPlayingLength:int = soundsPlaying.length;
			for (var i:int = 0; i < soundsPlayingLength; i++) 
			{
				if (soundsPlayingIds[i] == id) 
				{
					soundsPlaying[i].stop();
					soundsPlaying[i].removeEventListener(Event.SOUND_COMPLETE, soundComplete);
					soundsPlayingIds.splice(i, 1);
					soundsPlaying.splice(i, 1);
					soundsPlayingLength--;
					i--;
				}
			}
		}
		
		public static function stopSnd(id:String):void 
		{
			if (instance) 
			{
				instance.stopSound(id);
			}
		}
		
		public function stopAll():void 
		{
			if (!enabled) 
			{
				return;
			}
			
			var tempSC:SoundChannel;
			while (soundsPlaying.length) 
			{
				tempSC = soundsPlaying.pop();
				tempSC.stop();
				tempSC.removeEventListener(Event.SOUND_COMPLETE, soundComplete);
				soundsPlayingIds.pop();
			}
		}
		
		public function updateVolumes():void 
		{
			if (!enabled) 
			{
				return;
			}
			
			var tempST:SoundTransform;
			var soundsPlayingLength:int = soundsPlaying.length;
			for (var i:int = 0; i < soundsPlayingLength; i++) 
			{
				tempST = soundsPlaying[i].soundTransform;
				tempST.volume = soundVolumes[soundsPlayingIds[i]] * _volume;
				soundsPlaying[i].soundTransform = tempST;
				
				//soundsPlaying[i].soundTransform.volume = soundVolumes[soundsPlayingIds[i]] * _volume;
				
				
			}
		}
		
		public function mute(m:Boolean = true):void 
		{
			if (m) 
			{
				SoundMixer.soundTransform = new SoundTransform(0);
			} else 
			{
				SoundMixer.soundTransform = new SoundTransform(1);
			}
		}
		
		/*public function mute():void 
		{
			
		}*/
		
		// Рассчет стереобазы в зависимости от положения звука на экране
		protected static function prepareSTPan(st : SoundTransform, pos : Number) : void {
				st.pan = (pos / (instance.screenWidth/2.0) - 1.0) * 0.5;
		}
		
		public function playSoundGroup(id:String, repeat:int=1, startPos:Number = 0):void 
		{
			if (!enabled) 
			{
				return;
			}
			
			var tempVect:Vector.<String> = soundGroups[soundGroupIds[id]];
			var index:int = int(Math.random() * tempVect.length - 0.01);
			
			playSound(tempVect[index], repeat, startPos);
		}
		
		public static function playGroup(id:String, repeat:int=1, startPos:Number = 0):void 
		{
			if (instance) 
			{
				instance.playSoundGroup(id, repeat, startPos);
			}
		}
		
		public function destroy():void 
		{
			
		}
		
		public function get volume():Number 
		{
			return _volume;
		}
		
		public function set volume(value:Number):void 
		{
			_volume = value;
			updateVolumes();
		}
		
		
	}

}