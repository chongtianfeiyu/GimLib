package gim.components
{
	import caurina.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mx.controls.sliderClasses.Slider;

	public class GimAlbum extends Sprite
	{
		public function GimAlbum(
			$width:Number,
			$height:Number,
			$urls:Array,
			$horizontal:Boolean = true,
			$autoPlay:Boolean = true,
			$delay:int = 3000,
			$thumbVisible:Boolean = true,
			$mainPercent:Number = 0.9,
			$thumbVisibleNumber:Number = 6,
			$sliderVisible:Boolean = true,
			$backgroundColor:uint = 0xAAAAAA,
			$backgroundAlpha:Number = 0)
		{
			//set size and draw background
			drawRect($width,$height,this,$backgroundColor,$backgroundAlpha);
			
			//initialize data
			thumbVisible = $thumbVisible;
			sliderVisible = $sliderVisible;
			autoPlay = $autoPlay;
			delay = $delay;
			thumbNumber = $thumbVisibleNumber;
			horizontal = $horizontal;
			sliderSize = 20;
			thumbPadding = 6;
			
			//set container data
			if(horizontal)
			{
				sliderLength = $width - 80;
				mainContainerWidth = $width;
				mainContainerHeight = ($height - (sliderVisible ? sliderSize : 0)) * (thumbVisible ? $mainPercent : 1);
				thumbContainerWidth = $width;
				thumbContainerHeight = ($height - (sliderVisible ? sliderSize : 0)) * (1 - $mainPercent);
				thumbWidth = thumbContainerWidth / $thumbVisibleNumber;
				thumbHeight = thumbContainerHeight;
			}
			else
			{
				sliderLength = $height - 80;
				mainContainerWidth = ($width - (sliderVisible ? sliderSize : 0)) * (thumbVisible ? $mainPercent : 1);
				mainContainerHeight = $height;
				thumbContainerWidth = ($width - (sliderVisible ? sliderSize : 0)) * (1 - $mainPercent);
				thumbContainerHeight = $height;
				thumbWidth = thumbContainerWidth;
				thumbHeight = thumbContainerHeight / $thumbVisibleNumber;
			}
			
			//init containers
			
			//mainContainer
			mainBitmapContainer = new Sprite();
			this.addChild(mainBitmapContainer);
			drawRect(mainContainerWidth,mainContainerHeight,mainBitmapContainer,0xAAAAAA,0);
			mainBitmapContainer.addEventListener(MouseEvent.MOUSE_DOWN,onMainBitmapContainerMouseDown);
			
			var mainBCMask:Sprite = new Sprite();
			addChild(mainBCMask);
			drawRect(mainContainerWidth,mainContainerHeight,mainBCMask,0xAAAAAA,0);
			mainBitmapContainer.mask = mainBCMask;
			
			//thumbContainer
			if(thumbVisible)
			{
				thumbContainer = new Sprite();
				addChild(thumbContainer);
				drawRect(thumbContainerWidth,thumbContainerHeight,thumbContainer,0xAAAAAA,0);
				$horizontal ? thumbContainer.y = mainContainerHeight : thumbContainer.x = mainContainerWidth;
				
				var thumbContainerMask:Sprite = new Sprite();
				addChild(thumbContainerMask);
				thumbContainer.mask = thumbContainerMask;
				drawRect(thumbContainerWidth,thumbContainerHeight,thumbContainerMask,0xAAAAAA,0);
				thumbContainerMask.x = thumbContainer.x;
				thumbContainerMask.y = thumbContainer.y;
			
				//slider
				if(sliderVisible)
				{
					slider = new Sprite();
					addChild(slider);
					
					//line
					var line:Sprite = new Sprite();
					slider.addChild(line);
					line.graphics.lineStyle(6,0xCCCCCC,1);
					line.graphics.moveTo(0,0);
					line.graphics.lineTo(sliderLength,0);
					line.graphics.endFill();
					
					//block
					block = new Sprite();
					slider.addChild(block);
					block.graphics.beginFill(0x666666,1);
					block.graphics.drawRoundRect(-30,sliderSize * -0.3,60,sliderSize * 0.6,6,6);
					block.graphics.endFill();
					block.filters = [new DropShadowFilter(0,0,0,0.6)];
					
					//slider position
					if($horizontal) 
					{
						slider.x = ($width - sliderLength) * 0.5;
						slider.y = $height - (sliderSize * 0.5);
					}
					else
					{
						slider.rotation = 90;
						slider.x = $width - (sliderSize * 0.5);
						slider.y = ($height - sliderLength) * 0.5;
					}
				}
			}
			
			playURLs($urls);
		}
		
		public function playURLs(newsImageURLs:Array):void
		{
			imageURLs = newsImageURLs;
			
			if(thumbVisible)
			{
				//clear thumbContainer
				thumbs = [];
				while(thumbContainer.numChildren > 0)
				{
					CenterAlignBitmap(Sprite(thumbContainer.removeChildAt(0)).getChildAt(0)).dispose();
				}
				
				//thumbs
				for (var i:int = 0;i < imageURLs.length;i ++)
				{
					//new thumb
					var thumb:Sprite = new Sprite();
					drawRect(thumbWidth,thumbHeight,thumb,0x0000ff,0);
					horizontal ? thumb.x = i * thumbWidth : thumb.y = i * thumbHeight;
					thumbContainer.addChild(thumb);
					thumbs.push(thumb);
					thumb.addEventListener(MouseEvent.CLICK,onThumbClick);
					
					//add bitmap from url
					var url:String = imageURLs[i];
					var bitmap:CenterAlignBitmap = new CenterAlignBitmap(url,thumbWidth,thumbHeight,true);
					thumb.addChild(bitmap);
					bitmap.filters = [new DropShadowFilter(0,90,0,0.8,thumbPadding * 0.5,thumbPadding * 0.5)];
					
					var bitmapMask:Sprite = new Sprite();
					thumb.addChild(bitmapMask);
					drawRect(thumbWidth - (thumbPadding * 2),thumbHeight - (thumbPadding * 2),bitmapMask,0,1);
					bitmapMask.x = thumbPadding;
					bitmapMask.y = thumbPadding;
					bitmap.mask = bitmapMask;
				}
			}
			
			//initializing
			this.currentSelectedIndex = 0;
		}

		protected function onMainBitmapContainerMouseDown(event:MouseEvent):void
		{
			origMBContainerX = mainBitmapContainer.mouseX;
			origMBContainerY = mainBitmapContainer.mouseY;
			
			addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			addEventListener(MouseEvent.MOUSE_UP,onMouseOut);
			addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
		}
		private var deltaX:Number;
		private var deltaY:Number;
		private var origMBContainerX:Number;
		private var origMBContainerY:Number;
		
		protected function onMouseMove(event:MouseEvent):void
		{
			deltaX = mainBitmapContainer.mouseX - origMBContainerX;
			deltaY = mainBitmapContainer.mouseY - origMBContainerY;
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			var deltaDis:Number = horizontal ? deltaX :deltaY;
			
			if(deltaDis < 0)
			{
				if(currentSelectedIndex < imageURLs.length - 1) playNext();
			}
			else
			{
				if( currentSelectedIndex > 0) playNext(false);
			}
			
			removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			removeEventListener(MouseEvent.MOUSE_UP,onMouseOut);
			removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
		}
		
		/**
		 * click thumb
		 * */
		private function onThumbClick(e:MouseEvent):void
		{
			currentSelectedIndex = thumbs.indexOf(e.currentTarget);
		}
		
		/**
		 * play next image
		 * */
		private function playNext(forward:Boolean = true):void
		{
			var index:int = currentSelectedIndex;
			forward ? index ++ : index --;
			if(index > imageURLs.length - 1) index = 0;
			else if(index < 0) index = imageURLs.length - 1;
			currentSelectedIndex = index;
		}
		
		/**
		 * set for change current visible image in mainContainer
		 * @param index 
		 * */
		public function set currentSelectedIndex(index:int):void
		{
			if(_currentSelectedIndex == index) return;
			
			//reset timeOut
			clearTimeout(intervalId);
			if(autoPlay) intervalId = setTimeout(playNext,delay);
			
			if(index < imageURLs.length)
			{
				//mainBitmap change
				//remove old bitmap
				while(mainBitmapContainer.numChildren > 1)
				{
					CenterAlignBitmap(mainBitmapContainer.removeChildAt(1)).dispose();;
				}
				
				if((mainBitmapContainer.numChildren > 0))
				{
					var bmp:CenterAlignBitmap = mainBitmapContainer.getChildAt(0) as CenterAlignBitmap;
					Tweener.removeTweens(bmp);
					var completeFunc:Function = function():void
					{
						bmp.parent.removeChild(bmp);
						bmp.dispose();
					}
					if(horizontal)
						Tweener.addTween(bmp,{x:mainContainerWidth * - 0.5 * (index > _currentSelectedIndex ? 1 : -3),time:1,onComplete:completeFunc });
					else
						Tweener.addTween(bmp,{y:mainContainerHeight * - 0.5 * (index > _currentSelectedIndex ? 1 : -3),time:1,onComplete:completeFunc });
				}
				
				//add new bitmap from url
				var url:String = imageURLs[index];
				var mainBitmap:CenterAlignBitmap = new CenterAlignBitmap(url,mainContainerWidth,mainContainerHeight);
				mainBitmap.filters = [new DropShadowFilter(0,0,0,0.8,10,10)];
				mainBitmapContainer.addChild(mainBitmap);
				mainBitmap.alpha = 0;
				if(horizontal)
				{
					mainBitmap.x = mainContainerWidth * 1.5 * (index > _currentSelectedIndex ? 1 : -1);
					Tweener.addTween(mainBitmap,{x:mainContainerWidth * 0.5,alpha:1,time:1});
				}
				else
				{
					mainBitmap.y = mainContainerHeight * 1.5 * (index > _currentSelectedIndex ? 1 : -1);
					Tweener.addTween(mainBitmap,{y:mainContainerHeight * 0.5,alpha:1,time:1});
				}
				
				if(thumbVisible)
				{
					//highlight current thumb
					for each(var thumb:Sprite in thumbs) thumb.alpha = 0.5;
					if(index < thumbs.length) thumbs[index].alpha = 1;
					
					//slider change
					var blockStep:Number = sliderLength / imageURLs.length;
					Tweener.removeTweens(block);
					Tweener.addTween(block,{x:index * blockStep + blockStep * 0.5,time:1});
					
					//thumbContainer change
					var aimPos:Number = horizontal ? thumbContainerWidth * 0.5 - (index + 0.5)* thumbWidth : thumbContainerHeight * 0.5 - (index + 0.5)* thumbHeight;
					var minPos:Number = horizontal ? thumbContainerWidth - imageURLs.length * thumbWidth :  thumbContainerHeight - imageURLs.length * thumbHeight;
					if(aimPos > 0) aimPos = 0;
					else if(aimPos < minPos) aimPos = minPos;
					Tweener.removeTweens(thumbContainer);
					horizontal ? Tweener.addTween(thumbContainer,{x:aimPos,time:1}) : Tweener.addTween(thumbContainer,{y:aimPos,time:1});
				}
				
				//set current selected index
				_currentSelectedIndex = index;
				
				//run change functions
				for each(var func:Function in changeFuncs)
				{
					func();
				}
			}
		}
		
		/**
		 * regist change functions
		 * */
		public function regChangeFunc(func:Function):void
		{
			changeFuncs.push(func);
		}
		private var changeFuncs:Array = [];
		
		public function get currentSelectedIndex():int
		{
			return _currentSelectedIndex;
		}
		private var _currentSelectedIndex:int = -1;
		
		//assist functions////////////////////////		
		private function drawRect($width:Number, $height:Number, $sprite:Sprite, $color:uint = 0xFFFFFF,$alpha:Number = 0.3):void
		{
			$sprite.graphics.beginFill($color,$alpha);
			$sprite.graphics.drawRect(0,0,$width,$height);
			$sprite.graphics.endFill();
		}
		
		//variables///////////////////////////////
		private var intervalId:uint;
		private var thumbVisible:Boolean;
		private var sliderVisible:Boolean;
		private var autoPlay:Boolean;
		private var delay:int;
		private var imageURLs:Array;
		private var horizontal:Boolean;
		private var sliderLength:Number;
		private var sliderSize:Number;
		private var mainContainerWidth:Number;
		private var mainContainerHeight:Number;
		private var thumbNumber:int;
		private var thumbContainerWidth:Number;
		private var thumbContainerHeight:Number;
		private var thumbWidth:Number;
		private var thumbHeight:Number;
		private var thumbPadding:Number;
		
		private var thumbs:Array;
		private var slider:Sprite;
		private var block:Sprite;
		private var mainBitmapContainer:Sprite;
		private var thumbContainer:Sprite;
	}
}

import flash.display.Bitmap;
import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.net.URLRequest;

import spark.primitives.Rect;

class CenterAlignBitmap extends Sprite
{
	/**
	 * center align image
	 * @param $url image source
	 * @param $containerWidth container width
	 * @param $containerHeight container height
	 * @param $shearBitmap is shear image
	 * */
	public function CenterAlignBitmap($url:String,$containerWidth:Number = 100,$containerHeight:Number = 100,$shearBitmap:Boolean = false)
	{
		url = $url;
		containerWidth = $containerWidth;
		containerHeight = $containerHeight;
		isCutBitmap = $shearBitmap;
		
		var loader:Loader = new Loader();
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoad);
		loader.load(new URLRequest($url));
	}
	public var url:String;
	private var containerWidth:Number;
	private var containerHeight:Number;
	private var isCutBitmap:Boolean;
	private var bitmap:Bitmap;
	
	protected function onLoad(event:Event):void
	{
		bitmap = event.currentTarget.content as Bitmap;
		bitmap.x = bitmap.bitmapData.width * - 0.5;
		bitmap.y = bitmap.bitmapData.height * - 0.5;
		addChild(bitmap);
		if(containerWidth && containerHeight)
		{
			var scaleW:Number = containerWidth / bitmap.bitmapData.width;
			var scaleH:Number = containerHeight / bitmap.bitmapData.height;
			var scale:Number;
			if(isCutBitmap)
			{
				scale = scaleW > scaleH ? scaleW : scaleH;
			}
			else
			{
				scale = scaleW < scaleH ? scaleW : scaleH;
			}
			this.scaleX = this.scaleY = scale;
			this.x = containerWidth * 0.5;
			this.y = containerHeight * 0.5;
		}
	}
	
	public function dispose():void
	{
		if(bitmap)
		{
			bitmap.bitmapData.dispose();
			bitmap = null;
		}
	}
}