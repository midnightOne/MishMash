package 
{
	import adobe.utils.CustomActions;
	import com.greensock.easing.*;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import fl.motion.Color;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.net.SharedObject;
	import flash.ui.Keyboard;
	import Graphics.BushBase;
	import Graphics.CurtainsAnimation;
	import Graphics.PoolableClip;
	import Graphics.TreeBase;
	import Graphics.VisualAnimal;
	//import Graphics.VolumeControl;
	import Levels.Level;
	import Levels.LevelData;
	import Levels.LevelOne;
	import Levels.LevelThree;
	import Levels.LevelTwo;
	import Logic.Animal;
	import Logic.GameLogic;
	import Parallax.ParallaxObject;
	import Parallax.ParallaxPerspective;
	import Graphics.GraphicVault;
	import Sound.SoundManager;
	
	/**
	 * ...
	 * @author Kirill Prymachov aka Midnight
	 */
	public class GameController 
	{
		private var _stage:DisplayObjectContainer
		private var parallaxController:ParallaxPerspective;
		private var parallaxStage:DisplayObjectContainer;
		
		// Graphic stuff
		private var magicDesk:MagicDesk;
		private var clockAnimalDesk:ClockAnimalDesk;
		private var beastHolder:BeastHolder;
		
		private var magicAnimation1:MagicCloud;
		private var magicAnimation2:MagicCloud;
		
		private var mDeskUp:int = -10;
		private var mDeskDown:int = 155;
		
		private var animalScale:Number = 1.4;
		
		private var tutorial:Tutorial;
		private var sawTutorial:Boolean = false;
		
		private var debugTutorialEnabled:Boolean = true;
		
		private var experienceBar:ExpBar; 		
		private var unlockMessage:UnlockMessage;
		private var coolBtn:CoolButton;
		
		private var gv:GraphicVault;
		
		private var marks:Vector.<DisplayObject>;
		
		private var timer:Timer;
		//private var unlockMessage:UnlockMessage;
		
		private var levelCompleteMessage:CompleteLevel;
		private var curtains:CurtainsAnimation;
		
		private var giftBox:GiftBox;
		
		private var black:BlackScreen;
		
		private var bonusMessage:BonusMessage;
		
		private var sky:Sky;
		
		private var underArcStage:TheatreStage;
		
		private var itemMessage:ItemMessage;
		
		private var menuSoundPanel:MenuSoundPanel;
		
		private var pauseMenu:PauseMenu;
		
		private var bubblePanel:BubblePanel;
		
		private var achievementProjectileClasses:Array = [CupAch, BeastAch, LireAch, CoinAch, LightningAch];
		private var skyBeast_1:SkyBeastIntro_1;
		private var skyBeast_2:SkyBeastIntro_2;
		private var skyBeast_3:SkyBeastIntro_3;
		
		
		// Logic
		private var gameLogic:GameLogic;
		
		private var selectedAnimal1:VisualAnimal;
		private var selectedAnimal2:VisualAnimal;
		private var oneSelected:Boolean = false;
		
		private var visualAnimals:Vector.<VisualAnimal>;
		
		private var swapArray:Array;
		
		private var animalsMouseEnabled:Boolean = true;
		
		private var framesPassed:uint = 0;
		private var fps:int = 30;
		
		private var animalsCompleted:int = 0;
		private var totalAnimals:int = 0;
		private var starsCollected:int = 0;
		
		private var treesClicked:int = 0;
		private var baseStarFindingChance:Number = 0.3;
		private var currentChance:Number = 0.3;
		
		private var animalExchanges:int = 0;
		
		private var currentLevel:int;
		
		private var currentLevelScore:int;
		
		private var unlockedSomething:Boolean = false;
		
		private var angels:Vector.<AngelRunning>;
		private var caughtAngels:Vector.<AngelCaught>;
		private var bubbleTraps:Array;
		
		private var angelsCaught:int = 0;
		private var bubblesAvailable:int = 5;
		
		private var hudBubbles:Array;
		
		private var mainGame:Boolean = true;
		private var levelLoaded:Boolean;
		
		private var currentComboCount:int = 0;
		private var combo:Boolean = false;
		private var tempComboX:Number = 0;
		private var tempComboY:Number = 0;
		
		private var currentBeastTree:TreeBase;
		private var trees:Vector.<TreeBase>;
		
		//private var currentCombo:int = 0;
		
		private var bonusScore:Number = 0;
		
		private var paused:Boolean = false;
		
		private var beastTimeOut:int = 6; //seconds
		private var beastTimeCount:int = 0;
		private var beastEnabled:Boolean = true;
		private var sm:SoundManager;
		
		private var currentGameDay:int;
		
		private var currentItemsFound:int = 0;
		
		private var volumeControl:VolumeControl;
		
		private var shaker:Shaker;
		
		//Camera
		private var cameraFocusX:Number = 0;
		
		
		
		private var items:Array = [Bottle,Boot,Cap,Book,Quiver,Bow,Slingshot,Umbrella, Shades, Cube];
		
		
		private var starSound:StarSound = new StarSound();
		private var transformSound:TransofrmationSound = new TransofrmationSound();
		private var panelSound:PanelOpenSound = new PanelOpenSound();
		
		private var emptyTree:EmptyTree = new EmptyTree;
		
		private var clearData:Boolean = true;
		
		private var transformSnd:TransofrmationSound = new TransofrmationSound();
		
		
		//Achievements
		private var totalAngelsCaught:int=0;
		private var totalAnimalsCompleted:int=0;
		private var totalBeastsCaught:int = 0;
		
		private var totalAngelsAchievement:int=1;
		private var totalAnimalsAchievement:int=0;
		private var totalBeastsAchievement:int = 1;
		
		private var achFlash:AchievementFlash;
		
		private var waitForAchievement:Boolean=false;
		
		public function GameController() 
		{
			
		}
		
		private function setupInitialLevelData(so:SharedObject):void 
		{
			trace("Setting up Shared Object");
			
			so.data.loaded = true;
			
			so.data.shuffleLevel = 0.1;
			so.data.animalNumber = 3;
			so.data.availableAnimalTypes = [1,2,3,4,5,6,7,8,9];
			
			so.data.background;
			so.data.grassLayers = ["Grass1", "Grass2", "Grass3", "Grass4"];
			so.data.grassLayersNumber = 4;
			
			so.data.debris = ["Tree_1", "Tree_2", "Tree_3", "Bush"];
			so.data.debrisNumber = 10;
			
			so.data.chapter = 1;
			
			//so.data.trees = ["Tree_1", "Tree_2", "Tree_3", "Bush"];
			//so.data.treeNumber = 10;
			
			so.data.clouds;
			so.data.cloudsNumber = 4;
			so.data.cloudMinSpeed = 1;
			so.data.cloudMaxSpeed = 5;
			
			so.data.starsEnabled = false;
			
			so.data.opponentEnabled = false;
			so.data.opponentDifficulty = 0;
			
			
			
			so.data.daysFinished = 0;
			so.data.totalScore = 0;
			
			
			so.flush();
			
		}
		
		
		
		public function init(stage:DisplayObjectContainer):void 
		{
			_stage = stage;
			
			var so:SharedObject = SharedObject.getLocal("Mishmash-DataStorage");
			
			if (!so.data.loaded || clearData){
				setupInitialLevelData(so);
			}
			
			Settings.levelData = so.data;
			Settings.so = so;
			
			angels = new Vector.<AngelRunning>();
			caughtAngels = new Vector.<AngelCaught>();
			bubbleTraps = new Array();
			
			trees = new Vector.<TreeBase>();
			
			marks = new Vector.<DisplayObject>();
			
			timer = new Timer();
			timer.stop();
			timer.scaleX = timer.scaleY = 0.76;
			
			timer.x = 780;
			timer.y = 150;
			
			black = new BlackScreen();
			black.x = 350;
			black.y = 225;
			black.alpha = 0;
			
			giftBox = new GiftBox;
			giftBox.x = 350;
			giftBox.y = 225;
			giftBox.stop();
			
			underArcStage = new TheatreStage();
			underArcStage.x = 350;
			underArcStage.y = 540;
			
			itemMessage = new ItemMessage();
			itemMessage.stop();
			itemMessage.x = 631;
			itemMessage.y = 495;
			
			resetComboMeter();
			
			sky = new Sky();
			sky.cacheAsBitmap = true;
			sky.stop();
			
			_stage.addChild(sky);
			
			//hudBubbles = new Array();
			
			bonusMessage = new BonusMessage();
			bonusMessage.x = 350;
			bonusMessage.y = 225;
			bonusMessage.stop();
			
			////////////////
			parallaxStage = new Sprite as DisplayObjectContainer;
			parallaxStage.y = 150;
			//parallaxStage.x;
			
			visualAnimals = new Vector.<VisualAnimal>();
			
			magicDesk = new MagicDesk();
			magicDesk.x = 350;
			magicDesk.y = mDeskUp;
			
			_stage.addChild(magicDesk);
			stage.addChild(parallaxStage)
			parallaxController = new ParallaxPerspective(parallaxStage, 1200, 300, 0.6, 600, true);
			
			tutorial = new Tutorial();
			
			sm = SoundManager.getInstance();
			
			currentGameDay = 0;
			
			menuSoundPanel = new MenuSoundPanel();
			menuSoundPanel.x = 641;
			menuSoundPanel.y = -27;
			
			menuSoundPanel.cross.mouseEnabled = false;
			
			pauseMenu = new PauseMenu();
			pauseMenu.x = 350;
			pauseMenu.y = 225;
			
			bubblePanel = new BubblePanel();
			bubblePanel.x = 350;
			bubblePanel.y = 478;
			
			hudBubbles = [bubblePanel.bubble_1, bubblePanel.bubble_2, bubblePanel.bubble_3, bubblePanel.bubble_4, bubblePanel.bubble_5];
			
			
			volumeControl = new VolumeControl(pauseMenu.soundVolume, "slider", 1, sm, "volume");
			
			shaker = new Shaker(_stage, 700, 450,80,0.8,true,1);
			
			achFlash = new AchievementFlash();
			achFlash.stop();
			
			skyBeast_1 = new SkyBeastIntro_1();
			skyBeast_2 = new SkyBeastIntro_2();
			skyBeast_3 = new SkyBeastIntro_3();
			
			skyBeast_1.stop();
			skyBeast_2.stop();
			skyBeast_3.stop();
			
			skyBeast_1.x = 18;
			skyBeast_1.y = 464;
			
			skyBeast_2.x = 682;
			skyBeast_2.y = 464;
			
			skyBeast_2.scaleX = -1;
			
			skyBeast_3.x = 18;
			skyBeast_3.y = 464;
			
			
			/*
			for (var j:int = 0; j < 15; j++) 
			{
				parallaxTest.addObject(new Grass(), Math.random()*100+300, 30*j);
				
			}*/
			
			
			/*parallaxTest.addObject(new Grass1(), 600, 50);
			parallaxTest.addObject(new Grass2(), 600, 120);
			parallaxTest.addObject(new Grass3(), 600, 200);*/
			
			
			//var gv:GraphicVault = GraphicVault.getInstance();
			
			//gv.setupAPoolFor(testObject, "to",false, 50);
			
			/*for (var i:int = 0; i < 50; i++) 
			{
				parallaxTest.addObject(gv.getObject("to"), Math.random() * 1200, Math.random() * 300);
				
			}//*/////////////
			
			//unlockMessage = new UnlockMessage();
			
			gv = GraphicVault.getInstance();
			
			gameLogic = new GameLogic();
			
			
			
			beastHolder = new BeastHolder();
			beastHolder.x = 350;
			beastHolder.y = 483; //387
			beastHolder.cacheAsBitmap = true;
			
			
			
			clockAnimalDesk = new ClockAnimalDesk();
			clockAnimalDesk.x = 7;
			clockAnimalDesk.y = -130;
			
			clockAnimalDesk.count.text = "0/" + totalAnimals;
			
			
			
			
			magicAnimation1 = new MagicCloud();
			magicAnimation2 = new MagicCloud();
			
			magicAnimation1.stop();
			magicAnimation2.stop();
			magicAnimation1.visible = magicAnimation2.visible = false;
			
			levelCompleteMessage = new CompleteLevel();
			levelCompleteMessage.x = 350;
			levelCompleteMessage.y = 0;
			levelCompleteMessage.day.init(1);
			levelCompleteMessage.day.downscaleLarger = 1;
			
			curtains = new CurtainsAnimation();
			curtains.x = 350;
			curtains.y = 0;
			
			initGraphics();
			
			experienceBar = new ExpBar();
			experienceBar.init(levelCompleteMessage.expBar, 0, 3000, 0, [1200], [30, 31, 32]);
			//experienceBar.init(levelCompleteMessage.expBar, 0, 3000, 0, [500,1000,1600], [30,31,32]);
			
			//experienceBar = new ExpBar();
			//experienceBar.x = 350;
			//experienceBar.y = -50;
			
			unlockMessage = new UnlockMessage();
			unlockMessage.x = 350;
			unlockMessage.y = 225;
			
			coolBtn = new CoolButton();
			coolBtn.x = 350;
			coolBtn.y = 225;
			
			
			//_stage.addChild(magicDesk);
			_stage.addChild(clockAnimalDesk);
			_stage.addChild(beastHolder);
			_stage.addChild(menuSoundPanel);
			
			//_stage.addChild(magicAnimation1);
			//_stage.addChild(magicAnimation2);
			
			
		}
		
		private function resetComboMeter():void 
		{
			timer.x = 780;
			TweenLite.set(timer.combo, {scaleX:0.5,scaleY:0.5, x: -22, y: -41, rotation: -90} );
			TweenLite.set(timer.points, {scaleX:0.3,scaleY:0.3, x: -37, y: -2, rotation: -90} );
			TweenLite.set(timer.multiplier, {scaleX:0.3,scaleY:0.3, x: -9, y: 11, rotation: -90} );
		}
		
		//=------------------------------------
		//   LOADS LEVEL
		//=------------------------------------
		public function loadLevel(level:Object):void 
		{
			if (!mainGame) 
			{
				loadBonusLevel();
				return;
			}
			
			
			levelLoaded = true;
			
			TweenLite.to(beastHolder,0.5, {y:410});
			TweenLite.to(clockAnimalDesk, 0.5, { y:7 } );
			TweenLite.to(menuSoundPanel, 0.5, {y:27});
			
			level = Settings.levelData;
			
			if (level.chapter == 1) 
			{
				sm.playSound("ambient_summer.mp3",10);
			} else if (level.chapter == 2) 
			{
				sm.playSound("ambient_autumn.mp3",10);
			} else {
				sm.playSound("ambient_winter.mp3",10);
			}
			
			beastHolder.beast_1.gotoAndStop(1);
			beastHolder.beast_2.gotoAndStop(1);
			beastHolder.beast_3.gotoAndStop(1);
			
			beastHolder.beast_1.scaleX = beastHolder.beast_1.scaleY = 0;
			beastHolder.beast_2.scaleX = beastHolder.beast_2.scaleY = 0;
			beastHolder.beast_3.scaleX = beastHolder.beast_3.scaleY = 0;
			
			
			gameLogic.loadAnimals(level.availableAnimalTypes, level.animalNumber);
			gameLogic.shuffle(level.shuffleLevel);
			
			var tempAnimal:VisualAnimal;
			var tempIndex:int;
			//var gv:GraphicVault = GraphicVault.getInstance();
			var tempDisplayObject:DisplayObject;
			var rand1:Number;
			var rand2:Number;
			var treePositionsX:Vector.<Number> = new Vector.<Number>;
			var treePositionsY:Vector.<Number> = new Vector.<Number>;
			
			var minTreeDistSquare:Number = 10000;
			var canBePlaced:Boolean = true;
			
			totalAnimals = level.animalNumber;
			clockAnimalDesk.count.text = "0/" + totalAnimals;
			
			for (var i:int = 0; i < totalAnimals; i++) 
			{
				trace("-------------------------");
				trace("Animal: " + gameLogic.animals[i].type);
				trace("Head: " + gameLogic.animals[i].head);
				trace("Feet: " + gameLogic.animals[i].feet);
				trace("Tail: " + gameLogic.animals[i].tail);
				
				tempAnimal = new VisualAnimal(gameLogic.animals[i]);
				tempAnimal.scaleX = tempAnimal.scaleY = animalScale;
				
				//this._stage.addChild(tempAnimal);
				
				rand1 = Math.random() * 1200;
				rand2 = 20 + Math.random() * 250;
				
				gameLogic.animals[i].x = rand1;
				gameLogic.animals[i].y = rand2;
				
				gameLogic.animals[i].destinationX = Math.random() * 1200;
				gameLogic.animals[i].destinationY = 20 + Math.random() * 250;
				
				parallaxController.addObject(tempAnimal, rand1, rand2);//70 + (i % 5) * 120, 50 + int(i / 5) * 120);
				
				//tempAnimal.x = 70+(i % 5) * 120;
				//tempAnimal.y = 250+int(i / 5) * 120;
				
				tempAnimal.mouseChildren = false;
				
				visualAnimals.push(tempAnimal);
			}
			
			for (var j:int = 0; j < level.grassLayersNumber; j++) 
			{
				/*tempIndex = int(Math.random() * (level.grassLayers.length -0.01));
				tempDisplayObject = gv.getObject(level.grassLayers[tempIndex]);
				//tempDisplayObject.
				parallaxController.addObject(tempDisplayObject, 600, (parallaxController.height/level.grassLayersNumber)*j,false);*/
				tempDisplayObject = gv.getObject(level.grassLayers[level.grassLayersNumber - j - 1]);
				tempDisplayObject.cacheAsBitmap = true;
				parallaxController.addObject(tempDisplayObject, 600, (parallaxController.height/level.grassLayersNumber)*j,false);
				
			}
			
			for (var k:int = 0; k < level.debrisNumber; k++) 
			{
				tempIndex = int(Math.random() * (level.debris.length -0.01));
				tempDisplayObject = gv.getObject(level.debris[tempIndex]);
				tempDisplayObject.scaleX = tempDisplayObject.scaleY = 1.2;
				
				//tempDisplayObject.cacheAsBitmap = true;
				(tempDisplayObject as MovieClip).mouseChildren = false;
				do
				{
					canBePlaced = true;
					
					rand1 = Math.random() * 1200;
					rand2 = Math.random() * 300;
					
					for (var l:int = 0; l < treePositionsX.length; l++) 
					{
						if ((treePositionsX[l]-rand1)*(treePositionsX[l]-rand1) + (treePositionsY[l]-rand2)*(treePositionsY[l]-rand2) < minTreeDistSquare) 
						{
							canBePlaced = false;
						}
						
					}
					
				}while (pointInEllipse(rand1,rand2,600,300,650,200) || !canBePlaced)
				
				//rand = Math.random() * 1200 * 300;
				
				treePositionsX.push(rand1);
				treePositionsY.push(rand2);
				
				if (rand1 < 130) 
				{
					tempDisplayObject.scaleX = -tempDisplayObject.scaleX;
				} /*else if (rand1 < 1150) 
				{
					tempDisplayObject.scaleX *= (Math.round(Math.random()) * 2 -1);
				}*/
				
				trees.push(tempDisplayObject as TreeBase);
				
				parallaxController.addObject(tempDisplayObject, rand1, rand2 );//Math.random() * 1200, Math.random() * 300);
			}
			
			/*parallaxTest.addObject(new Grass1(), 600, 50);
			parallaxTest.addObject(new Grass2(), 600, 120);
			parallaxTest.addObject(new Grass3(), 600, 200);*/
			
			_stage.addChild(timer);
			//TweenLite.to(timer, 0.5, {x:640, ease:Back.easeOut});
			
			_stage.addEventListener(MouseEvent.CLICK, clickObject);
			_stage.addEventListener(Event.ENTER_FRAME, update);
			
			_stage.stage.addEventListener(Event.DEACTIVATE, pause);
			menuSoundPanel.menu_btn.addEventListener(MouseEvent.CLICK, pause);
			menuSoundPanel.sound_btn.addEventListener(MouseEvent.CLICK, mute);
			
			_stage.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			_stage.stage.focus = null;
			
			randomizeBeastPosition();
			paused = false;
			
			update();
			
			
		}
		
		private function keyDown(e:KeyboardEvent):void 
		{
			trace("KeyDown");
			if (e.keyCode == 77) 
			{
				shaker.startShake();
				trace("Shake!");
			}
		}
		
		private function mute(e:MouseEvent):void 
		{
			if (menuSoundPanel.cross.currentFrame == 2) 
			{
				sm.mute(true);
				menuSoundPanel.cross.gotoAndStop(1);
			} else {
				sm.mute(false);
				menuSoundPanel.cross.gotoAndStop(2);
			}
			
		}
		
		private function pause(e:Event):void 
		{
			_stage.stage.removeEventListener(Event.DEACTIVATE, pause);
			menuSoundPanel.menu_btn.removeEventListener(MouseEvent.CLICK, pause);
			
			paused = true;
			black.alpha = 0;
			//pauseMenu.scaleX = pauseMenu.scaleY = 0;
			pauseMenu.y = -187;
			
			_stage.addChild(black);
			_stage.addChild(pauseMenu);
			
			
			TweenLite.to(black, 0.5, {alpha:0.5});
			TweenLite.to(pauseMenu, 0.7, {y:225/*, scaleX:1, scaleY:1*/, ease:Back.easeOut});
			
			volumeControl.activate();
			
			black.addEventListener(MouseEvent.CLICK, unpause);
			pauseMenu.resume.addEventListener(MouseEvent.CLICK, unpause);
			
			pauseMenu.main.addEventListener(MouseEvent.CLICK, exitToMenu);
			
		}
		
		private function unpause(e:MouseEvent):void 
		{
			volumeControl.deactivate();
			
			black.removeEventListener(MouseEvent.CLICK, unpause);
			pauseMenu.resume.removeEventListener(MouseEvent.CLICK, unpause);
			
			TweenLite.to(black, 0.5, {alpha:0, delay: 0.1});
			TweenLite.to(pauseMenu, 0.6, {y:-187,/* scaleX:0, scaleY:0,*/ ease:Back.easeIn, onComplete:removePauseMenu});
			paused = false;
			
			_stage.stage.addEventListener(Event.DEACTIVATE, pause);
			//menuSoundPanel.menu_btn.addEventListener(MouseEvent.CLICK, pause);
			//pauseMenu.main.removeEventListener(MouseEvent.CLICK, exitToMenu);
		}
		
		private function removePauseMenu():void 
		{
			menuSoundPanel.menu_btn.addEventListener(MouseEvent.CLICK, pause);
			pauseMenu.main.removeEventListener(MouseEvent.CLICK, exitToMenu);
			
			_stage.removeChild(black);
			_stage.removeChild(pauseMenu);
			
			
		}
		
		public function go():void 
		{
			if (!mainGame) 
			{
				return;
			}
			
			if (!sawTutorial && debugTutorialEnabled) 
			{
				_stage.removeEventListener(MouseEvent.CLICK, clickObject);
				_stage.removeEventListener(Event.ENTER_FRAME, update);
				showTutorial();
			} else 
			{
				_stage.addEventListener(MouseEvent.CLICK, clickObject);
				_stage.addEventListener(Event.ENTER_FRAME, update);
			}
			
		}
		
		
		//=------------------------------------
		//   Tutorial Stuff
		//=------------------------------------
		
		private function showTutorial():void 
		{
			sawTutorial = true;
			
			_stage.addChild(tutorial);
			tutorial.x = 350;
			tutorial.y = -200;
			
			
			
			tutorial.start.visible = false;
			
			tutorial.gotoAndStop(1);
			
			TweenLite.to(tutorial, 0.8, { y:225, ease:Back.easeOut } );
			
			tutorial.addEventListener(MouseEvent.CLICK,tutorialButtons);
			
		}
		
		private function tutorialButtons(e:MouseEvent):void 
		{
			
			if (e.target.name == "right") 
			{
				tutorial.gotoAndStop(tutorial.currentFrame + 1);
				
				/*if (tutorial.currentFrame == 2) 
				{
					_stage.addChild(skyBeast_1);
					skyBeast_1.play();
				} else if (tutorial.currentFrame == 3) 
				{
					_stage.removeChild(skyBeast_1);
					//TweenLite.to(skyBeast_1, 0.7, {frame:1 } );
					_stage.addChild(skyBeast_2);
					skyBeast_2.play();
				}*/
				
				
				if (tutorial.currentFrame == 3) 
				{
					tutorial.start.visible = true;
				}
			} else if (e.target.name == "left") 
			{
				tutorial.gotoAndStop(tutorial.currentFrame-1);
			} else if (e.target.name == "start") 
			{
				hideTutorial();
			}
			
		}
		
		private function hideTutorial():void 
		{
			tutorial.removeEventListener(MouseEvent.CLICK, tutorialButtons);
			
			TweenLite.to(tutorial, 0.7, { y:-200, ease:Back.easeIn, onComplete:removeTutorial } );
			
			//_stage.removeChild(skyBeast_2);
			
			_stage.addEventListener(MouseEvent.CLICK, clickObject);
			_stage.addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function removeTutorial():void 
		{
			_stage.removeChild(tutorial);
		}
		
		
		/**
		 * Returns true if @testPoint is in the ellipse parameters.
		 * @param	testPoint, the point to test against
		 * @param	center, the center point of the ellipse
		 * @param	width, the width radius of the ellipse
		 * @param	height, the height radius of the ellipse
		 * @return
		 */
		public function pointInEllipse(testPointX:Number,testPointY:Number, centerX:Number, centerY:Number, width:Number, height:Number):Boolean {
			var dx:Number = testPointX - centerX;
			var dy:Number = testPointY - centerY;
			return ( dx * dx ) / ( width * width ) + ( dy * dy ) / ( height * height ) <= 1;
		}
		
		private function clickObject(e:MouseEvent):void 
		{
			trace(e.target);
			
			if (e.target is VisualAnimal) 
			{
				clickAnimal(e.target as VisualAnimal);		
				e.stopPropagation();
			} else if (e.target is TreeBase) 
			{
				clickTree(e.target as TreeBase)
				e.stopPropagation();
			}
			
		}
		
		private function clickAnimal(animal:VisualAnimal):void 
		{
			if (animalsMouseEnabled)
			{	
				if (oneSelected) 
				{
					if (selectedAnimal1 == animal) 
					{
						selectedAnimal1 = null;
						oneSelected = false;
						magicDesk.setFirst(null);
						TweenLite.to(magicDesk, 0.2, { y:mDeskUp } );
						//panelSound.play();
						sm.playSound("panel_open.mp3");
						
					} else 
					{
						selectedAnimal2 = animal;
						magicDesk.setSecond(selectedAnimal2.model, swap);
						animal.select();
						animalsMouseEnabled = false;
						//swap();
						return;
					}
				} else 
				{
					TweenLite.to(magicDesk, 0.2, { y:mDeskDown } );
					//panelSound.play();
					sm.playSound("panel_open.mp3");
					
					selectedAnimal1 = animal;
					oneSelected = true;
					
					magicDesk.setFirst(selectedAnimal1.model);
					magicDesk.check.gotoAndStop(0);
				}
				
				
				animal.selectionToggle();
			}
		}
		
		private function swap():void 
		{
			trace("Swapping");
			
			var model1:Animal = selectedAnimal1.model;
			var model2:Animal = selectedAnimal2.model;
			swapArray = gameLogic.checkSwap(model1, model2);
			
			
			if (swapArray) // Swapping needed
			{
				trace("Needed");
				
				animalExchanges++;
				
				magicAnimation1.visible = true;
				magicAnimation2.visible = true;
				
				magicAnimation1.play();
				magicAnimation2.play();
				
				selectedAnimal1.addChild(magicAnimation1);
				selectedAnimal2.addChild(magicAnimation2);
				
				//magicAnimation1.x = selectedAnimal1.x;
				//magicAnimation1.y = selectedAnimal1.y;
				
				//magicAnimation2.x = selectedAnimal2.x;
				//magicAnimation2.y = selectedAnimal2.y;
				
				magicDesk.playCloudAnimation();
				
				TweenLite.delayedCall(5, actualSwap, null, true);
				TweenLite.delayedCall(22, swapEnd, null, true);
				
				magicDesk.check.gotoAndStop(3);
				
				//transformSound.play();
				sm.playSound("transformation.mp3");
				
				transformSnd.play();
			} else // No swapping
			{
				trace("Not Needed");
				magicDesk.check.gotoAndStop(2);
				TweenLite.to(magicDesk, 0.2, { y:mDeskUp } );
				//panelSound.play();
				sm.playSound("panel_open.mp3");
				sm.playSound("transformation_wrong.mp3");
				animalsMouseEnabled = true;
				selectedAnimal1.deselect();
				selectedAnimal2.deselect();
				magicDesk.deselect();
				oneSelected = false;
			}
			
			
		}
		
		private function actualSwap():void 
		{
			var model1:Animal = selectedAnimal1.model;
			var model2:Animal = selectedAnimal2.model;
			
			for (var i:int = 0; i < 3; i++) 
				{
					if (swapArray[i] > 0) 
					{
						gameLogic.exchangeParts(i + 1, model1, model2);
						exchangeVisualParts(i + 1, selectedAnimal1, selectedAnimal2);
						exchangeVisualParts(i + 1, magicDesk.deskAnimal1, magicDesk.deskAnimal2);
					}
				}
		}
		
		private function tintColor(mc:Sprite, colorNum:Number, alphaSet:Number):void {
			var cTint:Color = new Color();
			cTint.setTint(colorNum, alphaSet);
			mc.transform.colorTransform = cTint;
		}
		
		private function swapEnd():void 
		{
			var animalscompletedThisTurn:int = 0;
			var tempX:Number;;
			
			TweenLite.to(magicDesk, 0.2, { y:mDeskUp } );
			//panelSound.play();
			sm.playSound("panel_open.mp3");
			
			magicAnimation1.visible = false;
			magicAnimation2.visible = false;
			
			magicAnimation1.gotoAndStop(1);
			magicAnimation2.gotoAndStop(1);
			
			selectedAnimal1.removeChild(magicAnimation1);
			selectedAnimal2.removeChild(magicAnimation2);
			
			magicDesk.stopCloudAnimation();
			magicDesk.deselect();
			
			selectedAnimal1.deselect();
			selectedAnimal2.deselect();
			
			if (selectedAnimal1.model.completed()) 
			{
				selectedAnimal1.mouseEnabled = false;
				
				tintColor(selectedAnimal1 as Sprite, 0x000000, 0.3);
				//colorTransform = selectedAnimal1.transform.colorTransform;
				//(colorTransform as ColorTransform).greenMultiplier = 0.1;
				
				animalsCompleted++;
				totalAnimalsCompleted++;
				animalscompletedThisTurn++;
				//addToCombo();
				
				tempX = selectedAnimal1.parent.x + parallaxStage.x;
				if (tempX < 50) 
				{
					tempX = 50;
				} else if (tempX > 650) 
				{
					tempX = 650;
				}
				
				showScoreAt("Score_100", tempX, selectedAnimal1.parent.y + parallaxStage.y - 50);
				
			}
			
			if (selectedAnimal2.model.completed()) 
			{
				selectedAnimal2.mouseEnabled = false;
				
				tintColor(selectedAnimal2 as Sprite, 0x000000, 0.3);
				
				animalsCompleted++;
				animalscompletedThisTurn++;
				
				tempX = selectedAnimal2.parent.x + parallaxStage.x;
				if (tempX < 50) 
				{
					tempX = 50;
				} else if (tempX > 650) 
				{
					tempX = 650;
				}
				
				showScoreAt("Score_100", tempX, selectedAnimal2.parent.y + parallaxStage.y - 50);
				
			}
			
			addToCombo(animalscompletedThisTurn);
			
			trace("Animals: "+animalsCompleted + "/" + totalAnimals);
			clockAnimalDesk.count.text = animalsCompleted + "/" + totalAnimals;
			
			/*if (animalsCompleted == totalAnimals) 
			{
				win();
			}*/
			
			selectedAnimal1 = null;
			selectedAnimal2 = null;
			
			oneSelected = false;
			
			animalsMouseEnabled = true;
		}
		
		private function addToCombo(number:int):void 
		{
			if (number < 1) 
			{
				return;
			}
			
			currentComboCount += number;
			
			if (!combo) 
			{
				TweenLite.to(timer, 0.5, { x:640, ease:Back.easeOut } );
				timer.gotoAndPlay(1);
				combo = true;
				
				TweenLite.to(timer.combo, 0.5, {scaleX:0.75,scaleY:0.75, x: -22, y: -41, rotation: -9.7, ease:Back.easeOut, delay:0.1 } );
				//TweenLite.to(timer.points, 0.5, {scaleX:1,scaleY:1, x: -37, y: -2, rotation: -16, ease:Back.easeOut, delay:0.2 } );
				//TweenLite.to(timer.multiplier, 0.5, {scaleX:1,scaleY:1, x: -9, y: 11, rotation: -29, ease:Back.easeOut, delay:0.3 } );
				
				
			} else 
			{
				TweenMax.to(timer, 0.3, { frame:1, onComplete:timer.play } );
				//timer.gotoAndPlay(1);
			}
			
			
			if (currentComboCount == 2) 
			{
				timer.points.gotoAndStop(1);
				timer.multiplier.gotoAndStop(1);
				
				TweenLite.to(timer.points, 0.5, {scaleX:1,scaleY:1, x: -37, y: -2, rotation: -16, ease:Back.easeOut } );
				TweenLite.to(timer.multiplier, 0.5, {scaleX:1,scaleY:1, x: -9, y: 11, rotation: -29, ease:Back.easeOut, delay:0.1 } );
			} else if (currentComboCount > 2) 
			{
				TweenLite.to(timer.points, 0.5, {scaleX:0.3,scaleY:0.3, x: -37, y: -2, rotation: -90, ease:Back.easeIn, delay:0.1} );
				TweenLite.to(timer.multiplier, 0.5, {scaleX:0.3,scaleY:0.3, x: -9, y: 11, rotation: -90, ease:Back.easeIn } );
				
				TweenLite.delayedCall(0.6, setComboLabels);
				
				TweenLite.to(timer.points, 0.5, {scaleX:1,scaleY:1, x: -37, y: -2, rotation: -16, ease:Back.easeOut, delay:0.6 } );
				TweenLite.to(timer.multiplier, 0.5, {scaleX:1,scaleY:1, x: -9, y: 11, rotation: -29, ease:Back.easeOut, delay:0.7 } );
			}
			
			
			
		}
		
		private function setComboLabels():void 
		{
			timer.points.gotoAndStop(currentComboCount-1);
			timer.multiplier.gotoAndStop(currentComboCount-1);
		}
		
		
		
		public function exchangeVisualParts(partNumber:int, animal1:VisualAnimal, animal2:VisualAnimal):void 
		{
			var tempIndex:int;
			var tempDisplayObject:MovieClip;
			
			if (partNumber == 1) 
			{
				tempIndex = animal1.getChildIndex(animal1.head);
				animal1.removeChild(animal1.head);
				animal2.addChildAt(animal1.head, animal2.getChildIndex(animal2.head));
				animal1.addChildAt(animal2.head, tempIndex);
				
				tempDisplayObject = animal1.head;
				animal1.head = animal2.head;
				animal2.head = tempDisplayObject;
				
			} else if (partNumber == 2) 
			{
				tempIndex = animal1.getChildIndex(animal1.feetBack);
				animal1.removeChild(animal1.feetBack);
				animal2.addChildAt(animal1.feetBack, animal2.getChildIndex(animal2.feetBack));
				animal1.addChildAt(animal2.feetBack, tempIndex);
				
				tempDisplayObject = animal1.feetBack;
				animal1.feetBack = animal2.feetBack;
				animal2.feetBack = tempDisplayObject;
				
				tempIndex = animal1.getChildIndex(animal1.feetFront);
				animal1.removeChild(animal1.feetFront);
				animal2.addChildAt(animal1.feetFront, animal2.getChildIndex(animal2.feetFront));
				animal1.addChildAt(animal2.feetFront, tempIndex);
				
				tempDisplayObject = animal1.feetFront;
				animal1.feetFront = animal2.feetFront;
				animal2.feetFront = tempDisplayObject;
				
			} else if (partNumber == 3) 
			{
				tempIndex = animal1.getChildIndex(animal1.tail);
				animal1.removeChild(animal1.tail);
				animal2.addChildAt(animal1.tail, animal2.getChildIndex(animal2.tail));
				animal1.addChildAt(animal2.tail, tempIndex);
				
				tempDisplayObject = animal1.tail;
				animal1.tail = animal2.tail;
				animal2.tail = tempDisplayObject;
				
			} 
			
		}
		
		
		private function clickTree(tree:TreeBase):void 
		{
			var obj1:Object;
			var obj2:Object;
			
			var tempDisplayObject:DisplayObject;
			var star:FallingBeast;
			var item:MovieClip;
			var rand:Number = Math.random();
			var rand2:Number;
			
			treesClicked++;
			
			if (tree.containsItem > 0) 
			{
				trace("BEAST FOUND");
				
				totalBeastsCaught++;
				
				beastTimeCount = 0;
				//randomizeBeastPosition();
				
				star = new FallingBeast;
				star.y = -100;
				
				star.stop();
				
				star.scaleX	= star.scaleY = 0.4;
				
				//starSound.play();
				sm.playSound("beast_caught.mp3");
				
				obj1 = { x:100, y: -185 };
				obj2 = { x:125, y:0 };
				
				if (tree.parent.x > 1000) 
				{
					obj1.x *= -1;
					obj2.x *= -1;
					
				}
				
				TweenMax.to(star, 1.5, {scaleX:1.2,scaleY:1.2, bezierThrough:[obj1, obj2], orientToBezier:true, ease:SlowMo.ease.config(0.3, 0.85), onComplete:star.gotoAndStop, onCompleteParams:[2]});
				
				tree.parent.addChildAt(star,0);
				starsCollected++;
				updateStarsDesk();
				
				//currentBeastTree.gotoAndStop(1);
				currentBeastTree.containsItem = -1;
				currentBeastTree = null;
				//return;
			} else if (rand < 0.8) 
			{
				for (var i:int = 0; i < 5; i++) 
				{
					addGarbage(tree);
				}
				
				
				/*tempDisplayObject = gv.getObject("Garbage");;
				tempDisplayObject.y = -50;
				tempDisplayObject.x = 0;*/
				
				//star.scaleX	= star.scaleY = 0.4;
				
				//starSound.play();
				//rand2 = (50+Math.random()*100)*(Math.round(Math.random())*2-1);
				//TweenMax.to(tempDisplayObject, 0.8, {scaleX:1.2,scaleY:1.2, bezierThrough:[{x:rand2*0.7, y:-170}, {x:rand2, y:0}], orientToBezier:true, ease:SlowMo.ease.config(0.3, 0.85), onComplete:removeGarbage, onCompleteParams:[tempDisplayObject]});
				
				//tree.parent.addChildAt(tempDisplayObject,0);
				//starsCollected++;
				//updateStarsDesk();
			} else 
			{
				//emptyTree.play();
				
				//rand = Math.random();
				if (rand > 0.7) 
				{
					
					giveItem(tree);
					
					//item = new items[int(Math.random()*items.length -0.01)];
					//item.y = -100;
					//item.gotoAndStop(1);
					
					//item.scaleX	= item.scaleY = 0.4;
					
					//starSound.play();
					
					//TweenMax.to(item, 1.5, {scaleX:1.2,scaleY:1.2, bezierThrough:[{x:100, y:-185}, {x:125, y:0}], orientToBezier:true, ease:SlowMo.ease.config(0.3, 0.85)});
					
					//tree.parent.addChildAt(item,0);
				}
				
			}
			
			
			
			tree.gotoAndPlay(3);
			emptyTree.play();
			sm.playSound("empty_tree.mp3");
		}
		
		private function showItemMessage(index:int):void 
		{
			itemMessage.gotoAndStop(index);
			_stage.addChild(itemMessage);
			TweenLite.to(itemMessage, 0.5, { y:415, ease:Back.easeOut } );
			TweenLite.to(itemMessage, 0.5, {y:495, ease:Back.easeIn, delay: 4, onComplete:removeItemMessage});
			
		}
		
		private function removeItemMessage():void 
		{
			_stage.removeChild(itemMessage);
			
		}
		
		private function giveItem(tree:TreeBase):void 
		{
			if (currentItemsFound >= 1) 
			{
				return;
			}
			var item:MovieClip;
			var tempIndex:int; //= int(Math.random() * (items.length -0.01));
			starSound.play();
			do
			{
				tempIndex = int(Math.random() * (items.length -0.01));
			} while (Settings.itemsUnlocked[tempIndex])
			
			Settings.itemsUnlocked[tempIndex] = true;
			
			showItemMessage(tempIndex+1);
			
			item = new items[tempIndex];
			item.y = -100;
			item.gotoAndStop(1);
			
			item.scaleX	= item.scaleY = 0.4;
			
			Settings.newUnlocks = true;
			
			//starSound.play();
			
			TweenMax.to(item, 1.5, { scaleX:1.2,scaleY:1.2, bezierThrough:[{x:100, y:-185}, {x:125, y:0}], orientToBezier:true, ease:SlowMo.ease.config(0.3, 0.85)});
			TweenLite.to(item, 0.4, {alpha:0,delay:1.1, ease:Cubic.easeOut, onComplete:removeItem, onCompleteParams:[item]});
			tree.parent.addChildAt(item, 0);
			currentItemsFound++;
		}
		
		private function removeItem(item:MovieClip):void 
		{
			item.parent.removeChild(item);
			
		}
		
		private function addGarbage(tree:TreeBase):void 
		{
			var tempDisplayObject:MovieClip;
			var rand2:Number;
			
			tempDisplayObject = gv.getObject("Garbage") as MovieClip;
			tempDisplayObject.y = -50;
			tempDisplayObject.x = 0;
			
			tempDisplayObject.gotoAndStop(int(Math.random()*(tempDisplayObject.totalFrames -0.01))+1);
			
			rand2 = (50+Math.random()*100)*(Math.round(Math.random())*2-1);
			TweenMax.to(tempDisplayObject, 0.8, {scaleX:1.2,scaleY:1.2, bezierThrough:[{x:rand2*0.7, y:-170}, {x:rand2, y:0}], orientToBezier:true, ease:SlowMo.ease.config(0.3, 0.85), onComplete:removeGarbage, onCompleteParams:[tempDisplayObject]});
			
			tree.parent.addChildAt(tempDisplayObject,0);
		}
		
		private function removeGarbage(item:DisplayObject):void 
		{
			if (item.parent) 
			{
				item.parent.removeChild(item);
				item.alpha = 1;
				(item as PoolableClip).returnToPool();
			}
			
		}
		
		private function getStar():void 
		{
			
		}
		
		private function updateStarsDesk():void 
		{
			var rand:Number;
			var frame:int = 1;
			
			if (starsCollected == 1) 
			{
				rand = Math.random();
				if (rand > 0.7) 
				{
					frame = int(Math.random() * 2.99) + 2;
					frame *= 2;
				}
				
				beastHolder.beast_1.gotoAndStop(frame);
				TweenLite.to(beastHolder.beast_1, 0.5, { scaleX:0.35, scaleY:0.35, ease:Back.easeOut } );
			}
			
			if (starsCollected == 2) 
			{
				rand = Math.random();
				if (rand > 0.7) 
				{
					frame = int(Math.random() * 2.99) + 2;
					frame *= 2;
				}
				
				beastHolder.beast_2.gotoAndStop(frame);
				TweenLite.to(beastHolder.beast_2, 0.5, { scaleX:0.35, scaleY:0.35, ease:Back.easeOut } );
			}
			
			if (starsCollected == 3) 
			{
				rand = Math.random();
				if (rand > 0.7) 
				{
					frame = int(Math.random() * 2.99) + 2;
					frame *= 2;
				}
				
				beastHolder.beast_3.gotoAndStop(frame);
				TweenLite.to(beastHolder.beast_3, 0.5, { scaleX:0.35, scaleY:0.35, ease:Back.easeOut } );
			}
			
		}
		
		private function win():void 
		{
			paused = true;
			
			curtains.setOut();
			curtains.tweenIn();
			sm.playSound("curtains_close.mp3");
			
			levelCompleteMessage.scaleX = 0;
			levelCompleteMessage.scaleY = 0;
			TweenLite.delayedCall(0.65, unloadLevel);
			
			TweenLite.to(levelCompleteMessage, 0.7, { scaleX:1, scaleY:1, ease:Back.easeOut, delay:0.7 } );
			TweenLite.to(underArcStage, 0.7, {y:470, ease:Back.easeOut, delay:0.7} );
			
			currentGameDay++;
			currentItemsFound = 0;
			
			Settings.currentDay = currentGameDay;
			
			levelCompleteMessage.day.update(currentGameDay);
			
			_stage.addChild(curtains);
			_stage.addChild(underArcStage);
			_stage.addChild(levelCompleteMessage);
			
			//_stage.addChild(experienceBar);
			
			if (Settings.levelData.chapter == 1) 
			{
				sm.stopSound("ambient_summer.mp3");
			} else if (Settings.levelData.chapter == 2) 
			{
				sm.stopSound("ambient_autumn.mp3");
			} else {
				sm.stopSound("ambient_winter.mp3");
			}
			
			if (!mainGame && Settings.levelData.chapter == 1) 
			{
				experienceBar.loadNext(3000, 8000, [4000, 5500, 7000], [31, 32, 33, 34, 35]);
				//experienceBar.loadNext(3000, 8000, [4500, 5500, 7000], [33, 34, 35]);
				Settings.unlock(20);
				showUnlockMessage(20);
				
				TweenLite.delayedCall(1, sky.gotoAndStop, [2]);
				
				//experienceBar.init(levelCompleteMessage.expBar, 0, 3000, 0, [500,1000,1600], [30,31,32]);
			} else if (!mainGame && Settings.levelData.chapter == 2) 
			{
				
				experienceBar.loadNext(8000, 12000, [8500, 10000/*, 11000*/], [34, 35, 36]);
				Settings.unlock(21);
				showUnlockMessage(21);
				
				TweenLite.delayedCall(1, sky.gotoAndStop, [3]);
			}
			
			if (currentComboCount) 
			{
				bonusScore += currentComboCount * (currentComboCount - 1) * 10;
				currentComboCount = 0;
			}
			
			if (mainGame) 
			{
				TweenLite.delayedCall(0.7, tweenOutComboMeter);
				
				currentLevelScore = 1000;//animalsCompleted * 100 + starsCollected * 100 - int(framesPassed / fps)*10 + bonusScore;
				
				levelCompleteMessage.score.text = String(currentLevelScore);
				levelCompleteMessage.time.text = clockAnimalDesk.time.text;
				levelCompleteMessage.bonus.text = String(bonusScore);
				
				bonusScore = 0;
				
				levelCompleteMessage.beast_1.scaleX = levelCompleteMessage.beast_1.scaleY = 0;
				levelCompleteMessage.beast_2.scaleX = levelCompleteMessage.beast_2.scaleY = 0;
				levelCompleteMessage.beast_3.scaleX = levelCompleteMessage.beast_3.scaleY = 0;
				
				levelCompleteMessage.beast_1.gotoAndStop(beastHolder.beast_1.currentFrame);
				levelCompleteMessage.beast_2.gotoAndStop(beastHolder.beast_2.currentFrame);
				levelCompleteMessage.beast_3.gotoAndStop(beastHolder.beast_3.currentFrame);
				
				//levelCompleteMessage.star_1.gotoAndStop(1);
				//levelCompleteMessage.star_2.gotoAndStop(1);
				//levelCompleteMessage.star_3.gotoAndStop(1);
				
				if (starsCollected > 0) 
					TweenLite.to(levelCompleteMessage.beast_1, 0.9, { scaleX:0.45, scaleY:0.45, ease:Back.easeOut, delay:1 } );
					//levelCompleteMessage.star_1.gotoAndStop(2);
				if (starsCollected > 1) 
					TweenLite.to(levelCompleteMessage.beast_2, 0.9, { scaleX:0.45, scaleY:0.45, ease:Back.easeOut, delay:1.2 } );
					//levelCompleteMessage.star_2.gotoAndStop(2);
				if (starsCollected > 2) 
					TweenLite.to(levelCompleteMessage.beast_3, 0.9, { scaleX:0.45, scaleY:0.45, ease:Back.easeOut, delay:1.4 } );
					//levelCompleteMessage.star_3.gotoAndStop(2);
				
			} else 
			{
				currentLevelScore = angelsCaught * 50;
				angelsCaught = 0;
				
				levelCompleteMessage.score.text = String(currentLevelScore);
				//mainGame = true;
			}
			
			Settings.totalScore += currentLevelScore;
			
			//experienceBar.add(currentLevelScore);
			
			unlockedSomething = experienceBar.checkUnlock(currentLevelScore);
			TweenLite.to(experienceBar, 2.5, {points:experienceBar.points+currentLevelScore, ease:Quad.easeInOut, onUpdate:updateExpBar, delay:0.8});
			
			sm.playSound("score_fill.mp3");
			sm.playSound("rope_swing.mp3"); //TODO repeat 100 
			
			if (unlockedSomething) 
			{
				hideLvlcompleteButtons();
				Settings.newUnlocks = true;
			}
			
			levelCompleteMessage.next.addEventListener(MouseEvent.CLICK, loadNextlevel); //nextlevel
			levelCompleteMessage.menu.addEventListener(MouseEvent.CLICK, exitToMenu);
			TweenLite.to(levelCompleteMessage, 0.8, { y:300, ease:Back.easeOut } );
			//TweenLite.to(experienceBar, 0.8, {y:80, ease:Back.easeOut, delay:0.8});
			
		}
		
		private function hideLvlcompleteButtons():void 
		{
			levelCompleteMessage.next.visible = false;
			levelCompleteMessage.menu.visible = false;
			
			levelCompleteMessage.next.x = 404;
			levelCompleteMessage.menu.x = -405;
			
		}
		
		private function showLvlcompleteButtons():void 
		{
			levelCompleteMessage.next.visible = true;
			levelCompleteMessage.menu.visible = true;
			
			TweenLite.to(levelCompleteMessage.next, 0.5, {x:254, ease:Back.easeOut } );
			TweenLite.to(levelCompleteMessage.menu, 0.5, {x:-256, ease:Back.easeOut } );
		}
		
		private function updateExpBar():void 
		{
			var temp:int = experienceBar.update();
			
			if (temp >= 30) 
			{
				
				Settings.unlock(temp);
				showUnlockMessage(temp);
			} else if (temp == -10)
			{
				mainGame = false;
				showBonusMessage();
			}
		}
		
		private function showBonusMessage():void 
		{
			//bonusMessage.x = 350;
			//bonusMessage.y = 225;
			
			sm.playSound("item_unlock.mp3");
			
			_stage.addChild(black);
			_stage.addChild(bonusMessage);
			//_stage.addChild(unlockMessage);
			
			bonusMessage.gotoAndStop(Settings.levelData.chapter);
			
			bonusMessage.scaleX = bonusMessage.scaleY = 0;
			//unlockMessage.scaleX = unlockMessage.scaleY = 0;
			//unlockMessage.y = 350;
			
			TweenLite.to(black, 0.5, {alpha:0.5});
			TweenLite.to(bonusMessage,0.7, { scaleX:1, scaleY:1, ease:Back.easeOut } );
			//TweenLite.to(unlockMessage, 0.7, { scaleX:0.3, scaleY:0.3, ease:Back.easeOut } );
			
			bonusMessage.cool.addEventListener(MouseEvent.CLICK, hideBonusMessage);
			
		}
		
		private function hideBonusMessage(e:MouseEvent=null):void 
		{
			if (e) 
			{
				e.stopPropagation();
			}
			
			bonusMessage.cool.removeEventListener(MouseEvent.CLICK, hideBonusMessage);
			//TweenLite.to(unlockMessage, 0.7, { scaleX:0, scaleY:0, ease:Back.easeIn, onComplete:removeBonusMessage} );
			TweenLite.to(bonusMessage, 0.7, { scaleX:0, scaleY:0, ease:Back.easeIn, onComplete:removeBonusMessage} );
			TweenLite.to(black, 0.5, { alpha:0, delay:0.2 } );
			
			showLvlcompleteButtons();
			//loadNextlevel();
		}
		
		private function removeBonusMessage():void 
		{
			//_stage.removeChild(unlockMessage);
			_stage.removeChild(black);
			_stage.removeChild(bonusMessage);
			
		}
		
		private function showUnlockMessage(unlockId:int):void 
		{
			giftBox.x = 350;
			giftBox.y = 225;
			
			_stage.addChild(black);
			_stage.addChild(giftBox);
			//_stage.addChild(unlockMessage);
			_stage.addChild(coolBtn);
			
			giftBox.gotoAndPlay(1);
			coolBtn.scaleX = coolBtn.scaleY = 0;
			coolBtn.y = 350;
			
			TweenLite.to(coolBtn, 0.7, { scaleX:1, scaleY:1, ease:Back.easeOut, delay:0.7 } );
			TweenLite.to(black, 0.5, { alpha:0.5 } );
			
			coolBtn.addEventListener(MouseEvent.CLICK, hideUnlockMessage);
			
		}
		
		private function hideUnlockMessage(e:MouseEvent=null):void 
		{
			coolBtn.removeEventListener(MouseEvent.CLICK, hideUnlockMessage);
			TweenLite.to(coolBtn, 0.7, { scaleX:0, scaleY:0, ease:Back.easeIn, onComplete:removeUnlockMessage} );
			
			TweenLite.to(black, 0.5, { alpha:0, delay:0.2 } );
			TweenLite.to(giftBox, 0.5, { y:500, ease:Back.easeIn } );
			
			
			unlockedSomething = false;
			showLvlcompleteButtons();
		}
		
		private function removeUnlockMessage():void 
		{
			_stage.removeChild(coolBtn);
			_stage.removeChild(black);
			_stage.removeChild(giftBox);
		}
		
		private function hideAll():void 
		{
			unloadLevel();
		}
		
		
		private function nextlevel(e:MouseEvent=null):void 
		{
			//TweenLite.to(experienceBar, 0.8, {y:-50, ease:Back.easeIn});
			TweenLite.to(levelCompleteMessage, 0.8, { y: -200, ease:Back.easeIn } );
			Settings.nextLevel();
		}
		
		
		
		public function loadNextlevel(e:MouseEvent=null):void 
		{
			var level:Level;
			levelCompleteMessage.next.removeEventListener(MouseEvent.CLICK, loadNextlevel); //nextlevel
			levelCompleteMessage.menu.removeEventListener(MouseEvent.CLICK, exitToMenu);
			
			if (e) 
			{
				e.stopPropagation();
			}
			
			
			if (currentLevel == 1) 
			{
				level = new LevelTwo as Level;
			} else if (currentLevel == 2) 
			{
				level = new LevelThree as Level;
			} else if (currentLevel == 3) 
			{
				level = new LevelOne as Level;
			}
			
			//unloadLevel();
			
			framesPassed = 0;
			animalsCompleted = 0;
			totalAnimals = 0;
			starsCollected = 0;
			
			treesClicked = 0;
			baseStarFindingChance = 0.3;
			currentChance = 0.3;
			
			animalExchanges = 0;
			
			
			
			loadLevel(level);
			
			curtains.tweenOut();
			sm.playSound("curtains_open.mp3");
			TweenLite.to(levelCompleteMessage, 0.8, { scaleX:0, scaleY:0, ease:Back.easeIn, onComplete:removeArcAndCurtains} );
			TweenLite.to(underArcStage, 0.7, {y:540, ease:Back.easeIn} );
			//go();
		}
		
		private function removeArcAndCurtains():void 
		{
			if (_stage.getChildIndex(levelCompleteMessage) >= 0) 
			{
				_stage.removeChild(levelCompleteMessage); 
			}
			
			if (_stage.getChildIndex(underArcStage) >= 0) 
			{
				_stage.removeChild(underArcStage);
			}
			
			
			if (_stage.getChildIndex(curtains) >= 0) 
			{
				_stage.removeChild(curtains); 
			}
		}
		
		public function unloadAll(e:MouseEvent=null):void
		{
			/*
			var level:Level;
			
			if (currentLevel == 1) 
			{
				level = new LevelTwo as Level;
			} else if (currentLevel == 2) 
			{
				level = new LevelThree as Level;
			} else if (currentLevel == 3) 
			{
				level = new LevelOne as Level;
			}*/
			
			unloadLevel();
			
			if (black.parent) 
			{
				removePauseMenu();
			} else 
			{
				removeArcAndCurtains();
			}
			
			
			
			
			
		}
		
		private function exitToMenu(e:MouseEvent=null):void 
		{
			levelCompleteMessage.next.removeEventListener(MouseEvent.CLICK, loadNextlevel); //nextlevel
			levelCompleteMessage.menu.removeEventListener(MouseEvent.CLICK, exitToMenu);
			
			//TweenLite.to(experienceBar, 0.8, {y:-50, ease:Back.easeIn});
			TweenLite.to(levelCompleteMessage, 0.8, { y: -200, ease:Back.easeIn } );
			Settings.toMenu();
		}
		
		
		
		
		//=------------------------------------
		//   UN-LOADS LEVEL
		//=------------------------------------
		public function unloadLevel():void 
		{
			
			if (!levelLoaded) 
			{
				return;
			}
			
			if (!mainGame) 
			{
				unloadBonusLevel();
				return;
			}
			
			/*var tempAnimal:VisualAnimal;
			
			for (var i:int = 0; i < totalAnimals; i++) 
			{
				
				tempAnimal = visualAnimals[i];
				
				parallaxController.removeObject(tempAnimal);
				tempAnimal.destroy();
			}*/
			
			framesPassed = 0;
			animalsCompleted = 0;
			totalAnimals = 0;
			starsCollected = 0;
			
			treesClicked = 0;
			baseStarFindingChance = 0.3;
			currentChance = 0.3;
			
			animalExchanges = 0;
			
			beastHolder.x = 350;
			beastHolder.y = 483;
			clockAnimalDesk.x = 7;
			clockAnimalDesk.y = -130;
			menuSoundPanel.y = -28;
			
			while (trees.length) 
			{
				trees.pop();
			}
			
			parallaxController.clear();
			
			while (visualAnimals.length) 
			{
				visualAnimals.pop().clear();
			}
			
			
			visualAnimals = new Vector.<VisualAnimal>;                    //TODO FIX
			
			_stage.removeEventListener(MouseEvent.CLICK, clickObject);
			_stage.removeEventListener(Event.ENTER_FRAME, update);
			
			_stage.stage.removeEventListener(Event.DEACTIVATE, pause);
			menuSoundPanel.menu_btn.removeEventListener(MouseEvent.CLICK, pause);
			menuSoundPanel.sound_btn.removeEventListener(MouseEvent.CLICK, mute);
			
			levelLoaded = false;
		}
		
		private function unloadBonusLevel():void 
		{
			while (caughtAngels.length) 
			{
				caughtAngels.pop();
				//parallaxController.removeObject(caughtAngels.pop());
			}
			
			while (angels.length) 
			{
				angels.pop();
			}
			
			while (marks.length) 
			{
				removeMark(marks.pop() as OutScreenMark);
			}
			
			_stage.removeChild(bubblePanel);
			
			parallaxController.clear();
			
			_stage.removeEventListener(MouseEvent.CLICK, placeBubble);
			_stage.removeEventListener(Event.ENTER_FRAME, updateBonus);
			
			levelLoaded = false;
			mainGame = true;
			
			
		}
		
		/*
		 * BONUS LEVEL
		 * 
		 * */
		
		public function loadBonusLevel():void 
		{
			levelLoaded = true;
			
			var level:Object = Settings.levelData;
			
			//starsDesk.star_1.gotoAndStop(1);
			//starsDesk.star_2.gotoAndStop(1);
			//starsDesk.star_3.gotoAndStop(1);
			
			//gameLogic.loadAnimals(level.availableAnimalTypes, level.animalNumber);
			//gameLogic.shuffle(level.shuffleLevel);
			
			var tempAngel:AngelRunning;
			var tempIndex:int;
			//var gv:GraphicVault = GraphicVault.getInstance();
			var tempDisplayObject:DisplayObject;
			var rand1:Number;
			var rand2:Number;
			var treePositionsX:Vector.<Number> = new Vector.<Number>;
			var treePositionsY:Vector.<Number> = new Vector.<Number>;
			
			var minTreeDistSquare:Number = 10000;
			var canBePlaced:Boolean = true;
			
			///////////////////////
			angels = new Vector.<AngelRunning>();
			caughtAngels = new Vector.<AngelCaught>();
			bubbleTraps = new Array();
			////////////////////// - //TODO Fix
			
			//totalAnimals = level.animalNumber;
			//clockAnimalDesk.count.text = "0/" + totalAnimals;
			
			/*for (var i:int = 0; i < totalAnimals; i++) 
			{
				trace("-------------------------");
				trace("Animal: " + gameLogic.animals[i].type);
				trace("Head: " + gameLogic.animals[i].head);
				trace("Feet: " + gameLogic.animals[i].feet);
				trace("Tail: " + gameLogic.animals[i].tail);
				
				tempAnimal = new VisualAnimal(gameLogic.animals[i]);
				tempAnimal.scaleX = tempAnimal.scaleY = animalScale;
				
				//this._stage.addChild(tempAnimal);
				
				rand1 = Math.random() * 1200;
				rand2 = 20 + Math.random() * 250;
				
				gameLogic.animals[i].x = rand1;
				gameLogic.animals[i].y = rand2;
				
				gameLogic.animals[i].destinationX = Math.random() * 1200;
				gameLogic.animals[i].destinationY = 20 + Math.random() * 250;
				
				parallaxController.addObject(tempAnimal, rand1, rand2);//70 + (i % 5) * 120, 50 + int(i / 5) * 120);
				
				//tempAnimal.x = 70+(i % 5) * 120;
				//tempAnimal.y = 250+int(i / 5) * 120;
				
				tempAnimal.mouseChildren = false;
				
				visualAnimals.push(tempAnimal);
			}*/
			
			for (var j:int = 0; j < level.grassLayersNumber; j++) 
			{
				/*tempIndex = int(Math.random() * (level.grassLayers.length -0.01));
				tempDisplayObject = gv.getObject(level.grassLayers[tempIndex]);
				//tempDisplayObject.
				parallaxController.addObject(tempDisplayObject, 600, (parallaxController.height/level.grassLayersNumber)*j,false);*/
				tempDisplayObject = gv.getObject(level.grassLayers[level.grassLayersNumber - j - 1]);
				tempDisplayObject.cacheAsBitmap = true;
				parallaxController.addObject(tempDisplayObject, 600, (parallaxController.height/level.grassLayersNumber)*j,false);
				
			}
			
			for (var k:int = 0; k < level.debrisNumber; k++) 
			{
				tempIndex = int(Math.random() * (level.debris.length -0.01));
				tempDisplayObject = gv.getObject(level.debris[tempIndex]);
				tempDisplayObject.scaleX = tempDisplayObject.scaleY = 1.2;
				
				if (tempDisplayObject is TreeBase && !(tempDisplayObject is BushBase)) 
				{
					(tempDisplayObject as TreeBase).gotoAndStop(1);
					(tempDisplayObject as TreeBase).frame_1.stop();
					
				}
				
				tempDisplayObject.cacheAsBitmap = true;
				//tempDisplayObject.cacheAsBitmap = true;
				//tempDisplayObject
				do
				{
					canBePlaced = true;
					
					rand1 = Math.random() * 1200;
					rand2 = Math.random() * 300;
					
					for (var l:int = 0; l < treePositionsX.length; l++) 
					{
						if ((treePositionsX[l]-rand1)*(treePositionsX[l]-rand1) + (treePositionsY[l]-rand2)*(treePositionsY[l]-rand2) < minTreeDistSquare) 
						{
							canBePlaced = false;
						}
						
					}
					
				}while (pointInEllipse(rand1,rand2,600,300,650,200) || !canBePlaced)
				
				//rand = Math.random() * 1200 * 300;
				
				treePositionsX.push(rand1);
				treePositionsY.push(rand2);
				
				paused = false;
				
				parallaxController.addObject(tempDisplayObject, rand1, rand2 );//Math.random() * 1200, Math.random() * 300);
			}
			
			//
			// ANGELS -------------------------
			//
			for (var i:int = 0; i < 8; i++) 
			{
				tempAngel = gv.getObject("AngelRunning") as AngelRunning;
				tempAngel.scaleX = 1.2;
				tempAngel.scaleY = 1.2;
				tempAngel.mouseChildren = false;
				tempAngel.mouseEnabled = false;
				angels.push(tempAngel);
				
				
				
				
				rand1 = Math.random() * 1200;
				rand2 = 20 + Math.random() * 250;
				
				tempAngel.dir = Math.round(Math.random()) * 2 - 1;
				
				tempAngel.gotoAndPlay(1);
				tempAngel.gotoAndPlay(int(Math.random() * 31)+1);
				
				//tempAngel.x = rand1;
				//tempAngel.y = rand2;
				
				
				parallaxController.addObject(tempAngel, rand1, rand2,false);//70 + (i % 5) * 120, 50 + int(i / 5) * 120);
				
				//tempAnimal.x = 70+(i % 5) * 120;
				//tempAnimal.y = 250+int(i / 5) * 120;
				
				
				
				//visualAnimals.push(tempAnimal);
			}
			
			/*parallaxTest.addObject(new Grass1(), 600, 50);
			parallaxTest.addObject(new Grass2(), 600, 120);
			parallaxTest.addObject(new Grass3(), 600, 200);*/
			
			bubblesAvailable = 5;
			/*var tempBubble:DisplayObject;
			
			for (var m:int = 0; m < bubblesAvailable; m++) 
			{
				tempBubble = gv.getObject("Bubble");
				tempBubble.scaleX = tempBubble.scaleY = 0.4;
				
				tempBubble.y = 413;
				tempBubble.x = 37 + m * 20;
				tempBubble.alpha = 1;
				
				hudBubbles[m] = tempBubble;
				
				_stage.addChild(tempBubble);
			}*/
			
			
			_stage.addEventListener(MouseEvent.CLICK, placeBubble);
			_stage.addEventListener(Event.ENTER_FRAME, updateBonus);
			
			resetBubblePanel();
			_stage.addChild(bubblePanel);
			TweenLite.to(bubblePanel, 0.7, { y:425 , ease:Back.easeOut } );
			
			updateBonus();
		}
		
		private function resetBubblePanel():void 
		{
			bubblePanel.bubble_1.scaleX = bubblePanel.bubble_1.scaleY = 0.65;
			bubblePanel.bubble_2.scaleX = bubblePanel.bubble_2.scaleY = 0.65;
			bubblePanel.bubble_3.scaleX = bubblePanel.bubble_3.scaleY = 0.65;
			bubblePanel.bubble_4.scaleX = bubblePanel.bubble_4.scaleY = 0.65;
			bubblePanel.bubble_5.scaleX = bubblePanel.bubble_5.scaleY = 0.65;
			
			bubblePanel.bubble_1.alpha = 1;
			bubblePanel.bubble_2.alpha = 1;
			bubblePanel.bubble_3.alpha = 1;
			bubblePanel.bubble_4.alpha = 1;
			bubblePanel.bubble_5.alpha = 1;
		}
		
		private function placeBubble(e:MouseEvent):void 
		{
			if (bubblesAvailable < 1) 
			{
				return;
			}
			
			sm.playSound("bubble_place_pop.mp3");
			
			var bubble:DisplayObject = gv.getObject("BubblePop");
			var tempint:int = bubbleTraps.length;
			
			(bubble as MovieClip).gotoAndPlay(1);
			
			for (var j:int = 0; j <= tempint; j++) 
			{
				if (j == bubbleTraps.length || !bubbleTraps[j]) 
				{
					bubbleTraps[j] = bubble as BubblePop;
				}
				
			}
			
			bubble.x = e.stageX;
			bubble.y = e.stageY;
			
			_stage.addChild(bubble);
			
			detectAngelCollision(bubble);
			
			bubblesAvailable--; //TODO FIX
			
			if (bubblesAvailable == 0) 
			{
				TweenLite.delayedCall(3, win);
				
				TweenLite.killDelayedCallsTo(spawnRunningAngel);
			}
			// TODO FIX
			TweenLite.to(hudBubbles[bubblesAvailable], 0.7, {scaleX:1, scaleY:1, alpha:0/*, onComplete:removeLastHudBubble*/});
		}
		
		private function removeLastHudBubble():void 
		{
			var tempD:DisplayObject = hudBubbles.pop();
			_stage.removeChild(tempD);
			
			(tempD as PoolableClip).returnToPool();
		}
		
		private function detectAngelCollision(bubble:DisplayObject):void 
		{
			var tempAngel:AngelRunning;
			var angelSubstitute:AngelCaught;
			var tempIndex:int;
			
			var score50:DisplayObject;
			var tempPoint:Point;
			
			for (var i:int = 0; i < angels.length; i++) 
			{
				if (angels[i] && bubble.hitTestObject(angels[i])) 
				{
					tempAngel = angels[i];
					angels[i] = null;
					
					angelSubstitute = gv.getObject("AngelCaught") as AngelCaught;
					angelSubstitute.set(tempAngel.headSkin,tempAngel.bodySkin,tempAngel.feetSkin); 
					parallaxController.replaceObject(tempAngel as DisplayObject, angelSubstitute as DisplayObject);
					
					tempIndex = caughtAngels.length;
					angelSubstitute.gotoAndPlay(1);
					
					angelsCaught++;
					totalAngelsCaught++;
					
					sm.playSound("angel_caught.mp3");
					
					//tempPoint = angelSubstitute.localToGlobal(new Point(0,0)); //TODO TRY to replace localToGlobal
					
					showScoreAt("Score_50",angelSubstitute.parent.x + parallaxStage.x, angelSubstitute.parent.y + parallaxStage.y-50);
					
					/*score50 = gv.getObject("Score_50");
					score50.x = tempPoint.x;
					score50.y = tempPoint.y-50;				
					score50.scaleX = score50.scaleY = 0;
					score50.rotation = -90;
					
					_stage.addChild(score50);
					TweenLite.to(score50, 0.5, { scaleX:1, scaleY:1, rotation:0, ease:Back.easeOut } );
					TweenLite.to(score50, 1, {rotation:Math.random()*60-30, ease:Linear.easeNone, delay:0.5} );
					TweenLite.to(score50, 0.5, { scaleX:0, scaleY:0, rotation:180, ease:Back.easeIn, delay:1.5 } );
					TweenLite.delayedCall(2, removeScoreSprite, [score50] );*/
					
					
					for (var j:int = 0; j <= tempIndex; j++) 
					{
						if (j == tempIndex || !caughtAngels[j]) 
						{
							caughtAngels[j] = angelSubstitute;
						}
					}
					
					//angels[i].dir *= -1;
					
				}
				
			}
		}
		
		private function randomizeBeastPosition():void 
		{
			var treeNum:int = trees.length;
			var temp:int;
			
			if (currentBeastTree && currentBeastTree.currentFrame == 2) 
			{
				if (!(currentBeastTree is BushBase)) 
				{
					temp = currentBeastTree.frame_2.currentFrame;
				}
				
				currentBeastTree.gotoAndStop(1);
				currentBeastTree.containsItem = -1;
				
				if (!(currentBeastTree is BushBase)) 
				{
					currentBeastTree.frame_1.gotoAndPlay(temp);
					
				}
				
			}
			
			beastTimeCount = 0;
			
			treeNum = int(Math.random() * (treeNum - 0.001));
			currentBeastTree = trees[treeNum];
			
			if (!(currentBeastTree is BushBase) && currentBeastTree.frame_1) 
			{
				temp = currentBeastTree.frame_1.currentFrame; //TODO FIX
			}
			
			currentBeastTree.gotoAndStop(2);
			currentBeastTree.containsItem = 1;
			
			if (!(currentBeastTree is BushBase)) 
			{
				currentBeastTree.frame_2.gotoAndPlay(temp);
			}
			
		}
		/*
		private function switchTreeFrameTo(tree:TreeBase, frame:int):void 
		{
			if (tree && tree.currentFrame == 2) 
			{
				
				temp = currentBeastTree.frame_2.currentFrame;
				currentBeastTree.gotoAndStop(1);
				currentBeastTree.frame_1.gotoAndPlay(temp);
				
				
				currentBeastTree.containsItem = -1;
				
			}
		}*/
		
		private function showScoreAt(scoreId:String, posX:Number, posY:Number):void 
		{
			var scoreSprite:DisplayObject;
			
			scoreSprite = gv.getObject(scoreId);
			scoreSprite.x = posX;
			scoreSprite.y = posY;				
			scoreSprite.scaleX = scoreSprite.scaleY = 0;
			scoreSprite.rotation = -90;
			
			_stage.addChild(scoreSprite);
			TweenLite.to(scoreSprite, 0.5, { scaleX:1, scaleY:1, rotation:0, ease:Back.easeOut } );
			TweenLite.to(scoreSprite, 1, {rotation:Math.random()*60-30, ease:Linear.easeNone, delay:0.5} );
			TweenLite.to(scoreSprite, 0.5, { scaleX:0, scaleY:0, rotation:180, ease:Back.easeIn, delay:1.5 } );
			TweenLite.delayedCall(2, removeScoreSprite, [scoreSprite] );
		}
		
		private function removeScoreSprite(score:DisplayObject):void 
		{
			_stage.removeChild(score); 
			(score as PoolableClip).returnToPool();
			
		}
		
		private function spawnRunningAngel():void 
		{
			var rand1:Number;
			var rand2:Number;
			var tempAngel:AngelRunning;
			
			if (bubblesAvailable < 1) 
			{
				return; // TODO FIX if pause enabled in bonus levels.
			}
			
			tempAngel = gv.getObject("AngelRunning") as AngelRunning;
			tempAngel.scaleX = 1.2;
			tempAngel.scaleY = 1.2;
			tempAngel.mouseChildren = false;
			tempAngel.mouseEnabled = false;
			angels.push(tempAngel);
			
			
			
			
			rand1 = Math.round(Math.random()) * 1250 - 50;
			rand2 = 20 + Math.random() * 250;
			
			(rand1 == -50) ? tempAngel.dir = 1 : tempAngel.dir = -1;
			//tempAngel.dir = Math.round(Math.random()) * 2 - 1;
			
			tempAngel.gotoAndPlay(1);
			tempAngel.gotoAndPlay(int(Math.random() * 31)+1);
			
			//tempAngel.x = rand1;
			//tempAngel.y = rand2;
			
			
			parallaxController.addObject(tempAngel, rand1, rand2,false);//70 + (i % 5) * 120, 50 + int(i / 5) * 120);
		}
		
		
		
		private function updateBonus(e:Event=null):void 
		{
			if (paused) 
			{
				return;
			}
			/*framesPassed++;
			var seconds:int = framesPassed / fps;
			
			
			clockAnimalDesk.time.text = int(seconds/60)+":"+seconds%60;
			
			*/
			
			updateRunningAngels();
			updateCaughtAngels();
			
			parallaxController.update(cameraFocusX/*+_stage.mouseX * 0.1*/);
			parallaxStage.x = -(cameraFocusX/*+_stage.mouseX * 0.1*/)*0.42; //_stage.mouseX * 0.6;
			
			if (_stage.mouseX > 600 && cameraFocusX < 1200) 
			{
				cameraFocusX += 30*(100-(700-_stage.mouseX))/60;
			} else if (_stage.mouseX < 100 && cameraFocusX > 0) 
			{
				cameraFocusX -= 30*(100-_stage.mouseX)/60;
			}
			
			//gameLogic.update();
			//updateVisualAnimals();
			
			checkAllbubbles();
			updateMarks();
			
			Settings.update();
		}
		
		private function updateMarks():void 
		{
			var posX:Number;
			var posY:Number;
			var newMark:DisplayObject;
			
			
			for (var i:int = 0; i < angels.length; i++) 
			{
				if (!angels[i] && i < marks.length) 
				{
					if (marks[i]) 
					{
						_stage.removeChild(marks[i]);
						(marks[i] as PoolableClip).returnToPool();
						marks[i] = null;
					}
					continue;
				}
				posX = angels[i].parent.x + parallaxStage.x;
				posY = angels[i].parent.y + parallaxStage.y;
				
				if (i==marks.length) 
				{
					marks[i] = null;
				}
				
				if (posX < 0) 
				{
					if (!marks[i]) 
					{
						marks[i] = newMark = gv.getObject("OutScreenMark");
						newMark.y = posY-50;
						newMark.x = -50;
						newMark.scaleX = 1;
						_stage.addChild(newMark);
						
						TweenLite.to(newMark, 0.5, {x:5, ease:Back.easeOut } );
					}
					
				} else if (posX > 700)
				{
					if (!marks[i]) 
					{
						marks[i] = newMark = gv.getObject("OutScreenMark");
						newMark.y = posY-50;
						newMark.x = 750;
						newMark.scaleX = -1;
						_stage.addChild(newMark);
						
						TweenLite.to(newMark, 0.5, {x:695, ease:Back.easeOut } );
					}
				} else 
				{
					if (marks[i]) 
					{
						TweenLite.to(marks[i], 0.5, {x:(-400*marks[i].scaleX+350), ease:Back.easeIn, onComplete:removeMark, onCompleteParams:[marks[i] as OutScreenMark] } );
						//_stage.addChild(newMark);
						marks[i] = null;
						
					}
					
					
					
				}
				
			}
			
			
			
			
			
			
		}
		
		private function updateMarksMain():void 
		{
			var posX:Number;
			var posY:Number;
			var newMark:DisplayObject;
			
			
			for (var i:int = 0; i < visualAnimals.length; i++) 
			{
				if (!visualAnimals[i]) 
				{
					if (marks[i]) 
					{
						_stage.removeChild(marks[i]);
						(marks[i] as PoolableClip).returnToPool();
						marks[i] = null;
					}
					continue;
				}
				posX = visualAnimals[i].parent.x + parallaxStage.x;
				posY = visualAnimals[i].parent.y + parallaxStage.y;
				
				if (i==marks.length) 
				{
					marks[i] = null;
				}
				
				if (posX < 0 && visualAnimals[i].mouseEnabled) 
				{
					if (!marks[i]) 
					{
						marks[i] = newMark = gv.getObject("OutScreenMark");
						newMark.y = posY-50;
						newMark.x = -50;
						newMark.scaleX = 1;
						_stage.addChild(newMark);
						
						TweenLite.to(newMark, 0.5, {x:5, ease:Back.easeOut } );
					} else 
					{
						marks[i].y = posY-50;
					}
					
				} else if (posX > 700 && visualAnimals[i].mouseEnabled)
				{
					if (!marks[i]) 
					{
						marks[i] = newMark = gv.getObject("OutScreenMark");
						newMark.y = posY-50;
						newMark.x = 750;
						newMark.scaleX = -1;
						_stage.addChild(newMark);
						
						TweenLite.to(newMark, 0.5, {x:695, ease:Back.easeOut } );
					} else 
					{
						marks[i].y = posY-50;
					}
				} else 
				{
					if (marks[i]) 
					{
						TweenLite.to(marks[i], 0.5, {x:(-400*marks[i].scaleX+350), ease:Back.easeIn, onComplete:removeMark, onCompleteParams:[marks[i] as OutScreenMark] } );
						//_stage.addChild(newMark);
						marks[i] = null;
						
					}
				}
			}
		}
		
		private function removeMark(mark:OutScreenMark):void 
		{
			if (mark) 
			{
				_stage.removeChild(mark);
				mark.returnToPool();
			}
			
			
		}
		
		private function updateCaughtAngels():void 
		{
			var parObj:ParallaxObject;
			
			for (var i:int = 0; i < caughtAngels.length; i++) 
			{
				parObj = caughtAngels[i].parent as ParallaxObject;
				parObj.parallaxZ += 2;
				
				
				parObj.dx *= 0.95;
				
				
				if (parObj.parallaxZ > 200) 
				{
					parallaxController.removeObject(caughtAngels[i] as DisplayObject);
					//caughtAngels[i].returnToPool();
					caughtAngels.splice(i, 1);
					i--;
					
					TweenLite.delayedCall(Math.random()*3,spawnRunningAngel);
					//caughtAngels[i] = null;
					
					
					
				}
			}
		}
		
		private function checkAllbubbles():void 
		{
			for (var i:int = 0; i < bubbleTraps.length; i++) 
			{
				if ((bubbleTraps[i] as MovieClip).currentFrame < 28)
				{
					detectAngelCollision(bubbleTraps[i]);
				} else {
					_stage.removeChild(bubbleTraps[i]);
					bubbleTraps[i].returnToPool();
					bubbleTraps[i].gotoAndStop(1);
					bubbleTraps.splice(i,1);
				}
				
			}
		}
		
		private function updateRunningAngels():void 
		{
			var tempParallax:ParallaxObject
			
			for (var i:int = 0; i < angels.length; i++) 
			{
				if (angels[i] == null) 
				{
					continue;
				}
				tempParallax = (angels[i].parent as ParallaxObject);
				//tempParallax.parallaxX += 8 * angels[i].dir;
				
				tempParallax.dx = 8 * angels[i].dir;
				
				if (tempParallax.parallaxX < -50) 
				{
					angels[i].dir = 1;
					angels[i].randomize();
					angels[i].gotoAndPlay(1);
				} else if (tempParallax.parallaxX > 1250)
				{
					angels[i].dir = -1;
					angels[i].randomize();
					angels[i].gotoAndPlay(1);
				}
				
				angels[i].scaleX = angels[i].dir*1.2;
			}
		}
		
		private function initGraphics():void 
		{
			//var gv:GraphicVault = GraphicVault.getInstance();
			
			gv.setupAPoolFor(BullBody, "BullBody", false, 10);
			gv.setupAPoolFor(BullFeetBack, "BullFeetBack", false, 10);
			gv.setupAPoolFor(BullFeetFront, "BullFeetFront", false, 10);
			gv.setupAPoolFor(BullHead, "BullHead", false, 10);
			gv.setupAPoolFor(BullTail, "BullTail", false, 10);
			
			gv.setupAPoolFor(GiraffeBody, "GiraffeBody", false, 10);
			gv.setupAPoolFor(GiraffeFeetBack, "GiraffeFeetBack", false, 10);
			gv.setupAPoolFor(GiraffeFeetFront, "GiraffeFeetFront", false, 10);
			gv.setupAPoolFor(GiraffeHead, "GiraffeHead", false, 10);
			gv.setupAPoolFor(GiraffeTail, "GiraffeTail", false, 10);
			
			gv.setupAPoolFor(ElephantBody, "ElephantBody", false, 10);
			gv.setupAPoolFor(ElephantFeetBack, "ElephantFeetBack", false, 10);
			gv.setupAPoolFor(ElephantFeetFront, "ElephantFeetFront", false, 10);
			gv.setupAPoolFor(ElephantHead, "ElephantHead", false, 10);
			gv.setupAPoolFor(ElephantTail, "ElephantTail", false, 10);
			
			gv.setupAPoolFor(CrocBody, "CrocBody", false, 10);
			gv.setupAPoolFor(CrocFeetBack, "CrocFeetBack", false, 10);
			gv.setupAPoolFor(CrocFeetFront, "CrocFeetFront", false, 10);
			gv.setupAPoolFor(CrocHead, "CrocHead", false, 10);
			gv.setupAPoolFor(CrocTail, "CrocTail", false, 10);
			
			gv.setupAPoolFor(FoxBody, "FoxBody", false, 10);
			gv.setupAPoolFor(FoxFeetBack, "FoxFeetBack", false, 10);
			gv.setupAPoolFor(FoxFeetFront, "FoxFeetFront", false, 10);
			gv.setupAPoolFor(FoxHead, "FoxHead", false, 10);
			gv.setupAPoolFor(FoxTail, "FoxTail", false, 10);
			
			gv.setupAPoolFor(OstrichBody, "OstrichBody", false, 10);
			gv.setupAPoolFor(OstrichFeetBack, "OstrichFeetBack", false, 10);
			gv.setupAPoolFor(OstrichFeetFront, "OstrichFeetFront", false, 10);
			gv.setupAPoolFor(OstrichHead, "OstrichHead", false, 10);
			gv.setupAPoolFor(OstrichTail, "OstrichTail", false, 10);
			
			gv.setupAPoolFor(RamBody, "RamBody", false, 10);
			gv.setupAPoolFor(RamFeetBack, "RamFeetBack", false, 10);
			gv.setupAPoolFor(RamFeetFront, "RamFeetFront", false, 10);
			gv.setupAPoolFor(RamHead, "RamHead", false, 10);
			gv.setupAPoolFor(RamTail, "RamTail", false, 10);
			
			gv.setupAPoolFor(ArmadilloBody, "ArmadilloBody", false, 10);
			gv.setupAPoolFor(ArmadilloFeetBack, "ArmadilloFeetBack", false, 10);
			gv.setupAPoolFor(ArmadilloFeetFront, "ArmadilloFeetFront", false, 10);
			gv.setupAPoolFor(ArmadilloHead, "ArmadilloHead", false, 10);
			gv.setupAPoolFor(ArmadilloTail, "ArmadilloTail", false, 10);
			
			gv.setupAPoolFor(DeerBody, "DeerBody", false, 10);
			gv.setupAPoolFor(DeerFeetBack, "DeerFeetBack", false, 10);
			gv.setupAPoolFor(DeerFeetFront, "DeerFeetFront", false, 10);
			gv.setupAPoolFor(DeerHead, "DeerHead", false, 10);
			gv.setupAPoolFor(DeerTail, "DeerTail", false, 10);
			
			gv.setupAPoolFor(Shadow, "Shadow", false, 10);
			
			gv.setupAPoolFor(Arrow, "Arrow", false, 3);
			
			gv.setupAPoolFor(Tree_1, "Tree_1", false, 3);
			gv.setupAPoolFor(Tree_2, "Tree_2", false, 3);
			gv.setupAPoolFor(Tree_3, "Tree_3", false, 3);
			
			gv.setupAPoolFor(Tree_1_red, "Tree_1_red", false, 3);
			gv.setupAPoolFor(Tree_2_red, "Tree_2_red", false, 3);
			gv.setupAPoolFor(Tree_3_red, "Tree_3_red", false, 3);
			
			gv.setupAPoolFor(Tree_1_snow, "Tree_1_snow", false, 3);
			gv.setupAPoolFor(Tree_2_snow, "Tree_2_snow", false, 3);
			gv.setupAPoolFor(Tree_3_snow, "Tree_3_snow", false, 3);
			
			gv.setupAPoolFor(Bush_red, "Bush_red", false, 3);
			gv.setupAPoolFor(Bush_snow, "Bush_snow", false, 3);
			gv.setupAPoolFor(Bush, "Bush", false, 3);
			
			gv.setupAPoolFor(Grass1, "Grass1", false, 5);
			gv.setupAPoolFor(Grass2, "Grass2", false, 5);
			gv.setupAPoolFor(Grass3, "Grass3", false, 5);
			gv.setupAPoolFor(Grass4, "Grass4", false, 5);
			
			gv.setupAPoolFor(Grass1_red, "Grass1_red", false, 5);
			gv.setupAPoolFor(Grass2_red, "Grass2_red", false, 5);
			gv.setupAPoolFor(Grass3_red, "Grass3_red", false, 5);
			gv.setupAPoolFor(Grass4_red, "Grass4_red", false, 5);
			
			gv.setupAPoolFor(Grass1_snow, "Grass1_snow", false, 5);
			gv.setupAPoolFor(Grass2_snow, "Grass2_snow", false, 5);
			gv.setupAPoolFor(Grass3_snow, "Grass3_snow", false, 5);
			gv.setupAPoolFor(Grass4_snow, "Grass4_snow", false, 5);
			
			gv.setupAPoolFor(UnlockIndicator, "UnlockIndicator", false, 5);
			
			gv.setupAPoolFor(AngelRunning, "AngelRunning", false, 5);
			gv.setupAPoolFor(AngelCaught, "AngelCaught", false, 5);
			
			gv.setupAPoolFor(BubblePop, "BubblePop", false, 5);
			
			gv.setupAPoolFor(Score_50, "Score_50", false, 5);
			gv.setupAPoolFor(Score_10, "Score_10", false, 5);
			gv.setupAPoolFor(Score_20, "Score_20", false, 5);
			gv.setupAPoolFor(Score_30, "Score_30", false, 5);
			gv.setupAPoolFor(Score_40, "Score_40", false, 5);
			gv.setupAPoolFor(Score_60, "Score_60", false, 5);
			gv.setupAPoolFor(Score_100, "Score_100", false, 5);
			gv.setupAPoolFor(Score_Combo, "Score_Combo", false, 5);
			gv.setupAPoolFor(Score_X2, "Score_X2", false, 5);
			gv.setupAPoolFor(Score_X3, "Score_X3", false, 5);
			gv.setupAPoolFor(Score_X4, "Score_X4", false, 5);
			gv.setupAPoolFor(Score_X5, "Score_X5", false, 5);
			
			gv.setupAPoolFor(Garbage, "Garbage", false, 5);
			
			gv.setupAPoolFor(OutScreenMark, "OutScreenMark", false, 5);
			
			gv.setupAPoolFor(Bubble, "Bubble", false, 5);
			
			//gv.setupAPoolFor(Grass, "Grass", false, 5);
			
			
		}
		
		/*function snapClip( clip:DisplayObject ):BitmapData
		{
			var bounds:Rectangle = clip.getBounds( clip );
			var bitmap:BitmapData = new BitmapData( int( bounds.width + 0.5 ), int( bounds.height + 0.5 ), true, 0 );
			bitmap.draw( clip, new Matrix(1,0,0,1,-bounds.x,-bounds.y) );
			return bitmap;
		}*/
		
		
		private function update(e:Event=null):void 
		{
			if (paused) 
			{
				return;
			}
			
			framesPassed++;
			
			updateTime();
			updateParallax();			
			gameLogic.update();
			updateVisualAnimals();
			updateMarksMain();
			updateBeast();
			updateAchievements();
			
			if (combo && timer.currentFrame >= 250) 
			{
				tweenOutComboMeter();
			}
			
			Settings.update();
			
			if (animalsCompleted >= totalAnimals && !waitForAchievement) 
			{
				win();
			}
		}
		
		private function updateAchievements():void 
		{
			var arr:Array = Settings.achievements;
			
			if (totalAnimalsCompleted > totalAnimalsAchievement && arr[2] == 0) 
			{
				arr[2] = 1;
				dropAchievement(2);
			}
			
			if (totalBeastsCaught > totalBeastsAchievement && arr[1] == 0) 
			{
				arr[1] = 1;
				dropAchievement(1);
			}
			
			if (totalAngelsCaught> totalAngelsAchievement && arr[4] == 0) 
			{
				arr[4] = 1;
				dropAchievement(4);
			}
		}
		
		private function dropAchievement(id:int):void 
		{
			var sprite:MovieClip = new achievementProjectileClasses[id];
			var randX:Number =  cameraFocusX / 1200 * 500 + 350;//600 + Math.random() * 100 - 50;
			(sprite.getChildByName("achievement_" + (id + 1)) as MovieClip).gotoAndStop(1);
			sprite.name = String(id);
			parallaxController.addObject(sprite, randX, 200 + Math.random()*40 - 20);
			sprite.scaleX = 2;
			sprite.scaleY = 2;
			sprite.y = -500;
			sprite.x = Math.random() * 600 - 300;
			sprite.rotation = Math.random() * 360 - 180;
			TweenLite.to(sprite, 0.7, {x:0, y:0, rotation:(sprite.rotation+Math.random() * 40 - 20), ease:Cubic.easeIn, onComplete:achievementDropped, onCompleteParams:[sprite]});
			
		}
		
		private function achievementDropped(mc:MovieClip):void 
		{
			mc.rotation = 0;
			shaker.startShake(2);
			mc.mouseChildren = false;
			mc.addEventListener(MouseEvent.CLICK, pickUpAchievement)
		}
		
		private function pickUpAchievement(e:MouseEvent):void 
		{
			var mc:DisplayObject = e.target as DisplayObject;
			
			achFlash.y = -30;
			achFlash.scaleX = achFlash.scaleY = 2;
			achFlash.gotoAndPlay(1);
			mc.parent.addChild(achFlash);
			TweenLite.to(mc, 0.3, {y:-30, scaleX:0, scaleY:0, onComplete:removeAchievement, onCompleteParams:[mc] });
			
			
			showItemMessage(int(e.target.name) + 11);
			trace("ACHIEVEMENT: " + e.target.name);
		}
		
		private function removeAchievement(mc:DisplayObject):void 
		{
			parallaxController.removeObject(mc);
		}
		
		private function updateTime():void 
		{
			var seconds:int = framesPassed / fps;
			var tempStr:String = "" + int(seconds / 60);
			
			if (seconds%60 >= 10) 
			{
				tempStr += ":" + seconds % 60;
			} else 
			{
				tempStr += ":0" + seconds % 60;
			}
			
			clockAnimalDesk.time.text = tempStr;
		}
		
		private function updateBeast():void 
		{
			if (beastEnabled && starsCollected < 3) 
			{
				beastTimeCount++;
				
				if (beastTimeCount >= beastTimeOut*fps) 
				{
					//currentBeastTree.gotoAndStop(1);
					//currentBeastTree.containsItem = -1;
					
					randomizeBeastPosition();
				}
			}
			
		}
		
		private function updateParallax():void 
		{
			if (_stage.mouseX > 600 && cameraFocusX < 1200) 
			{
				cameraFocusX += 30*(100-(700-_stage.mouseX))/60;
			} else if (_stage.mouseX < 100 && cameraFocusX > 0) 
			{
				cameraFocusX -= 30*(100-_stage.mouseX)/60;
			}
			
			parallaxController.update(cameraFocusX/*+_stage.mouseX * 0.1*/);
			parallaxStage.x = -(cameraFocusX/*+_stage.mouseX * 0.1*/)*0.42; //_stage.mouseX * 0.6;
			//trace("cameraFocusX: " + cameraFocusX);
		}
		
		
		private function tweenOutComboMeter():void 
		{
			bonusScore += currentComboCount * (currentComboCount - 1) * 10;
			timer.stop();
			
			currentComboCount = 0;
			combo = false;
			
			TweenLite.to(timer, 0.5, { x:780, ease:Back.easeIn, delay:0.2 } );
			TweenLite.to(timer.combo, 0.5, {scaleX:0.5,scaleY:0.5, x: -22, y: -41, rotation: -90, ease:Back.easeIn, delay:0.2 } );
			TweenLite.to(timer.points, 0.5, {scaleX:0.3,scaleY:0.3, x: -37, y: -2, rotation: -90, ease:Back.easeIn, delay:0.1 } );
			TweenLite.to(timer.multiplier, 0.5, {scaleX:0.3,scaleY:0.3, x: -9, y: 11, rotation: -90, ease:Back.easeIn } );
		}
		
		private function updateVisualAnimals():void 
		{
			for (var i:int = 0; i < visualAnimals.length; i++) 
			{
				(visualAnimals[i].parent as ParallaxObject).setPosition(visualAnimals[i].model.x, visualAnimals[i].model.y);
				if (visualAnimals[i].model.dx > 0) 
				{
					visualAnimals[i].run();
					visualAnimals[i].scaleX = animalScale;
				} else if (visualAnimals[i].model.dx < 0) 
				{
					visualAnimals[i].run();
					visualAnimals[i].scaleX = -animalScale;
				} else 
				{
					visualAnimals[i].stop();
				}
			}
		}
		
		public function  destroy():void 
		{
			_stage.removeEventListener(Event.ENTER_FRAME, update);
			_stage = null;
			
		}
		
	}

}