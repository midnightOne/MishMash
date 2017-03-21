package 
{
	import com.greensock.easing.Back;
	import com.greensock.plugins.BezierPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.sociodox.theminer.TheMiner;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import Graphics.DigitDisplay;
	import Levels.LevelOne;
	import Levels.LevelThree;
	import Levels.LevelTwo;
	import Menu.CascadeView;
	import Sound.SoundManager;

	/**
	 * ...
	 * @author Kirill Prymachov aka Midnight
	 */
	[Frame(factoryClass = "Preloader")]
	[SWF(width="700", height="450", frameRate="30", backgroundColor="#FFFFFF")]
	//#376C10
	
	public class Main extends Sprite 
	{
		private var gc:GameController;
		private var mainMenu:MainMenu;
		private var bg:BackGround;
		private var clouds:Clouds;
		private var secondMenu:Sprite; //SecondMenu;
		
		private var cascadeView:CascadeView;
		
		private var menuOpenSound:MenuOpenSound = new MenuOpenSound;
		private var table:MenuTable;
		
		private var playButton:PlayButton;
		private var rightButton:RightScrollingButton;
		private var leftButton:LeftScrollingButton;
		
		private var picture:Picture;
		private var cabinet:Cabinet;
		
		
		private var currentMenuState:String = "map";
		
		//private var cloudSound:CloudSound;
		
		private var gameLayer:Sprite;
		
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void 
		{
			TweenPlugin.activate([BezierPlugin]);
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			//stage.addChild(new TheMiner());
			
			//this.stage.addEventListener(MouseEvent.CLICK, start);
			bg = new BackGround();
			this.addChild(bg);
			bg.x = 350;
			bg.y = 225;
			
			
			mainMenu = new MainMenu();
			mainMenu.x = 350;
			mainMenu.y = 225;
			this.addChild(mainMenu);
			
			/*secondMenu = new SecondMenu();
			secondMenu.x = 350;
			secondMenu.y = 225;
			this.addChild(secondMenu);*/
			secondMenu = new Sprite;
			this.addChild(secondMenu);
			secondMenu.visible = false;
			
			mainMenu.start.addEventListener(MouseEvent.CLICK, gotoSsecondMenu);
			
			gameLayer = new Sprite();
			this.addChild(gameLayer);
			
			clouds = new Clouds();
			clouds.x = 350;
			clouds.y = 225;
			clouds.stop();
			
			cascadeView = new CascadeView(700, 450);
			table = new MenuTable();
			table.x = 350;
			table.y = 260;
			cascadeView.loadClip(table as Sprite, 1);
			
			(table.submenu.day as DigitDisplay).init(1);
			(table.submenu.score as DigitDisplay).init(1);
			
			(table.submenu.day as DigitDisplay).downscaleLarger = 1;
			
			(table.submenu.day as DigitDisplay).update(1);
			(table.submenu.score as DigitDisplay).update(0);
			
			//this.addChild(table);
			cascadeView.setPosOut();
			//cascadeView.tweenIn();
			
			playButton = new PlayButton();
			playButton.x = 350;
			playButton.y = 379;
			
			picture = new Picture();
			picture.x = 740;
			picture.y = 110;		
			picture.scaleX = 0.43;
			picture.scaleY = 0.43;
			
			cabinet = new Cabinet();
			cabinet.x = 0;
			cabinet.y = 116;
			cabinet.scaleX = 0.5;
			cabinet.scaleY = 0.5;
			
			rightButton = new RightScrollingButton();
			rightButton.x = 350;
			rightButton.y = 389;
			rightButton.setPos(2);
			
			leftButton = new LeftScrollingButton();
			leftButton.x = 350;
			leftButton.y = 389;
			
			//this.addChild(rightButton);
			
			
			//var req:URLRequest = new URLRequest("music/sp_main_music.mp3"); 
			//var s:Sound = new Sound(req);
			//s.play(0, 100);
			var music:MainMusic = new MainMusic();
			music.play(0,500);
			
			loadSounds();
			
			
			
			
			
			
			
			
			Settings.toMenu = toMenuCallback;
			Settings.nextLevel = nextLevelCallback;
			
			
			//cloudSound = new CloudSound();
			
			
		}
		
		private function loadSounds():void 
		{
			var sm:SoundManager = new SoundManager(700, false, "sound");//SoundManager.getInstance();
			sm.addSound("main_music.mp3");
			sm.addSound("achievement_airstrike.mp3");
			sm.addSound("achievement_collect.mp3");
			sm.addSound("ambient_autumn.mp3");
			sm.addSound("ambient_summer.mp3");
			sm.addSound("angel_caught.mp3");
			sm.addSound("animal_run_1.mp3");
			sm.addSound("animal_run_2.mp3");
			sm.addSound("animal_run_3.mp3");
			sm.addSound("beast_caught.mp3");
			sm.addSound("bubble_place_pop.mp3");
			sm.addSound("button_click_1.mp3");
			sm.addSound("button_click_2.mp3");
			sm.addSound("button_click_3.mp3");
			sm.addSound("button_hover_1.mp3");
			sm.addSound("button_hover_2.mp3");
			sm.addSound("button_hover_3.mp3");
			sm.addSound("curtains_open.mp3");
			sm.addSound("curtains_close.mp3");
			sm.addSound("empty_tree.mp3");
			sm.addSound("item_unlock.mp3");
			sm.addSound("menu_animation_1.mp3");			
			sm.addSound("menu_animation_2.mp3");
			sm.addSound("menu_animation_3.mp3");
			sm.addSound("menu_open.mp3");
			sm.addSound("panel_open.mp3");
			sm.addSound("rope_swing.mp3");
			sm.addSound("score_fill.mp3");
			sm.addSound("transformation.mp3");
			sm.addSound("transformation_wrong.mp3");
			sm.addSound("tree_bonus.mp3");
			sm.addSound("tutorial_hide.mp3");
			sm.addSound("tutorial_show.mp3");
			sm.addSound("menu_scrolling_button_click.mp3");
			
			//sm.addSound(".mp3");
			sm.addSoundGroup("menu_animation", ["menu_animation_1.mp3", "menu_animation_2.mp3", "menu_animation_3.mp3"]);
			sm.addSoundGroup("button_click", ["button_click_1.mp3", "button_click_2.mp3", "button_click_3.mp3"]);
			sm.addSoundGroup("button_hover", ["button_hover_1.mp3", "button_hover_2.mp3", "button_hover_3.mp3"]);
			sm.addSoundGroup("animal_run", ["animal_run_1.mp3", "animal_run_2.mp3", "animal_run_3.mp3"]);
			
			//sm.volume = 0;
			sm.playSound("main_music.mp3");
			
			//TweenLite.to(sm, 5, {volume:1 } );
			
			//sm.playSound("main_music.mp3", 1, 50, 700);
			//sm.addMultipleSounds(["button1.mp3", "button2.mp3", "button3.mp3"]);
			
		}
		
		private function showButtons():void 
		{
			
		}
		
		private function hideButtons():void 
		{
			
		}
		
		private function gotoSsecondMenu(e:MouseEvent):void 
		{
			//SoundManager.stopSnd("main_music.mp3");
			SoundManager.playGroup("button_click");
			SoundManager.play("menu_open.mp3");
			menuOpenSound.play();
			
			mainMenu.start.removeEventListener(MouseEvent.CLICK, gotoSsecondMenu);
			TweenLite.to(mainMenu,0.8, {scaleX:0,scaleY:0, ease:Back.easeIn, onComplete:loadSecondMenu});
		}
		
		private function loadSecondMenu():void 
		{
			//secondMenu.scaleX = 0;
			//secondMenu.scaleY = 0;
			secondMenu.visible = true;
			
			//TweenLite.to(secondMenu, 0.8, { scaleX:1, scaleY:1, ease:Back.easeOut, onComplete:initSecondMenu } );
			
			checkAvailableTableElements();
			
			cascadeView.tweenIn();
			
			
			cabinet.visible = false;
			secondMenu.addChild(cabinet);
			
			TweenLite.from(cabinet, 0.5, {x:-100} );
			cabinet.visible = true;
			
			
			
			picture.visible = false;
			secondMenu.addChild(picture);
			
			TweenLite.from(picture, 0.5, {x:800} );
			picture.visible = true;
			
			
			secondMenu.addChild(table);
			
			rightButton.scaleX = rightButton.scaleY = 0;
			leftButton.scaleX = leftButton.scaleY = 0;
			
			secondMenu.addChild(rightButton);
			secondMenu.addChild(leftButton);
			TweenLite.to(rightButton, 0.5, { scaleX:1, scaleY:1, x:407, ease:Back.easeOut } );
			TweenLite.to(leftButton, 0.5, { scaleX:1, scaleY:1, x: 299, ease:Back.easeOut } );
			
			TweenLite.to(rightButton, 0.5, {x:503, ease:Back.easeOut, delay:0.5, onComplete:rightButton.mouseOut} );
			TweenLite.to(leftButton, 0.5, {x:203, ease:Back.easeOut, delay:0.5, onComplete:leftButton.mouseOut} );
			
			rightButton.mouseOver();
			leftButton.mouseOver();
			
			playButton.visible = false;
			secondMenu.addChild(playButton);
			TweenLite.from(playButton, 0.5, { scaleX:0, scaleY:0, ease:Back.easeOut } );
			playButton.visible = true;
			
			rightButton.mouseChildren = false;
			leftButton.mouseChildren = false;
			
			rightButton.addEventListener(MouseEvent.CLICK, right);
			leftButton.addEventListener(MouseEvent.CLICK, left);
			
			playButton.addEventListener(MouseEvent.CLICK, hideSecondMenu); //start
			
		}
		
		private function checkItems():void 
		{
			var arr:Array = Settings.achievements;
			
			for (var i:int = 0; i < Settings.items.length; i++) 
			{
				if (Settings.itemsUnlocked[i]) 
				{
					(cabinet.getChildByName(Settings.items[i]) as MovieClip).gotoAndStop(1);
				} else 
				{
					(cabinet.getChildByName(Settings.items[i]) as MovieClip).gotoAndStop(2);
				}
				
			}
			
			for (var j:int = 0; j < 5; j++) 
			{
				if (arr[j] == 1) 
				{
					(cabinet.getChildByName("achievement_"+(j+1)) as MovieClip).gotoAndStop(1);
				} else 
				{
					(cabinet.getChildByName("achievement_"+(j+1)) as MovieClip).gotoAndStop(2);
				}
			}
		}
		
		private function updateDayAndScore():void 
		{
			(table.submenu.day as DigitDisplay).update(Settings.currentDay);
			(table.submenu.score as DigitDisplay).update(Settings.totalScore);
		}
		
		private function checkAvailableTableElements():void 
		{
			var tempInt:int = table.numChildren;
			var tempDO:DisplayObject;
			var temp2:int;
			
			if (!Settings.levelData) 
			{
				return;
			}
			
			table.ground.gotoAndStop(Settings.levelData.chapter);
			table.tree_1.gotoAndStop(Settings.levelData.chapter);
			table.tree_2.gotoAndStop(Settings.levelData.chapter);
			
			for (var i:int = 0; i < tempInt; i++) 
			{
				tempDO = table.getChildAt(i);
				temp2 = Settings.animalTypes.indexOf(tempDO.name);
				
				if (temp2 > 0 && temp2 <= Settings.levelData.animalNumber) 
				{
					tempDO.visible = true;
				} else if (temp2 > 0 && temp2 > Settings.levelData.animalNumber) 
				{
					tempDO.visible = false;
				}
			}
		}
		
		private function setCascadeIn():void 
		{
			table.visible = false;
			cascadeView.setPosIn();
			
			
			//TweenLite.fromTo(table, 0.7, { visible:true, scaleX:0.35, scaleY:0.35, x:-125, y:108 }, { x:0, ease:Back.easeOut} );
		}
		
		private function right(e:MouseEvent):void 
		{
			var time:Number;
			
			SoundManager.play("menu_scrolling_button_click.mp3");
			SoundManager.playGroup("menu_animation");
			
			rightButton.next();
			leftButton.next();
			
			if (currentMenuState == "map") 
			{
				time = cascadeView.tweenOut(setCascadeIn);
				
				TweenLite.fromTo(table, 0.7, { visible:true, scaleX:0.35, scaleY:0.35, x:-125, y:108 }, { x:0, ease:Back.easeOut, delay:time} );
				
				TweenLite.to(picture, 1.2, {bezier:{type:"soft", values:[{x:350, y:110}, {x:350, y:200}]}});
				TweenLite.to(picture, 0.7, {scaleX:1,scaleY:1, delay:0.7, ease:Back.easeOut});
				
				TweenLite.to(cabinet, 0.5, {x:-60, ease:Back.easeIn});
				TweenLite.fromTo(cabinet, 0.5, { x:760 }, { x:700, delay:0.5, ease:Back.easeOut } );
				
				currentMenuState = "picture";
				
				
			} else if (currentMenuState == "picture")
			{
				TweenLite.to(table, 0.5, {x:-125, ease:Back.easeIn});
				TweenLite.fromTo(table, 0.5, { x:827 }, { x:700, delay:0.5, ease:Back.easeOut } );
				
				
				TweenLite.to(picture, 0.8, { scaleX:0.43, scaleY:0.43, ease:Back.easeInOut } );
				TweenLite.to(picture, 1.2, { bezier: { type:"soft", values:[ { x: -42, y:200 }, { x: -42, y:110 } ] }} );
				
				//TweenLite.to(picture, 0.7, { scaleX:0.43, scaleY:0.43, ease:Back.easeIn } );
				//TweenLite.to(picture, 1.2, { bezier: { type:"soft", values:[ { x:742, y:200 }, { x:742, y:110 } ] }} );	
				
				TweenLite.to(cabinet, 1.2, {bezier:{type:"soft", values:[{x:350, y:110}, {x:350, y:200}]}});
				TweenLite.to(cabinet, 0.7, {scaleX:1,scaleY:1, delay:0.7, ease:Back.easeOut});
				
				currentMenuState = "cabinet";
				
				
			} else  if (currentMenuState == "cabinet") 
			{
				
				TweenLite.to(picture, 0.5, {x:-130, ease:Back.easeIn});
				TweenLite.fromTo(picture, 0.5, { x:840 }, { x:700, delay:0.5, ease:Back.easeOut } );
				
				TweenLite.to(cabinet, 0.8, { scaleX:0.5, scaleY:0.5, ease:Back.easeInOut } );
				TweenLite.to(cabinet, 1.2, {bezier:{type:"soft", values:[{x:0, y:200}, {x:0, y:110}]}});
				
				TweenLite.to(table, 0.5, {x:840, ease:Back.easeIn, onComplete:cascadeView.setPosOut});
				TweenLite.set(table, {scaleX:1, scaleY:1, x:350, y:260, delay:0.5,onComplete:cascadeView.tweenIn} );
				
				//cascadeView.tweenIn();
				
				currentMenuState = "map";
				
				
			}
			
		}
		
		private function lowerMapIndex():void 
		{
			
		}
		
		private function higherMapIndex():void 
		{
			
		}
		
		
		private function left(e:MouseEvent):void 
		{
			var time:Number;
			
			SoundManager.play("menu_scrolling_button_click.mp3");
			SoundManager.playGroup("menu_animation");
			
			rightButton.prev();
			leftButton.prev();
			
			if (currentMenuState == "map") 
			{
				time = cascadeView.tweenOut(setCascadeIn);
				
				TweenLite.fromTo(table, 0.7, { visible:true, scaleX:0.35, scaleY:0.35, x:827, y:108 }, { x:700, ease:Back.easeOut, delay:time} );
				
				
				TweenLite.to(picture, 0.5, {x:840, ease:Back.easeIn});
				TweenLite.fromTo(picture, 0.5, { x:-130 }, { x:-42, delay:0.5, ease:Back.easeOut } );
				
				TweenLite.to(cabinet, 1.2, {bezier:{type:"soft", values:[{x:350, y:110}, {x:350, y:200}]}});
				TweenLite.to(cabinet, 0.7, { scaleX:1, scaleY:1, delay:0.7, ease:Back.easeOut } );
				
				//cascadeView.tweenOut();
				
				//TweenLite.to(picture, 0.7, { scaleX:0.43, scaleY:0.43, ease:Back.easeIn } );
				//TweenLite.to(picture, 1.2, {bezier:{type:"soft", values:[{x:-42, y:200}, {x:-42, y:110}]}});
				
				currentMenuState = "cabinet";
				
				
			} else if (currentMenuState == "picture") 
			{
				TweenLite.to(picture, 0.8, { scaleX:0.43, scaleY:0.43, ease:Back.easeInOut } );
				TweenLite.to(picture, 1.2, {bezier:{type:"soft", values:[{x:742, y:200}, {x:742, y:110}]}});	
				
				TweenLite.to(cabinet, 0.5, {x:760, ease:Back.easeIn});
				TweenLite.fromTo(cabinet, 0.5, { x:-60 }, { x:0, delay:0.5, ease:Back.easeOut } );
				
				TweenLite.to(table, 0.5, {x:-130, ease:Back.easeIn, onComplete:cascadeView.setPosOut});
				TweenLite.set(table, {scaleX:1, scaleY:1, x:350, y:260, delay:0.5,onComplete:cascadeView.tweenIn} );
				
				
				currentMenuState = "map";
			} else  if (currentMenuState == "cabinet") 
			{
				TweenLite.to(table, 0.5, {x:840, ease:Back.easeIn});
				TweenLite.fromTo(table, 0.5, { x:-130 }, { x:0, delay:0.5, ease:Back.easeOut } );
				
				TweenLite.to(picture, 1.2, {bezier:{type:"soft", values:[{x:350, y:110}, {x:350, y:200}]}});
				TweenLite.to(picture, 0.7, {scaleX:1,scaleY:1, delay:0.7, ease:Back.easeOut});
				
				TweenLite.to(cabinet, 0.8, { scaleX:0.5, scaleY:0.5, ease:Back.easeInOut } );
				TweenLite.to(cabinet, 1.2, {bezier:{type:"soft", values:[{x:700, y:200}, {x:700, y:110}]}});	
				
				currentMenuState = "picture";
			}
		}
		
		
		
		
		
		
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function showPicture(e:MouseEvent = null):void 
		{
			currentMenuState = "picture";
			
			rightButton.next();
			leftButton.next();
			
			cascadeView.tweenOut();
			
			TweenLite.to(picture, 1.2, {bezier:{type:"soft", values:[{x:350, y:110}, {x:350, y:200}]}});
			TweenLite.to(picture, 0.7, {scaleX:1,scaleY:1, delay:0.7, ease:Back.easeOut});
			
			
			TweenLite.to(cabinet, 0.5, {x:-60, ease:Back.easeIn});
			TweenLite.fromTo(cabinet, 0.5, { x:760 }, { x:700, delay:0.5, ease:Back.easeOut } );
			
			rightButton.removeEventListener(MouseEvent.CLICK, showPicture);
			rightButton.addEventListener(MouseEvent.CLICK, showCabinet);
		}
		
		private function showCabinet(e:MouseEvent = null):void 
		{
			if (currentMenuState == "map") 
			{
				cascadeView.tweenOut();
				TweenLite.to(picture, 0.5, {x:840, ease:Back.easeIn});
				TweenLite.fromTo(picture, 0.5, { x:-42 }, { x:-130, delay:0.5, ease:Back.easeOut } );
				rightButton.prev();
				leftButton.prev();
				leftButton.removeEventListener(MouseEvent.CLICK, showCabinet);
				
			} else 
			{
				hidePicture();
				rightButton.next();
				leftButton.next();
				rightButton.removeEventListener(MouseEvent.CLICK, showCabinet);
				
			}
			
			currentMenuState = "cabinet";
			TweenLite.to(cabinet, 1.2, {bezier:{type:"soft", values:[{x:350, y:110}, {x:350, y:200}]}});
			TweenLite.to(cabinet, 0.7, {scaleX:1,scaleY:1, delay:0.7, ease:Back.easeOut});
			
			leftButton.addEventListener(MouseEvent.CLICK, showPicture);
			rightButton.addEventListener(MouseEvent.CLICK, showMap);
		}
		
		private function showMap(e:MouseEvent = null):void 
		{
			currentMenuState = "map";
			hideCabinet();
			
			rightButton.next();
			leftButton.next();
			
			cascadeView.tweenIn();
			
			TweenLite.to(picture, 0.5, {x:-130, ease:Back.easeIn});
			TweenLite.fromTo(picture, 0.5, { x:840 }, { x:742, delay:0.5, ease:Back.easeOut } );
			
			rightButton.removeEventListener(MouseEvent.CLICK, showMap);
			rightButton.addEventListener(MouseEvent.CLICK, showPicture);
		}
		
		private function hidePicture():void 
		{
			TweenLite.to(picture, 0.7, { scaleX:0.43, scaleY:0.43, ease:Back.easeIn } );
			
			if (currentMenuState == "map") 
			{
				TweenLite.to(picture, 0.7, { scaleX:0.43, scaleY:0.43, ease:Back.easeIn } );
				TweenLite.to(picture, 1.2, {bezier:{type:"soft", values:[{x:742, y:200}, {x:742, y:110}]}});			
			} else if (currentMenuState == "cabinet") 
			{
				TweenLite.to(picture, 0.7, { scaleX:0.43, scaleY:0.43, ease:Back.easeIn } );
				TweenLite.to(picture, 1.2, {bezier:{type:"soft", values:[{x:-42, y:200}, {x:-42, y:110}]}});
			} 
		}
		
		private function hideCabinet():void 
		{
			
			
			if (currentMenuState == "picture") 
			{
				TweenLite.to(cabinet, 0.7, { scaleX:0.5, scaleY:0.5, ease:Back.easeIn } );
				TweenLite.to(cabinet, 1.2, {bezier:{type:"soft", values:[{x:700, y:200}, {x:700, y:110}]}});			
			} else if (currentMenuState == "map") 
			{
				TweenLite.to(cabinet, 0.7, { scaleX:0.5, scaleY:0.5, ease:Back.easeIn } );
				TweenLite.to(cabinet, 1.2, {bezier:{type:"soft", values:[{x:0, y:200}, {x:0, y:110}]}});
			} 
		}
		
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		
		
		
		
		
		
		
		
		
		/*public function showCabinet(e:MouseEvent = null):void 
		{
			rightButton.next();
			leftButton.next();
			
			cascadeView.tweenOut();
			
			TweenLite.to(cabinet, 1.2, {bezier:{type:"soft", values:[{x:350, y:110}, {x:350, y:200}]}});
			TweenLite.to(cabinet, 0.7, {scaleX:1,scaleY:1, delay:0.7, ease:Back.easeOut});
		}*/
		
		private function initSecondMenu():void 
		{
			//secondMenu.start.addEventListener(MouseEvent.CLICK, hideSecondMenu);
			//secondMenu.right.addEventListener(MouseEvent.CLICK, levelButtons);
			//secondMenu.left.addEventListener(MouseEvent.CLICK, levelButtons);
		}
		
		
		
		private function levelButtons(e:MouseEvent=null):void 
		{
			if (e.target.name == "right") 
			{
				//secondMenu.levels.gotoAndStop(secondMenu.levels.currentFrame + 1);
				
			} else if (e.target.name == "left") 
			{
				//secondMenu.levels.gotoAndStop(secondMenu.levels.currentFrame-1);
			}
		}
		
		private function hideSecondMenu(e:MouseEvent=null):void 
		{
			this.addChild(clouds);
			clouds.play();
			
			playButton.removeEventListener(MouseEvent.CLICK, hideSecondMenu);
			
			//cloudSound.play();
			//cascadeView.tweenOut();
			
			
			TweenLite.delayedCall(25, start, null, true);
			TweenLite.delayedCall(65, removeClouds, null, true);
			
			//TweenLite.to(secondMenu,0.8, {scaleX:0,scaleY:0, ease:Back.easeIn, onComplete:showClouds});
		}
		
		private function nextLevelCallback():void 
		{
			this.addChild(clouds);
			clouds.play();
			
			TweenLite.delayedCall(25, gc.loadNextlevel, null, true);
			TweenLite.delayedCall(65, removeClouds, null, true);
			
		}
		
		private function nextlevel():void 
		{
			
		}
		
		private function toMenuCallback():void 
		{
			this.addChild(clouds);
			clouds.play();
			
			checkAvailableTableElements();
			checkItems();
			updateDayAndScore();
			Settings.newUnlocks = false;
			
			TweenLite.delayedCall(25, gc.unloadAll, null, true);
			TweenLite.delayedCall(25, reloadMenu, null, true);
			TweenLite.delayedCall(65, removeClouds2, null, true);
			
			//playButton.addEventListener(MouseEvent.CLICK, hideSecondMenu);
			
		}
		
		private function reloadMenu():void 
		{
			this.removeChild(gameLayer);
			
			this.addChildAt(secondMenu,0);
			this.addChildAt(bg,0);
			this.addChildAt(mainMenu,0);
			
			secondMenu.scaleX = 0;
			secondMenu.scaleY = 0;
			secondMenu.visible = true;
			
			TweenLite.to(secondMenu,0.8, {scaleX:1,scaleY:1, ease:Back.easeOut, onComplete:initSecondMenu});
			
		}
		
		private function showClouds():void 
		{
			this.addChild(clouds);
			clouds.play();
		}
		
		private function removeClouds():void 
		{
			this.removeChild(clouds);
			clouds.gotoAndStop(1);
			gc.go();
		}
		
		private function removeClouds2():void 
		{
			this.removeChild(clouds);
			clouds.gotoAndStop(1);
			
			playButton.addEventListener(MouseEvent.CLICK, hideSecondMenu);
			
			
		}
		
		
		private function start(e:MouseEvent=null):void 
		{
			//secondMenu.start.removeEventListener(MouseEvent.CLICK,start);
			
			SoundManager.playGroup("button_click");
			
			this.removeChild(bg);
			this.removeChild(mainMenu);
			this.removeChild(secondMenu);
			
			this.addChildAt(gameLayer, 0);
			
			if (!gc) 
			{
				gc = new GameController();
				gc.init(gameLayer);
				
			}
			
			gc.loadLevel(new LevelOne);
			
			
			/*if (secondMenu.levels.currentFrame == 1) 
			{
				gc.loadLevel(new LevelOne);
			} else if (secondMenu.levels.currentFrame == 2) 
			{
				gc.loadLevel(new LevelTwo);
			} else if (secondMenu.levels.currentFrame == 3) 
			{
				gc.loadLevel(new LevelThree);
			}*/
			
			
			
			
			//cloudSound.play();
		}

	}

}